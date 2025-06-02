from flask import Flask, request, jsonify
from datetime import datetime
from prometheus_flask_exporter import PrometheusMetrics
from prometheus_client import Counter, Histogram
import time

app = Flask(__name__)
metrics = PrometheusMetrics(app)

# Global visit counter
visit_count = 0

# Counter by client IP
visit_counter = Counter(
    'hello_world_visits_total',
    'Total visits to the hello world endpoint',
    ['client_ip']
)

# Histogram to measure latency
latency_histogram = Histogram(
    'hello_world_latency_seconds',
    'Latency for the hello world endpoint in seconds'
)

@app.route("/")
@latency_histogram.time()
def hello():
    global visit_count
    visit_count += 1
    client_ip = request.remote_addr
    visit_counter.labels(client_ip=client_ip).inc()

    now = datetime.utcnow().strftime("%Y-%m-%d %H:%M:%S UTC")
    return f"Hello, World! Current UTC time is {now}. Created by Braian"

@app.route("/status")
def status():
    # Readiness check: responds if the service is ready
    return jsonify({
        "status": "ready",
        "ip": request.remote_addr,
        "latency": f"{round(time.perf_counter() * 1000) % 100}ms",
        "visits": visit_count,
        "timestamp": datetime.utcnow().isoformat() + "Z"
    })

@app.route("/healthz")
def healthz():
    # Liveness check: simply verifies the app is up
    return "OK", 200

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
