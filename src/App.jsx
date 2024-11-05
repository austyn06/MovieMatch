import React, { useState, useEffect } from "react";
import "./App.css";
import { Movie } from "./Movie";

function App() {
  const [movies, setMovies] = useState([]);
  const [clickedMovie, setClickedMovie] = useState({});
  const [showDetails, setShowDetails] = useState(false);

  const bucketName = "team-7-tmdb-movie-data-a1b2c3";
  const fileName = "movie_data.json";
  const s3StringOriginal = `https://${bucketName}.s3.amazonaws.com/${fileName}`;
  const s3Url = `https://api.themoviedb.org/3/movie/popular?api_key=${process.env.API_KEY}`;

  useEffect(() => {
    fetch(s3Url)
      .then((response) => response.json())
      .then((data) => setMovies(data.results))
      .catch((error) => console.log("Error fetching movie data:", error));
  }, []);

  const clickMovie = (id, title, image, genres, synopsis) => {
    setClickedMovie({"id": id, "title": title, "image": image, "genres": genres, "synopsis": synopsis});
    setShowDetails(true);
  }

  const backToHome = (e) => {
    e.preventDefault();
    setShowDetails(false);
  }

  return (
    <div className="container">
      <h1 onClick={(e) => backToHome(e)}><a href="/">Movie Recommendation System</a></h1>

      {showDetails ? 
      <Movie id={clickedMovie.id} title={clickedMovie.title} image={clickedMovie.image} genres={clickedMovie.genres} synopsis={clickedMovie.synopsis} />
      :
      <div className="movie-list">
        {movies.map((movie) => (
          <div key={movie.id} className="movie-card">
            <img
              src={`https://image.tmdb.org/t/p/w200${movie.poster_path}`}
              alt={movie.title}
              className="movie-poster"
              onClick={() => clickMovie(movie.id, movie.title, movie.poster_path, movie.genre_ids, movie.overview)}  
            />
            <h2 className="movie-title">{movie.title}</h2>
          </div>
        ))}
      </div>
      }
    </div>
  );
}

export default App;
