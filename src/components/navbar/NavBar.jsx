import React, {useState} from "react";
import { Link } from "react-router-dom";
import "./NavBar.css";

export const NavBar = ({setSearchQuery}) => {
  const [search, setSearch] = useState('');

  const submitSearch = () => {
    let finalSearch = search.replace(" ", "+");
    console.log(`search query: ${finalSearch}`);
    setSearchQuery(finalSearch);
  }

  return ( 
    <nav className="navbar">
    <h1 className="navbar-title">
      <Link to="/">Movie Recommendation System</Link>
    </h1>
    <input type="text" value={search} className="search-bar" onChange={e => setSearch(e.target.value)} />
    <button type="button" onClick={submitSearch}>Search</button>
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
};
