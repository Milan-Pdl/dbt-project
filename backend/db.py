from pathlib import Path

import asyncpg
import yaml


def load_dbt_profile() -> dict:
    profiles_path = Path(__file__).resolve().parents[1] / "dbtProject" / "profiles.yml"
    profiles = yaml.safe_load(profiles_path.read_text())
    profile_name = next(iter(profiles))
    profile = profiles[profile_name]
    target = profile.get("target")
    output = profile["outputs"][target]
    return {
        "host": output["host"],
        "port": output["port"],
        "user": output["user"],
        "password": output["pass"],
        "database": output["dbname"],
    }


class Database:
    pool: asyncpg.Pool | None = None

    async def connect(self) -> None:
        if self.pool is None:
            cfg = load_dbt_profile()
            self.pool = await asyncpg.create_pool(
                user=cfg["user"],
                password=cfg["password"],
                host=cfg["host"],
                port=cfg["port"],
                database=cfg["database"],
                min_size=1,
                max_size=5,
            )

    async def disconnect(self) -> None:
        if self.pool:
            await self.pool.close()
            self.pool = None

    async def fetch(self, sql: str) -> list[dict]:
        assert self.pool is not None, "Database pool is not initialized"
        async with self.pool.acquire() as connection:
            rows = await connection.fetch(sql)
            return [dict(row) for row in rows]


db = Database()
