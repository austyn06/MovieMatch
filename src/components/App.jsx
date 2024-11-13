import React, { useState, useEffect } from "react";
import { MovieList } from "./movie-list/MovieList";
import { MovieModal } from "./movie-modal/MovieModal";
import { NavBar } from "./navbar/NavBar";
import genres from "./genres";

function App({ selectedGenres }) {
  // const bucketName = "team-7-tmdb-movie-data-a1b2c3";
  // const fileName = "movie_data.json";
  // const s3StringOriginal = `https://${bucketName}.s3.amazonaws.com/${fileName}`;
  const [movies, setMovies] = useState([]);
  const [selectedMovie, setSelectedMovie] = useState(null);

  useEffect(() => {
    const fetchMovies = async () => {
      const apiKey = "805e414f9ae84a75b0cf3d95476e199a";
      let url = `https://api.themoviedb.org/3/movie/popular?api_key=${apiKey}`; // Show popular movies by default
      
      // If genres are selected, fetch movies based on selected genres
      if (selectedGenres.length > 0) {
        const genreIds = selectedGenres.map((g) => g.id).join(",");
        url = `https://api.themoviedb.org/3/discover/movie?api_key=${apiKey}&with_genres=${genreIds}`;
      }
      
      fetch(url)
        .then((response) => response.json())
        .then((data) => setMovies(data.results))
        .catch((error) => console.log("Error fetching movie data:", error));
    };

    fetchMovies();
  }, [selectedGenres]);

  const clickMovie = (movie) => {
    setSelectedMovie(movie);
  };

  const closeModal = () => {
    setSelectedMovie(null);
  };

  return (
    <div className="container">
      <NavBar />
      <MovieList movies={movies} clickMovie={clickMovie} />
      {selectedMovie && (
        <MovieModal
          movie={selectedMovie}
          genres={genres}
          closeModal={closeModal}
        />
      )}
    </div>
  );
}

export default App;
