#!/bin/bash
# =============================================================================
# Jenkins Installation Script (for Ubuntu/Debian Jenkins Server)
# Run this on your Jenkins server machine (NOT EC2 deployment target)
# =============================================================================

set -e

echo "=============================================="
echo " Jenkins Server Setup Script"
echo "=============================================="

# -- Install Java --------------------------------------------------------------
echo "[1/4] Installing Java 17..."
sudo apt-get update -y
sudo apt-get install -y openjdk-17-jdk

# -- Install Jenkins -----------------------------------------------------------
echo "[2/4] Installing Jenkins..."
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | \
    sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null

echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
    https://pkg.jenkins.io/debian-stable binary/ | \
    sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

sudo apt-get update -y
sudo apt-get install -y jenkins

# -- Install Maven -------------------------------------------------------------
echo "[3/4] Installing Maven..."
sudo apt-get install -y maven

# -- Start Jenkins -------------------------------------------------------------
echo "[4/4] Starting Jenkins service..."
sudo systemctl enable jenkins
sudo systemctl start jenkins

echo ""
echo "=============================================="
echo " Jenkins Installation Complete!"
echo "=============================================="
echo ""
echo " Jenkins is running at: http://localhost:8080"
echo ""
echo " Initial Admin Password:"
sudo cat /var/lib/jenkins/secrets/initialAdminPassword

echo ""
echo " Required Jenkins Plugins to install:"
echo "   1. Git Plugin"
echo "   2. GitHub Plugin"
echo "   3. GitHub Integration Plugin"
echo "   4. Maven Integration Plugin"
echo "   5. SSH Agent Plugin"
echo "   6. Pipeline Plugin"
echo "   7. Credentials Binding Plugin"
echo "   8. Blue Ocean (optional, better UI)"
echo "=============================================="
