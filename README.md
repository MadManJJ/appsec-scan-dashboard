# Automated CI/CD Security Pipeline

A local, reproducible DevSecOps pipeline demonstrating **Shift-Left Security** principles. This project automates static code scanning, secret detection, container vulnerability checks, and security report aggregation before application deployment.

---

## System Screenshots

### Security Dashboard
![Security Dashboard](assets/security-dash.png)
*Unified Nginx Security Dashboard (Port 8000)*

### Security Reports
| Trivy Vulnerability Scan | Gitleaks Secret Scan |
| :---: | :---: |
| ![Trivy HTML Report](assets/trivy-report.png) | ![Gitleaks HTML Report](assets/gitleaks-report.png) |
| *Trivy CVE Analysis Report* | *Gitleaks Detected Secrets Report* |

### Deployed Application
![OWASP Juice Shop Application](assets/owasp-juice.png)
*Deployed Vulnerable Application (OWASP Juice Shop - Port 3000)*

---

## Pipeline Architecture & Workflow

```text
┌─────────────────┐    ┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│ Developer Commit│───>│ Gitleaks Scan   │───>│ Trivy Image Scan │───>│ Deployment &    │
│ / Execution     │    │ (Secret Check)  │    │ (CVE Check)      │    │ Nginx Dashboard │
└─────────────────┘    └─────────────────┘    └──────────────────┘    └─────────────────┘
```

1. **Secret Detection (Gitleaks):** Scans the codebase for hardcoded secrets, API keys, and sensitive credentials.
2. **Container Security (Trivy):** Analyzes target container images and local Dockerfiles for known CVEs (High/Critical) and formats results into clean HTML reports using custom templates.
3. **Automated Deployment:** Spins up the application container environment via Docker upon successful scan execution.
4. **Report Hosting:** Mounts generated security artifacts directly to a dedicated Nginx container serving a centralized web dashboard.

---

## Tech Stack

* **Security Tools:** Trivy, Gitleaks
* **Containerization & Web Hosting:** Docker, Nginx
* **Automation & Scripting:** Bash Shell Scripting, Git Hooks (`.pre-commit-config.yaml`)
* **Target Environment:** Node.js / OWASP Juice Shop

---

## Repository Structure

```text
.
├── deploy-and-scan.sh       # Main CI/CD pipeline orchestration script
├── .pre-commit-config.yaml  # Git hook blueprint for automation
├── .env.example             # Template for environment configuration
├── mock-vulnerable-app/     # Sample local application for vulnerability testing
│   ├── Dockerfile
│   └── app.js
└── reports/                 # Auto-generated security report artifacts (git-ignored)
```

---

## Getting Started

### Prerequisites
* Docker & Docker Engine
* Git
* Trivy & Gitleaks installed locally

### Installation & Execution

1. **Clone the repository:**
   ```bash
   git clone [https://github.com/MadManJJ/appsec-scan-dashboard.git](https://github.com/MadManJJ/appsec-scan-dashboard.git)
   cd devsecops-pipeline
   ```

2. **Configure environment:**
   ```bash
   cp .env.example .env
   ```

3. **Execute the pipeline:**
   ```bash
   chmod +x deploy-and-scan.sh
   ./deploy-and-scan.sh
   ```

4. **Access Dashboard & App:**
   * **Security Dashboard:** `http://localhost:8000`
   * **Target Application:** `http://localhost:3000`

---

## 📌 Homelab Architecture Note

> **Note:** This pipeline was developed and validated inside a local Fedora homelab environment. Cross-device access during development was routed via SSH Local Port Forwarding (`-L 3000:localhost:3000 -L 8000:localhost:8000`). While executed locally, the shell orchestration logic and hook structures are cloud-agnostic and directly portable to GitHub Actions or GitLab CI runners.
