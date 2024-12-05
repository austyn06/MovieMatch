import React, { useState } from "react";
import { NavLink, useNavigate } from "react-router-dom";
import "./NavBar.css";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faSearch, faSignOut, faFilm } from "@fortawesome/free-solid-svg-icons";
import { Auth } from "aws-amplify";

export const NavBar = ({ setSearchQuery }) => {
  const [search, setSearch] = useState("");
  const navigate = useNavigate(); // Hook for navigation

  const submitSearch = (e) => {
    e.preventDefault();
    const finalSearch = search.trim().replace(/\s+/g, "+");
    console.log(`search query: ${finalSearch}`);
    setSearchQuery(finalSearch);
  };

  const handleLogout = async () => {
    try {
      await Auth.signOut(); // Log out the user
      console.log("User logged out successfully");
      navigate("/"); // Redirect to login page
      window.location.reload();
    } catch (error) {
      console.error("Error during logout", error);
    }
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
        >
          <FontAwesomeIcon icon={faFilm} />
          Genres
        </NavLink>
        <button onClick={handleLogout} className="nav-link">
          <FontAwesomeIcon icon={faSignOut} />
          Logout
        </button>
      </div>
    </nav>
  );
};
