
# Helm Chart: hello-python-chart

This Helm chart deploys the **Hello Python App**, a lightweight Flask application with built-in Prometheus metrics, Kubernetes health checks, and optional Ingress support.

---

## Chart Structure

```text
hello-python-chart/
├── Chart.yaml            # Chart metadata
├── values.yaml           # Default configuration values
└── templates/
    ├── deployment.yaml   # App Deployment definition
    ├── service.yaml      # Kubernetes Service definition
    └── ingress.yaml      # Ingress rule (optional)
```

---

## Installation

To install the chart:

```bash
helm install hello-app ./hello-python-chart   --namespace dev   --create-namespace
```

To upgrade the release:

```bash
helm upgrade hello-app ./hello-python-chart   --namespace dev
```

---

## Ingress Configuration

When `ingress.enabled` is set to `true`, the chart will deploy an Ingress resource compatible with your controller (e.g., Traefik).

Ensure that your DNS or `/etc/hosts` routes `hello.local` to the appropriate LoadBalancer IP.

---

## Prometheus Metrics

The application exposes Prometheus-compatible metrics at the `/metrics` endpoint.

This chart adds the necessary annotations to the Deployment for Prometheus to scrape metrics:

- `prometheus.io/scrape: "true"`
- `prometheus.io/port: "{{ .Values.containerPort }}"`
- `prometheus.io/path: "/status"`

---

## Health Probes

Kubernetes probes are configured for basic health checks:

- **Readiness Probe:** checks `GET /status`
- **Liveness Probe:** checks `GET /healthz`

Paths and timings are configurable via `values.yaml`.

---

## ✍️ Author

Maintained by **Braian** – part of the `infra-challenge` stack.
