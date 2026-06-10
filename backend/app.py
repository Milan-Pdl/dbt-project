from contextlib import asynccontextmanager

from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware

from db import db


@asynccontextmanager
async def lifespan(app: FastAPI):
    await db.connect()
    try:
        yield
    finally:
        await db.disconnect()


app = FastAPI(title="DBT Mart Visualizer API", lifespan=lifespan)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:5173"],
    allow_credentials=True,
    allow_methods=["GET", "OPTIONS"],
    allow_headers=["*"]
)


async def fetch_table(table_name: str) -> list[dict]:
    sql = f"SELECT * FROM gold.{table_name} ORDER BY 1 DESC LIMIT 500"
    try:
        return await db.fetch(sql)
    except Exception as exc:
        raise HTTPException(status_code=500, detail=str(exc)) from exc

@app.get("/")
async def hello():
    return  {"welome to the hood"}

@app.get("/api/daily_transaction_summary")
async def daily_transaction_summary():
    return await fetch_table("daily_transaction_summary")


@app.get("/api/customer_360")
async def customer_360():
    return await fetch_table("customer_360")


@app.get("/api/branch_performance_summary")
async def branch_performance_summary():
    return await fetch_table("branch_performance_summary")
