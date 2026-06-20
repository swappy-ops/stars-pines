"""Stars & Pines V2 — FastAPI application entry point."""

from contextlib import asynccontextmanager
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles

from api.db import init_db
from api.routes import router


@asynccontextmanager
async def lifespan(app: FastAPI):
    """Initialize database on startup."""
    init_db()
    print("Stars & Pines V2 — Database initialized")
    yield
    print("Stars & Pines V2 — Shutting down")


app = FastAPI(
    title="Stars & Pines V2",
    description="Local-first hospitality operations system",
    version="2.0.0",
    lifespan=lifespan,
)

# CORS — allow all three frontend apps to call the API
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Mount static files for the three frontend apps
app.mount("/guest-entry", StaticFiles(directory="guest-entry", html=True), name="guest-entry")
app.mount("/guest-portal", StaticFiles(directory="guest-portal", html=True), name="guest-portal")
app.mount("/family-app", StaticFiles(directory="family-app", html=True), name="family-app")

# Include API routes
app.include_router(router)


@app.get("/health")
def health_check():
    """Health check — confirms API and database are running."""
    from api.db import get_db
    with get_db() as conn:
        tables = conn.execute(
            "SELECT name FROM sqlite_master WHERE type='table' ORDER BY name"
        ).fetchall()
    return {
        "status": "ok",
        "database": "connected",
        "tables": [row["name"] for row in tables],
    }
