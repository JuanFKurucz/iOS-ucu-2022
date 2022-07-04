#! /usr/bin/env bash

# Let the DB start
python /app/app/backend_pre_start.py

# Run migrations
alembic upgrade head
alembic revision --autogenerate -m "update migrations"
alembic upgrade head

# Create initial data in DB
python /app/app/initial_data.py
