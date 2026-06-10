# DBT Mart Visualizer Backend

This backend exposes mart data from the `gold` schema using FastAPI.

## Install

```powershell
cd backend
uv add -r requirements.txt
```

If you prefer pip:

```powershell
cd backend
E:\MIlan_Stuffs\project\dbt_dev\.venv\Scripts\python.exe -m pip install -r requirements.txt
```

## Run

```powershell
cd backend
E:\MIlan_Stuffs\project\dbt_dev\.venv\Scripts\python.exe -m uvicorn app:app --reload --host 0.0.0.0 --port 8000
```
