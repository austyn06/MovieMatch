import React from "react";
import "./MovieList.css";

export const MovieList = ({ movies, clickMovie }) => {
  <div className="movie-list">
    {movies.map((movie) => (
      <div
        key={movie.id}
        className="movie-card"
        onClick={() => clickMovie(movie)}
      >
        <img
          src={`https://image.tmdb.org/t/p/w200${movie.poster_path}`}
          alt={movie.title}
          className="movie-poster"
        />
        <h2 className="movie-title">{movie.title}</h2>
      </div>
    ))}
  </div>
};
