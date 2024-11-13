import React from "react";
import { Link } from "react-router-dom";
import "./NavBar.css";

export const NavBar = () => (
  <nav className="navbar">
    <h1 className="navbar-title">
      <Link to="/">Movie Recommendation System</Link>
    </h1>
    <div className="dropdown">
      <button className="dropbtn">
        <span className="hamburger-icon">&#9776;</span>
      </button>
      <div className="dropdown-content">
        <Link to="/login">Login</Link>
        <Link to="/genres">Select Genres</Link>
      </div>
    </div>
  </nav>
);
