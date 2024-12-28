import React, { useState } from "react";
import Head from "next/head";
import { useRouter } from "next/router";

const HomePage = () => {
  const [urls, setUrls] = useState([""]);
  const router = useRouter();

  const handleInputChange = (index, value) => {
    const updatedUrls = [...urls];
    updatedUrls[index] = value;
    setUrls(updatedUrls);
  };

  const addNewUrl = () => {
    setUrls([...urls, ""]);
  };

  const analyzeUrls = async () => {
    router.push({
      pathname: "/dashboard",
      query: { urls: JSON.stringify(urls) },
    });
  };

  return (
    <div className="container">
      <Head>
        <title>Landing Page Analysis</title>
        <meta name="description" content="Analyze your landing pages efficiently." />
      </Head>
      <h1>Landing Page Analysis</h1>
      <div>
        {urls.map((url, index) => (
          <input
            key={index}
            type="text"
            value={url}
            onChange={(e) => handleInputChange(index, e.target.value)}
            placeholder="Enter a URL"
          />
        ))}
      </div>
      <button onClick={addNewUrl}>Add More URLs</button>
      <button onClick={analyzeUrls}>Analyze</button>

      <style jsx>{`
        .container {
          max-width: 800px;
          margin: 0 auto;
          padding: 20px;
          text-align: center;
        }

        input {
          width: 100%;
          margin: 10px 0;
          padding: 10px;
          font-size: 16px;
        }

        button {
          margin: 5px;
          padding: 10px 20px;
          font-size: 16px;
          cursor: pointer;
        }

        h1 {
          font-size: 2rem;
        }
      `}</style>
    </div>
  );
};

export default HomePage;

// Dashboard Component
const DashboardPage = ({ urls }) => {
  const [analysisData, setAnalysisData] = useState([]);

  useEffect(() => {
    const fetchAnalysisData = async () => {
      const results = await Promise.all(
        urls.map(async (url) => {
          const res = await fetch(`/api/analyze?url=${encodeURIComponent(url)}`);
          return res.json();
        })
      );
      setAnalysisData(results);
    };

    fetchAnalysisData();
  }, [urls]);

  return (
    <div className="container">
      <h1>Dashboard</h1>
      <table>
        <thead>
          <tr>
            <th>URL</th>
            <th>Performance Score</th>
            <th>Status</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          {analysisData.map((data, index) => (
            <tr key={index}>
              <td>{data.url}</td>
              <td>{data.performanceScore}</td>
              <td>{data.status}</td>
              <td>
                <button onClick={() => viewReport(data)}>View Report</button>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
      <style jsx>{`
        .container {
          max-width: 800px;
          margin: 0 auto;
          padding: 20px;
        }

        table {
          width: 100%;
          border-collapse: collapse;
        }

        th, td {
          border: 1px solid #ccc;
          padding: 10px;
          text-align: center;
        }

        h1 {
          font-size: 2rem;
        }

        button {
          padding: 10px;
          font-size: 16px;
          cursor: pointer;
        }
      `}</style>
    </div>
  );
};

export default DashboardPage;

// API Route for Analysis
import lighthouse from "lighthouse";
import chromeLauncher from "chrome-launcher";

export default async (req, res) => {
  const { url } = req.query;

  if (!url) {
    res.status(400).json({ error: "URL is required" });
    return;
  }

  const chrome = await chromeLauncher.launch({ chromeFlags: ["--headless"] });
  const options = { output: "json", onlyCategories: ["performance"], port: chrome.port };
  const runnerResult = await lighthouse(url, options);

  const performanceScore = runnerResult.lhr.categories.performance.score * 100;

  await chrome.kill();

  res.status(200).json({
    url,
    performanceScore,
    status: "completed",
  });
};
