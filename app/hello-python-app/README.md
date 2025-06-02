# Hello Python App

This is a minimal Flask application designed for demonstration and observability purposes in Kubernetes environments.

## Features

- `GET /` — Responds with a **Hello, World!** message and the current UTC time.
- `GET /status` — Provides a **readiness probe** with a JSON payload including:
  - client IP
  - random latency sample
  - visit count
  - UTC timestamp
- `GET /healthz` — Simple **liveness probe** that returns `200 OK`.

## Observability

The app integrates with **Prometheus** via:

- `prometheus_flask_exporter` (automatic `/metrics` endpoint)
- Custom `Counter`: `hello_world_visits_total` (by client IP)
- Custom `Histogram`: `hello_world_latency_seconds` (measures request latency)

These metrics are exposed automatically at `/metrics`.

## Docker

The app is containerized with a lightweight Python 3.11 Slim image:

```
FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 5000

CMD ["python", "app.py"]
```

## Dependencies

Listed in `requirements.txt`:

```
flask==3.1.1
prometheus_client==0.22.0
prometheus_flask_exporter==0.23.0
```

Install them locally with:

```
pip install -r requirements.txt
```
