#!/bin/bash
# =============================================================================
# EC2 Instance Setup Script
# Run this script ONCE on a fresh Amazon Linux EC2 instance
# Usage: chmod +x scripts/ec2-setup.sh && ./scripts/ec2-setup.sh
# =============================================================================

set -e

echo "=============================================="
echo " DevOps Honors Project - EC2 Setup Script"
echo "=============================================="

# -- 1. Update System ----------------------------------------------------------
echo "[1/5] Updating system packages..."
sudo yum update -y

# -- 2. Install Java 17 --------------------------------------------------------
echo "[2/5] Installing Java 17..."
sudo yum install -y java-17-amazon-corretto

echo "Java version installed:"
java -version

# -- 3. Create Application Directory ------------------------------------------
echo "[3/5] Creating application directory..."
mkdir -p /home/ec2-user/app
chmod 755 /home/ec2-user/app

# -- 4. Install Tools ----------------------------------------------------------
echo "[4/5] Installing required tools..."
sudo yum install -y lsof curl wget

# -- 5. Security Group Reminder ------------------------------------------------
echo "[5/5] Setup complete!"
echo ""
echo "=============================================="
echo " IMPORTANT: EC2 Security Group Rules Needed"
echo "=============================================="
echo " Add these INBOUND rules in AWS Console:"
echo "   - Port 8080 (TCP) -> 0.0.0.0/0  [Application Port]"
echo "   - Port 22   (TCP) -> Your IP    [SSH Access]"
echo "=============================================="
echo ""
echo " EC2 Setup Complete! You can now deploy via Jenkins."
echo " App will run at: http://$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4):8080"
