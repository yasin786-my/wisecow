# Wisecow - DevOps Trainee Assessment

## Problem Statement 1: Containerization and Kubernetes Deployment

### What I built
- Dockerized the Wisecow application using a custom Dockerfile
- Deployed it to a Kubernetes cluster with Deployment and Service manifests
- Added TLS support using cert-manager with a self-signed certificate and NGINX Ingress
- Implemented a full CI/CD pipeline using GitHub Actions

### How to run locally
1. Build the Docker image:
   docker build -t wisecow:v1 .

2. Run the container:
   docker run -p 4499:4499 wisecow:v1

3. Test it:
   curl http://localhost:4499

### Kubernetes deployment
1. Apply the manifests:
   kubectl apply -f k8s/deployment.yaml
   kubectl apply -f k8s/service.yaml

2. Access via port-forward:
   kubectl port-forward service/wisecow-service 8080:4499

3. Test it:
   curl http://localhost:8080

### TLS Setup
- Installed NGINX Ingress Controller
- Installed cert-manager for automatic certificate management
- Created a self-signed ClusterIssuer (appropriate for local/demo clusters
  without a public domain)
- Certificate confirmed issued: kubectl get certificate shows READY: True

### CI/CD Pipeline
The GitHub Actions workflow in .github/workflows/ci-cd.yaml:
- Triggers automatically on every push to main branch
- Job 1 (build-and-push): builds the Docker image and pushes it to
  GitHub Container Registry (ghcr.io)
- Job 2 (deploy): spins up a temporary Kind cluster, applies Kubernetes
  manifests, updates the deployment image, and verifies the pod is running
- Both jobs confirmed passing (green) in the Actions tab

## Problem Statement 2: Automation Scripts

### Script 1: System Health Monitor
Location: scripts/system_health_monitor.sh

Monitors CPU usage, memory usage, disk space, and running process count.
Alerts to console if any metric exceeds predefined thresholds (default: 80%).

Usage:
  sh scripts/system_health_monitor.sh

### Script 2: Application Health Checker
Location: scripts/app_health_checker.sh

Checks whether a web application is up or down based on HTTP status codes.
Reports UP (2xx/3xx) or DOWN (4xx/5xx/no response).

Usage:
  sh scripts/app_health_checker.sh https://example.com

## Repository Structure
wisecow/
├── Dockerfile
├── wisecow.sh
├── k8s/
│   ├── deployment.yaml
│   ├── service.yaml
│   ├── ingress.yaml
│   └── selfsigned-issuer.yaml
├── .github/
│   └── workflows/
│       └── ci-cd.yaml
├── scripts/
│   ├── system_health_monitor.sh
│   └── app_health_checker.sh
└── .gitignore