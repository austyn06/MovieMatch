import React, { useState, useEffect } from "react";
import { MovieList } from "./movie-list/MovieList";
import { MovieModal } from "./movie-modal/MovieModal";
import { NavBar } from "./navbar/NavBar";
import genres from "./genres";
import { API } from "aws-amplify";

function App({ selectedGenres }) {
  const [movies, setMovies] = useState([]);
  const [selectedMovie, setSelectedMovie] = useState(null);

  useEffect(() => {
    const fetchMovies = async () => {
      try {
        let queryString = "";
        if (selectedGenres.length > 0) {
          const genreIds = selectedGenres.map((g) => g.id).join(",");
          queryString = `?genres=${genreIds}`;
        }

        const data = await API.get("MovieAPI", queryString);
        setMovies(data.results);
      } catch (err) {
        console.log("Error fetching movies:", err);
      }
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
