# DBT Dev Project

A complete example of a local analytics pipeline with:

- `dbtProject/`: a dbt repository that builds staging, intermediate, and mart models.
- `backend/`: a FastAPI service that reads dbt-generated mart tables and exposes JSON endpoints.
- `frontend/`: a React + Vite dashboard that visualizes mart data with charts.

This README explains the full architecture, how the pieces connect, how to run the project, and how to customize it.

---

## 🔍 Project Overview

This project is designed to show an end-to-end dbt workflow for analytics, paired with a backend and frontend visualization layer.

1. `dbtProject/` transforms raw source data into cleaned staging tables, intermediate tables, and final mart tables.
2. `backend/` connects to Postgres using dbt profile settings, reads the `gold` schema tables, and exposes simple REST APIs.
3. `frontend/` fetches API data and renders charts for daily transactions, branch performance, and top customers.

---

## 📁 Folder Structure

- `dbtProject/`
  - `models/staging/`: staging SQL models and schema tests for raw source tables.
  - `models/intermediate/`: transformed intermediate tables used before mart aggregation.
  - `models/marts/`: final mart tables in the `gold` schema consumed by the dashboard.
  - `dbt_project.yml`: dbt project configuration, materialization rules, and schemas.
  - `profiles.yml`: connection configuration for Postgres and dbt target settings.
- `backend/`
  - `app.py`: FastAPI app, CORS middleware, endpoints, and query helper.
  - `db.py`: asynchronous Postgres connection pool that loads credentials from `dbtProject/profiles.yml`.
  - `requirements.txt`: Python packages required by the backend.
- `frontend/`
  - `src/App.jsx`: React dashboard, API fetch logic, and Recharts visualization.
  - `src/main.jsx`: app entry point.
  - `styles.css`: layout and styling for the dashboard.
  - `package.json`: frontend dependencies and development scripts.

---

## 🧠 How the Data Flows

1. dbt builds models into Postgres:
   - Staging models in `staging` schema
   - Intermediate tables in `intermediate` schema
   - Mart tables in `gold` schema
2. The backend reads from `gold.*` tables and returns JSON data.
3. The frontend calls those endpoints and displays charts.

This separation keeps data transformation in dbt, API logic in FastAPI, and UI rendering in React.

---

## ⚙️ Prerequisites

- Python 3.12 or newer
- Node.js 18+ and npm
- PostgreSQL running locally
- dbt installed for building models (optional but recommended)

---

## 🚀 Local Setup

### 1. Create a Python virtual environment

From the repo root:

```powershell
python -m venv .venv
.\.venv\Scripts\Activate.ps1
```

### 2. Install backend dependencies

```powershell
cd backend
pip install -r requirements.txt
```

### 3. Install frontend dependencies

```powershell
cd ..\frontend
npm install
```

### 4. Verify dbt and Postgres configuration

Open `dbtProject/profiles.yml` and update the connection settings if needed:

- `dbname`
- `host`
- `port`
- `user`
- `pass`
- `schema`

The current config connects to a Postgres database named `dummybank` on `localhost:5432` with user `postgres`.

---

## 🧩 dbt Project Details

The dbt project uses these layers:

- **Staging**: raw data is cleaned and standardized.
- **Intermediate**: transformations and joins are performed.
- **Marts**: final reporting tables exposed to the dashboard.

The `dbt_project.yml` file defines the default materialization and schema conventions:

- `staging` models become views under a staging schema
- `intermediate` models become tables under an intermediate schema
- `marts` models become tables under the `gold` schema

### Run dbt models

From the repo root:

```powershell
cd dbtProject
dbt run
```

### Run dbt tests

```powershell
dbt test
```

---

## 🧪 Backend Details

The backend loads Postgres credentials from `dbtProject/profiles.yml` and connects using `asyncpg`.

It provides these API endpoints:

- `GET /api/daily_transaction_summary`
- `GET /api/customer_360`
- `GET /api/branch_performance_summary`

Each endpoint returns rows from the corresponding table in the `gold` schema.

### Start the backend

From the repo root:

```powershell
cd backend
..\.venv\Scripts\python.exe -m uvicorn app:app --reload --host 0.0.0.0 --port 8000
```

The backend also includes CORS support for `http://localhost:5173`, which is where the frontend runs.

---

## 🌐 Frontend Details

The frontend is a small React app built with Vite.
It loads data from the backend and renders three visualizations:

- Daily transaction volume line chart
- Branch performance bar chart
- Top customers by transaction amount bar chart

### Start the frontend

From the repo root:

```powershell
cd frontend
npm run dev
```

Open the app in the browser at:

```text
http://localhost:5173
```

### Frontend API base URL

The frontend uses `http://localhost:8000/api` as the API base URL inside `frontend/src/App.jsx`.
If you move the backend, update this value.

---

## 🧭 Useful Commands

```powershell
# Run dbt models
cd dbtProject
dbt run

dbt test

# Start backend
cd backend
..\.venv\Scripts\python.exe -m uvicorn app:app --reload --host 0.0.0.0 --port 8000

# Start frontend
cd frontend
npm run dev
```

---

## 📌 Notes

- The backend and frontend are intentionally separated so that the dbt transformation layer stays independent from the visualization layer.
- The backend reads the dbt profile directly, so this repo does not need a separate `.env` file for database credentials.
- If your data model changes in dbt, rerun `dbt run` before refreshing the frontend.

---

## 📚 Additional README Files

- `backend/README.md`: backend-specific setup notes.
- `frontend/README.md`: frontend-specific setup notes.
- `dbtProject/README.md`: dbt starter project information.

---

## 💡 Recommended Workflow

1. Configure Postgres in `dbtProject/profiles.yml`.
2. Run `dbt run` to build the models.
3. Start the backend.
4. Start the frontend.
5. Open the app and verify charts render.
