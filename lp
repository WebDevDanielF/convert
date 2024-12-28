// pages/index.js
import React, { useState } from 'react';

const Home = () => {
  const [url, setUrl] = useState('');

  const handleSubmit = (e) => {
    e.preventDefault();
    console.log(`Analyzing URL: ${url}`);
    // Add API call logic here
  };

  return (
    <div className="container">
      <header>
        <h1>Analyze Your Landing Page</h1>
      </header>
      <main>
        <form onSubmit={handleSubmit} className="form">
          <label htmlFor="url">Enter URL:</label>
          <input
            type="text"
            id="url"
            name="url"
            placeholder="https://example.com"
            value={url}
            onChange={(e) => setUrl(e.target.value)}
            required
          />
          <button type="submit">Analyze</button>
        </form>
      </main>
      <footer>
        <p>&copy; 2024 Landing Page Analyzer</p>
      </footer>

      <style jsx>{`
        body {
          font-family: 'Arial', sans-serif;
          background-color: #f9f9f9;
          margin: 0;
          padding: 0;
          color: #333;
        }

        .container {
          max-width: 800px;
          margin: 0 auto;
          padding: 20px;
          background-color: #fff;
          border-radius: 8px;
          box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

        header {
          text-align: center;
          margin-bottom: 20px;
        }

        header h1 {
          color: #4CAF50;
          font-size: 24px;
        }

        .form {
          display: flex;
          flex-direction: column;
          gap: 15px;
        }

        label {
          font-weight: bold;
        }

        input[type="text"] {
          padding: 10px;
          font-size: 16px;
          border: 1px solid #ddd;
          border-radius: 4px;
        }

        button {
          padding: 10px 15px;
          font-size: 16px;
          background-color: #4CAF50;
          color: white;
          border: none;
          border-radius: 4px;
          cursor: pointer;
        }

        button:hover {
          background-color: #45a049;
        }

        footer {
          text-align: center;
          margin-top: 20px;
          font-size: 14px;
          color: #777;
        }
      `}</style>
    </div>
  );
};

export default Home;

