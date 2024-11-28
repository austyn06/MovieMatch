import React, { useState } from "react";
import { NavLink } from "react-router-dom";
import "./NavBar.css";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faSearch, faSignOut, faFilm } from "@fortawesome/free-solid-svg-icons";

export const NavBar = ({ setSearchQuery }) => {
  const [search, setSearch] = useState("");

  const submitSearch = (e) => {
    e.preventDefault();
    const finalSearch = search.trim().replace(/\s+/g, "+");
    console.log(`search query: ${finalSearch}`);
    setSearchQuery(finalSearch);
  };

  return (
    <nav className="navbar">
      <h1 className="navbar-title">
        <NavLink to="/movies">MovieMatch</NavLink>
      </h1>
      <form className="search-container" onSubmit={submitSearch}>
        <input
          className="search-input"
          type="text"
          placeholder="Search"
          value={search}
          onChange={(e) => setSearch(e.target.value)}
        />
        <button type="submit" className="search-button">
          <FontAwesomeIcon icon={faSearch} className="search-icon" />
        </button>
      </form>
      <div className="nav-links">
        <NavLink
          to="/movie-genres"
          className="nav-link"
          activeClassName="active"
        >
          <FontAwesomeIcon icon={faFilm} />
          Genres
        </NavLink>
        <NavLink to="/" className="nav-link" activeClassName="active">
          <FontAwesomeIcon icon={faSignOut} />
          Logout
        </NavLink>
      </div>
    </nav>
  );
};
