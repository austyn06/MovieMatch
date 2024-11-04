import React, { useState, useEffect } from "react";
import "./App.css";

function App() {
  const [movies, setMovies] = useState([]);

  const bucketName = "team-7-tmdb-movie-data-a1b2c3";
  const fileName = "movie_data.json";
  const s3Url = `https://${bucketName}.s3.amazonaws.com/${fileName}`;

  useEffect(() => {
    fetch(s3Url)
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
