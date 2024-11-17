import json
import boto3
import os
import urllib.request
from urllib.error import URLError, HTTPError
from gremlin_python.driver import client, serializer

api_key = None

def lambda_handler(event, context):
    global api_key
    
    secrets_client = boto3.client(service_name="secretsmanager", region_name="us-east-1")
    s3_client = boto3.client(service_name="s3", region_name="us-east-1")
    
    secret_name = os.environ["TMDB_SECRET_NAME"]
    bucket_name = os.environ["MOVIE_DATA_BUCKET"]
    neptune_endpoint = os.environ["NEPTUNE_ENDPOINT"]

    neptune_client = client.Client(
        f"wss://{neptune_endpoint}:8182/gremlin", 'g',
        message_serializer=serializer.GraphSONSerializersV2d0()
    )
    
    if not api_key:
        try:
            response = secrets_client.get_secret_value(SecretId=secret_name)
            secret_string = response["SecretString"]
            try:
                api_key = json.loads(secret_string)["tmdb_api_key"]
            except json.JSONDecodeError:
                api_key = secret_string
        except Exception as e:
            print(f"Error fetching secret: {e}")
            return {"statusCode": 500, "body": "Error fetching API key from Secrets Manager"}
    else:
        print("Using cached API key")

    
    genres = []
    if 'queryStringParameters' in event and event['queryStringParameters']:
        genres_param = event['queryStringParameters'].get('genres', '')
        if genres_param:
            genres = genres_param.split(',')

    if genres:
        genre_ids = ','.join(genres)
        url = f"https://api.themoviedb.org/3/discover/movie?api_key={api_key}&with_genres={genre_ids}"
    else:
        url = f"https://api.themoviedb.org/3/movie/popular?api_key={api_key}"

    try:
        with urllib.request.urlopen(url) as response:
            movie_data = json.loads(response.read())
    except (URLError, HTTPError) as e:
        print(f"Error fetching data from TMDB API: {e}")
        return {"statusCode": 500, "body": "Error fetching data from TMDB API"}

    try:
        s3_client.put_object(
            Bucket=bucket_name,
            Key="movie_data.json",
            Body=json.dumps(movie_data),
            ContentType="application/json"
        )
        print("Movie data uploaded to S3 successfully.")
    except Exception as e:
        print(f"Error uploading data to S3: {e}")
        return {"statusCode": 500, "body": "Error uploading data to S3"}
    
    try:
        for movie in movie_data:
            title = movie['title']
            movie_id = movie['id']
            genres = movie['genre_ids']
            
            neptune_client.submit(
                f"g.addV('Movie').property('title', '{title}').property('id', '{movie_id}')"
            )

            for genre_id in genres:
                neptune_client.submit(
                    f"g.V().has('Genre', 'id', '{genre_id}').fold().coalesce(unfold(), addV('Genre').property('id', '{genre_id}'))"
                )
                neptune_client.submit(
                    f"g.V().has('Movie', 'id', '{movie_id}').addE('BELONGS_TO').to(g.V().has('Genre', 'id', '{genre_id}'))"
                )
        print("Movies and genres stored in Neptune successfully.")
    except Exception as e:
        print(f"Error storing data in Neptune: {e}")
        return {"statusCode": 500, "body": "Error storing data in Neptune"}
    
    return {"statusCode": 200, "body": "Movie data stored in S3 successfully"}