import json
import boto3
import os
import urllib.request
from urllib.error import URLError, HTTPError

api_key_cache = None

def lambda_handler(event, context):
    global api_key_cache
    
    secrets_client = boto3.client(service_name="secretsmanager", region_name="us-east-1")
    s3_client = boto3.client(service_name="s3", region_name="us-east-1")
    
    secret_name = os.environ["TMDB_SECRET_NAME"]
    bucket_name = os.environ["MOVIE_DATA_BUCKET"]
    
    if not api_key_cache:
        try:
            response = secrets_client.get_secret_value(SecretId=secret_name)
            secret_string = response["SecretString"]
            try:
                api_key_cache = json.loads(secret_string)["tmdb_api_key"]
            except json.JSONDecodeError:
                api_key_cache = secret_string
        except Exception as e:
            print(f"Error fetching secret: {e}")
            return {"statusCode": 500, "body": "Error fetching API key from Secrets Manager"}
    else:
        print("Using cached API key")

    url = f"https://api.themoviedb.org/3/movie/popular?api_key={api_key_cache}"
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
    return {"statusCode": 200, "body": "Movie data stored in S3 successfully"}