import React, { useState, useEffect } from "react";
import { StrictMode } from "react";
import { createRoot } from "react-dom/client";
import { BrowserRouter as Router, Routes, Route, Navigate } from "react-router-dom";
import "./index.css";
import App from "./components/App.jsx";
import { SelectGenres } from "./components/select-genres/SelectGenres.jsx";
import { Login } from "./components/login/login.jsx";
import { Amplify, Auth } from "aws-amplify";
import awsConfig from "./amplifyConfig";

Amplify.configure(awsConfig);

function Main() {
  const [selectedGenres, setSelectedGenres] = useState([]);
  const [searchQuery, setSearchQuery] = useState("");
  const [isAuthenticated, setIsAuthenticated] = useState(false);

  useEffect(() => {
    // Check if user is authenticated when the app loads
    const checkAuthStatus = async () => {
      try {
        await Auth.currentAuthenticatedUser();
        setIsAuthenticated(true); // User is authenticated
      } catch {
        setIsAuthenticated(false); // User is not authenticated
      }
    };
    checkAuthStatus();
  }, []);

  return (
    <Router>
      <Routes>
        <Route
          path="/"
          element={isAuthenticated ? <Navigate to="/movies" /> : <Login />}
        />
        <Route
          path="/movies"
          element={isAuthenticated ? <App selectedGenres={selectedGenres} searchQuery={searchQuery} setSearchQuery={setSearchQuery}/> : <Navigate to="/" />}
        />
        <Route
          path="/movie-genres"
          element={
            isAuthenticated ?
            <SelectGenres
              selectedGenres={selectedGenres}
              setSelectedGenres={setSelectedGenres}
              setSearchQuery={setSearchQuery}
            />
            :
            <Navigate to="/" />
          }
        />
      </Routes>
    </Router>
  );
}

createRoot(document.getElementById("root")).render(
  <StrictMode>
    <Main />
  </StrictMode>
);
