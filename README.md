# Local DevSecOps Security Pipeline

A small local security automation project that runs secret and vulnerability scans before deploying a containerized application.

The pipeline uses Gitleaks and Trivy to scan the project, generates HTML reports, deploys the target application with Docker, and serves the reports through an Nginx dashboard.

---

## Screenshots

### Security Dashboard
![Security Dashboard](assets/security-dash.png)
*Security reports served through Nginx on port 8000.*

### Security Reports

| Trivy Vulnerability Scan | Gitleaks Secret Scan |
| :---: | :---: |
| ![Trivy HTML Report](assets/trivy-report.png) | ![Gitleaks HTML Report](assets/gitleaks-report.png) |
| *Trivy vulnerability report* | *Gitleaks secret scan report* |

### Deployed Application
![OWASP Juice Shop Application](assets/owasp-juice.png)
*OWASP Juice Shop running on port 3000.*

---

## Workflow

```text
Run Script
    ↓
Gitleaks Secret Scan
    ↓
Trivy Vulnerability Scan
    ↓
Generate Reports
    ↓
Deploy Application
    ↓
Serve Reports with Nginx
```

The workflow is orchestrated by `deploy-and-scan.sh`.

---

## Tech Stack

- Bash
- Docker
- Trivy
- Gitleaks
- Nginx
- OWASP Juice Shop

---

## Repository Structure

```text
.
├── deploy-and-scan.sh
├── .env.example
├── mock-vulnerable-app/
│   ├── Dockerfile
│   └── app.js
└── reports/
```

---

## Running Locally

### Requirements

- Docker
- Git
- Trivy
- Gitleaks

### Setup

```bash
git clone https://github.com/MadManJJ/appsec-scan-dashboard.git
cd appsec-scan-dashboard

cp .env.example .env
chmod +x deploy-and-scan.sh

./deploy-and-scan.sh
```

Open:

- Security dashboard: `http://localhost:8000`
- Target application: `http://localhost:3000`

---

## Homelab Setup

I developed and tested the project on a Fedora machine in my local homelab and accessed it remotely from Windows using SSH port forwarding.

```text
Windows Client
    │
    │ SSH / Local Port Forwarding
    ▼
Fedora Homelab
    ├── Nginx Dashboard :8000
    └── OWASP Juice Shop :3000
```

The homelab setup is not required to run the project; it was simply the environment used during development and testing.

---

## Notes

This project is intended as a small hands-on exercise in combining container security tools with deployment automation.

The Bash workflow can also be adapted into CI systems such as GitHub Actions or GitLab CI.
