import React, { useState } from "react";
import { StrictMode } from "react";
import { createRoot } from "react-dom/client";
import { BrowserRouter as Router, Routes, Route } from "react-router-dom";
import "./index.css";
import App from "./components/App.jsx";
import { SelectGenres } from "./components/select-genres/SelectGenres.jsx";
import { Login } from "./components/login/login.jsx";
import { Amplify } from "aws-amplify";
import awsConfig from "./amplifyConfig";

Amplify.configure(awsConfig);

function Main() {
  const [selectedGenres, setSelectedGenres] = useState([]);
  const [searchQuery, setSearchQuery] = useState("");

  return (
    <Router>
      <Routes>
        <Route path="/" element={<Login />} />
        <Route path="/movies" element={<App selectedGenres={selectedGenres} 
                                      searchQuery={searchQuery}
                                      setSearchQuery={setSearchQuery}/>} />
        <Route
          path="/movie-genres"
          element={
            <SelectGenres
              selectedGenres={selectedGenres}
              setSelectedGenres={setSelectedGenres}
              setSearchQuery={setSearchQuery}
            />
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
