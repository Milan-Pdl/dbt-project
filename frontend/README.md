# DBT Mart Visualizer Frontend

This frontend is a small React + Vite app that consumes the FastAPI backend endpoints.

## Install

If you have Node.js installed:

```powershell
cd frontend
npm install
```

## Run

```powershell
cd frontend
npm run dev
```

Then open `http://localhost:5173`.

## Notes

- The app expects the backend to run at `http://localhost:8000`.
- If the API is hosted elsewhere, update `API_BASE` in `src/App.jsx`.
