import React, { useState } from "react";
import { StrictMode } from "react";
import { createRoot } from "react-dom/client";
import { BrowserRouter as Router, Routes, Route } from "react-router-dom";
import "./index.css";
import App from "./components/App.jsx";
import { SelectGenres } from "./components/select-genres/SelectGenres.jsx";

function Main() {
  const [selectedGenres, setSelectedGenres] = useState([]);

  return (
    <Router>
      <Routes>
        <Route path="/" element={<App selectedGenres={selectedGenres} />} />
        <Route
          path="/genres"
          element={
            <SelectGenres
              selectedGenres={selectedGenres}
              setSelectedGenres={setSelectedGenres}
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
