import React, { useState } from "react";
import { useNavigate } from "react-router-dom";
import genres from "../genres";
import "./SelectGenres.css";

export const SelectGenres = ({ selectedGenres, setSelectedGenres }) => {
  const [selectedGenreIds, setSelectedGenreIds] = useState(
    selectedGenres.map((genre) => genre.id)
  );
  const navigate = useNavigate();

  const toggleGenre = (genreId) => () => {
    if (selectedGenreIds.includes(genreId)) {
      setSelectedGenreIds(selectedGenreIds.filter((id) => id !== genreId));
    } else {
      setSelectedGenreIds([...selectedGenreIds, genreId]);
    }
  };

  const handleSubmit = () => {
    const selected = genres.filter((g) => selectedGenreIds.includes(g.id));
    setSelectedGenres(selected);
    console.log("Selected genres: ", selected);
    navigate("/");
  };

  return (
    <div className="select-genre">
      <h2>Select Your Favorite Genres</h2>

      <div className="genre-list">
        {genres.map((genre) => (
          <div
            key={genre.id}
            className={`genre-button ${
              selectedGenreIds.includes(genre.id) ? "selected" : ""
            }`}
            onClick={toggleGenre(genre.id)}
          >
            {genre.name}
          </div>
        ))}
      </div>

      <button className="genre-submit-button" onClick={handleSubmit}>
        Get Recommendations
      </button>
    </div>
  );
};
