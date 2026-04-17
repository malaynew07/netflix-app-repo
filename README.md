# End-to-End Netflix Clone: GitOps CI/CD Pipeline on Kubernetes

![Architecture](https://img.shields.io/badge/Architecture-GitOps-blue)
![Kubernetes](https://img.shields.io/badge/Kubernetes-KinD-blue)
![CI/CD](https://img.shields.io/badge/CI%2FCD-Jenkins%20%26%20ArgoCD-green)

This project demonstrates a production-grade DevOps workflow for deploying a Netflix Clone. It leverages **GitOps** principles to ensure that the cluster state always matches the configuration stored in Git.

## 🚀 Project Overview
The goal of this project was to automate the entire lifecycle of a web application—from code commit to a monitored, live deployment on a Kubernetes cluster.

### 🏗️ Tech Stack
- **Application:** HTML/CSS/JS (Netflix UI Clone)
- **Containerization:** Docker & Docker Hub
- **CI Tool:** Jenkins (Declarative Pipeline)
- **CD Tool:** ArgoCD (GitOps Pattern)
- **Orchestration:** Kubernetes (using KinD - Kubernetes in Docker)
- **Observability:** Prometheus & Grafana

## 🎡 The Workflow
1. **Developer Pushes Code:** A change is pushed to the `netflix-app-repo`.
2. **CI Pipeline (Jenkins):** - Builds a new Docker image with a unique build tag.
    - Pushes the image to **Docker Hub**.
    - Clones the **Manifest Repo** and updates the `deployment.yaml` with the new image tag.
3. **CD Pipeline (ArgoCD):** - Detects the "Configuration Drift" in the Manifest Repo.
    - Automatically syncs the cluster to match the new manifest state.
4. **Monitoring:** - **Prometheus** scrapes metrics from the `netflix-clone` namespace.
    - **Grafana** visualizes CPU, RAM, and Network usage.

## 📁 Repository Structure
- **[netflix-app-repo]**: Contains source code, `Dockerfile`, and `Jenkinsfile`.
- **[netflix-gitops-manifests]**: Contains Kubernetes YAML files (Deployment, Service, ServiceMonitor).

## 🛠️ Setup & Installation
1. **Cluster Setup:**
   ```bash
   kind create cluster --name netflix-lab
   kubectl create namespace netflix-clone

2. ArgoCD Installation:
   kubectl create namespace argocd
   kubectl apply -n argocd -f [https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml](https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml)

3. Monitoring Stack:
   helm install kind-prometheus prometheus-community/kube-prometheus-stack -n monitoring --create-namespace

📊 Observability
   To view the metrics, port-forward the Grafana service:
   kubectl port-forward svc/kind-prometheus-grafana 3000:80 -n monitoring

   Access dashboards at http://localhost:3000 to monitor pod performance in real-time.

💡 Key Learnings:
    1. Implementing Resource Isolation using Kubernetes Namespaces.

    2. Understanding the GitOps Handshake between Jenkins and ArgoCD.

    3. Preventing Configuration Drift via automated reconciliation.
    
    4. Setting up ServiceMonitors for Prometheus Operator.
