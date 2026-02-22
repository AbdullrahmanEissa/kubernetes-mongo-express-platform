# Kubernetes MongoDB & Mongo-Express Platform

A production-style Kubernetes project demonstrating **secure configuration management, service wiring, resource tuning, and ingress-based exposure** using MongoDB and Mongo Express.

This project is designed as an **end-to-end cloud-native system**, not a demo, and follows real-world DevOps and Kubernetes best practices.

---

## 📌 Project Overview

This repository contains a complete Kubernetes setup for:

- MongoDB (stateful backend)
- Mongo Express (web-based database admin UI)
- Secure secrets handling
- Config-driven application wiring
- Internal service communication
- External access via Ingress

The project was **developed and debugged incrementally**, simulating real production scenarios such as crash loops, memory limits, and service dependencies.

---

## 🧱 Architecture

```

Browser
│
▼
Ingress (Host-based routing)
│
▼
Service (ClusterIP)
│
▼
Mongo Express Pod
│
▼
Service (ClusterIP)
│
▼
MongoDB Pod

```

### Key Design Decisions

- **MongoDB is not exposed externally**
- **Mongo Express is exposed via Ingress**
- **Secrets are reused safely**
- **Services use DNS-based discovery**
- **Resource limits are explicitly defined**

---

## 📂 Repository Structure

```

.
├── mongo/
│   ├── mongo-deployment.yml
│   ├── mongo-service.yml
│   └── mongo-secret.yml
│
├── mongo-express/
│   ├── mongo-express-deployment.yml
│   ├── mongo-express-service.yml
│   └── mongo-express-configmap.yml
│
├── ingress/
│   └── express-ingress.yml
│
└── README.md

````

---

## 🔐 Configuration Management

### Secrets (MongoDB & Mongo Express)

Stored in Kubernetes Secrets:
- MongoDB root username
- MongoDB root password
- Mongo Express admin credentials

Secrets are injected using `envFrom`, avoiding plaintext credentials in manifests.

### ConfigMaps (Mongo Express)

Used for non-sensitive configuration:
- MongoDB service hostname
- MongoDB port
- Basic authentication settings

---

## ⚙️ Resource Management

MongoDB includes explicit resource constraints to avoid OOM crashes:

```yaml
resources:
  requests:
    memory: 256Mi
    cpu: 250m
  limits:
    memory: 512Mi
    cpu: 500m
````

This ensures:

* Predictable scheduling
* Stable runtime behavior
* Controlled memory usage

---

## 🌐 Networking & Access

* All internal communication uses **ClusterIP Services**
* External access is handled exclusively via **Ingress**
* Host-based routing is used (`express.local`)
* No direct NodePort exposure

---

## 🚀 How to Run (Minikube)

### 1️⃣ Start Minikube

```bash
minikube start
minikube addons enable ingress
```

### 2️⃣ Apply Resources

```bash
kubectl apply -f mongo/
kubectl apply -f mongo-express/
kubectl apply -f ingress/
```

### 3️⃣ Add Host Mapping

```bash
echo "$(minikube ip) express.local" | sudo tee -a /etc/hosts
```

### 4️⃣ Access UI

```
http://express.local
```

---

## 🧪 Debugging Scenarios Covered

This project intentionally encountered and resolved:

* `CrashLoopBackOff` due to memory limits
* MongoDB OOM kills
* Incorrect secret wiring
* Image-specific environment variable mismatches
* Ingress DNS resolution issues

All issues were diagnosed using:

* `kubectl logs`
* `kubectl describe`
* Resource tuning

---

## 🧠 Why This Project Matters

This repository demonstrates:

* Kubernetes **wiring knowledge**, not YAML memorization
* Real-world **failure analysis and recovery**
* Clean separation of concerns
* Production-aware resource management
* Cloud-native architecture principles

This is the same workflow used in real DevOps and Platform Engineering roles.

---

## 🔮 Future Improvements

* PersistentVolume & PVC for MongoDB
* Readiness & Liveness probes
* TLS via cert-manager
* CI/CD pipeline (Jenkins / GitHub Actions)
* Deployment to k3s on AWS EC2

---

## 👤 Author

Built by a Linux & DevOps engineer with a focus on **practical Kubernetes systems** and production-grade infrastructure design.
قولّي 👊
```
