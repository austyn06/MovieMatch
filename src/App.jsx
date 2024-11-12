import React, { useState, useEffect } from "react";
import "./App.css";
import { Amplify } from 'aws-amplify';

Amplify.configure({
  Auth: {
    region: 'us-east-1',
    userPoolId: 'us-east-1_fNBa2g3Gs',
    userPoolWebClientId: '10gn06qn308vmrse43j6obkrts',
  },
});

function App() {
  const [movies, setMovies] = useState([]);

  // const bucketName = "team-7-tmdb-movie-data-a1b2c3";
  // const fileName = "movie_data.json";
  // const s3Url = `https://${bucketName}.s3.amazonaws.com/${fileName}`;

  // Use TMDb API URL for local development
  const apiKey = "805e414f9ae84a75b0cf3d95476e199a"; // Avoid committing this
  const tmdbUrl = `https://api.themoviedb.org/3/movie/popular?api_key=${apiKey}`;

  useEffect(() => {
    fetch(tmdbUrl) //change this to s3Url
      .then((response) => response.json())
      .then((data) => setMovies(data.results))
      .catch((error) => console.log("Error fetching movie data:", error));
  }, []);

  return (
    <div className="container">
      <h1>Movie Recommendation System</h1>

      <div className="movie-list">
        {movies.map((movie) => (
          <div key={movie.id} className="movie-card">
            <img
              src={`https://image.tmdb.org/t/p/w200${movie.poster_path}`}
              alt={movie.title}
              className="movie-poster"
            />
            <h2 className="movie-title">{movie.title}</h2>
          </div>
        ))}
      </div>
    </div>
  );
}

export default App;
