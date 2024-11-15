import React, { useEffect, useState } from "react";
import genresList from "../genres";
import "./MovieModal.css";

export const MovieModal = ({ movie, genres, closeModal }) => {
  const [isExpanded, setIsExpanded] = useState(false);
  const movieGenres = movie.genre_ids.map(
    (id) => genresList.find((g) => g.id === id)?.name || "Unknown"
  );

  useEffect(() => {
    document.body.classList.add("modal-open");
    return () => {
      document.body.classList.remove("modal-open");
    };
  }, []);

  const toggleReadMore = () => {
    setIsExpanded(!isExpanded);
  };

  const handleLikeDislike = (isLiked) => {
    // Implement the logic to like or dislike the movie
  }

  return (
    <div className="modal-overlay" onClick={closeModal}>
      <div className="modal-content" onClick={(e) => e.stopPropagation()}>
        <div className="modal-body">
          <img
            src={`https://image.tmdb.org/t/p/w500${movie.poster_path}`}
            alt={movie.title}
            className="modal-movie-poster"
          />
          <div className="modal-movie-details">
            <h2 className="modal-movie-title">{movie.title}</h2>
            <div className="modal-movie-meta">
              <span className="modal-movie-year">
                {movie.release_date.split("-")[0]}
              </span>
              <span className="modal-separator">||</span>
              <span className="modal-movie-genres">
                {movieGenres.join(" | ")}
              </span>
            </div>
            <div className="modal-movie-rating">Rating: {movie.vote_average.toFixed(2)} / 10</div>
            <p className="modal-movie-synopsis">
              {isExpanded
                ? movie.overview
                : `${movie.overview.slice(0, 100)}...`}
              {movie.overview.length > 100 && (
                <button className="modal-read-more" onClick={toggleReadMore}>
                  {isExpanded ? "Show Less" : "Read More"}
                </button>
              )}
            </p>
            <div className="modal-actions">
              <button className="modal-like-button" onClick={() => handleLikeDislike(true)}>Liked</button>
              <button className="modal-dislike-button" onClick={() => handleLikeDislike(false)}>Disliked</button>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};