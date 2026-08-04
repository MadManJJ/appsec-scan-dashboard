#!/bin/bash
echo "=========================================="
echo " [CI/CD] "
echo "=========================================="

TARGET_DIR="$HOME/dev/juice-shop"

REPORTS_DIR="./reports"
mkdir -p $REPORTS_DIR

if [ ! -f "html.tpl" ]; then
    echo "[+] Downloading Trivy HTML template..."
    curl -sLO https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/html.tpl
fi

# Secret Scanning
echo "[+] Stage 1: Running Gitleaks..."
gitleaks detect --source "$TARGET_DIR" -v --report-path $REPORTS_DIR/gitleaks-report.json

# Filesystem Scan
echo "[+] Stage 2: Running Trivy Filesystem Scan..."
trivy fs "$TARGET_DIR" --severity HIGH,CRITICAL --format json --output $REPORTS_DIR/trivy-fs.json
trivy fs "$TARGET_DIR" --severity HIGH,CRITICAL --format template --template "@html.tpl" --output $REPORTS_DIR/trivy-fs.html

# Pull & Scan Container Image
echo "[+] Stage 3: Pulling official Juice Shop image..."
IMAGE_NAME="bkimminich/juice-shop"
docker pull $IMAGE_NAME

# Container Scan
echo "[+] Stage 4: Running Trivy Container Image Scan..."
trivy image $IMAGE_NAME --severity CRITICAL --format json --output $REPORTS_DIR/trivy-image.json
trivy image $IMAGE_NAME --severity CRITICAL --format template --template "@html.tpl" --output $REPORTS_DIR/trivy-image.html

# Deploy Application Container
echo "[+] Stage 5: Deploying Juice Shop on Port 3000..."
docker stop juice-shop 2>/dev/null || true
docker rm juice-shop 2>/dev/null || true
docker run -d --name juice-shop -p 3000:3000 $IMAGE_NAME

# Build Central Security Dashboard Index
echo "[+] Stage 6: Building Dashboard Portal..."
cat <<EOF > $REPORTS_DIR/index.html
<!DOCTYPE html>
<html>
<head>
    <title>Lab Dashboard</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; background-color: #f4f6f9; }
        h1 { color: #2c3e50; }
        .card { background: white; padding: 20px; border-radius: 8px; margin-bottom: 20px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
        a { text-decoration: none; color: #3498db; font-weight: bold; }
        .status-success { color: green; font-weight: bold; }
        .status-alert { color: red; font-weight: bold; }
    </style>
</head>
<body>
    <h1>Dashboard</h1>
    
    <div class="card">
        <h2>1. Target Application</h2>
        <p>Live Juice Shop App: <a href="http://localhost:3000" target="_blank">http://localhost:3000</a></p>
    </div>

    <div class="card">
        <h2>2. Automated Security Reports (Fedora)</h2>
        <ul>
            <li><a href="trivy-fs.html">Trivy Filesystem Vulnerabilities (HTML)</a></li>
            <li><a href="trivy-image.html">Trivy Container Image Vulnerabilities (HTML)</a></li>
            <li><a href="gitleaks-report.json">Gitleaks Raw JSON Findings</a></li>
        </ul>
    </div>
</body>
</html>
EOF

# Launch Security Dashboard via Nginx Container on Port 8000
echo "[+] Stage 7: Hosting Security Dashboard via Nginx on Port 8000..."

# Stop and remove any previous instance of the dashboard container
docker stop security-dashboard 2>/dev/null || true
docker rm security-dashboard 2>/dev/null || true

# Run Nginx with reports directory mounted as read-only (:ro)
docker run -d \
  --name security-dashboard \
  -p 8000:80 \
  -v "$(pwd)/$REPORTS_DIR:/usr/share/nginx/html:ro" \
  nginx:alpine

echo "=========================================="
echo " [CI/CD] Pipeline Finished!"
echo " Target App: http://fedora-ip:3000"
echo " Dashboard:  http://fedora-ip:8000"
echo "=========================================="

