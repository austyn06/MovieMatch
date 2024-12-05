import React, { useState, useEffect } from "react";
import { MovieList } from "./movie-list/MovieList";
import { MovieModal } from "./movie-modal/MovieModal";
import { NavBar } from "./navbar/NavBar";
import genres from "./genres";
import { API, Auth } from "aws-amplify";

function App({ selectedGenres, searchQuery, setSearchQuery }) {
  const [movies, setMovies] = useState([]);
  const [selectedMovie, setSelectedMovie] = useState(null);

  const fetchMovies = async () => {
    try {
      let queryString = {};
      if (selectedGenres && selectedGenres.length > 0) {
        const genreIds = selectedGenres.map((g) => g.id).join(",");
        queryString = { genres: genreIds };
      }
      if (searchQuery) {
        queryString = { search: searchQuery };
      }

      const data = await API.get("MovieAPI", "/movies", {
        queryStringParameters: queryString
      });

      console.log("Fetch data: ", data.results);
      setMovies(data.results);
    } catch (err) {
      console.log("Error fetching movies:", err);
    }
  };

  useEffect(() => {
    fetchMovies();
  }, [selectedGenres, searchQuery]);

  const clickMovie = (movie) => {
    setSelectedMovie(movie);
  };

  const closeModal = () => {
    setSelectedMovie(null);
  };

  return (
    <div className="container">
      <NavBar setSearchQuery={setSearchQuery} />
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
