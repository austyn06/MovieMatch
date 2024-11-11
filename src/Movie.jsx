import React, { useState, useEffect } from "react";

export const Movie = ({ id, title, image, genres, synopsis }) => {
  const genresArray = {
    28: "Action",
    12: "Adventure",
    16: "Animation",
    35: "Comedy",
    80: "Crime",
    99: "Documentary",
    18: "Drama",
    10751: "Family",
    14: "Fantasy",
    36: "History",
    27: "Horror",
    10402: "Music",
    9648: "Mystery",
    10749: "Romance",
    878: "Science Fiction",
    10770: "TV Movie",
    53: "Thriller",
    10752: "War",
    37: "Western",
  };

  return (
    <div className="movie-details">
      <h2>{title}</h2>
      <img
        src={`https://image.tmdb.org/t/p/w200${image}`}
        alt={title}
        className="movie-poster"
      />
      <div>Genres:</div>
      <ul className="genres-list">
        {genres.map((genreId) => (
          <li key={genreId}>{genresArray[genreId]}</li>
        ))}
      </ul>
      <div className="synopsis">
        <strong>Synopsis:</strong>
        <p>{synopsis}</p>
      </div>
      <button className="liked">Liked</button>
      <button>Disliked</button>
    </div>
  );
};
