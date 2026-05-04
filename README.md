# DevOps Honors Project - Jenkins CI/CD for Spring Boot

This repository contains a simple Spring Boot application and a Jenkins pipeline that builds, tests, archives, and deploys the app to an AWS EC2 instance using SSH + PEM authentication. It is intended as a clean, beginner-friendly CI/CD example for an honors submission.

Repository: https://github.com/mansiii77/devops-honors-project

## Tech Stack
- Java 17 + Spring Boot
- Maven
- Jenkins (CI/CD)
- GitHub (SCM + Webhooks)
- AWS EC2 (Amazon Linux)
- SSH + PEM key authentication

## CI/CD Flow (High Level)
1. Push code to GitHub.
2. GitHub webhook triggers Jenkins.
3. Jenkins checks out the repo.
4. Maven builds and tests the app.
5. Jenkins archives the JAR artifact.
6. Jenkins uploads the JAR to EC2 via SSH.
7. Jenkins restarts the systemd service on EC2.

## Project Structure
```
.
├── .github/workflows/maven-ci.yml
├── Dockerfile
├── Jenkinsfile
├── README.md
├── pom.xml
├── scripts/
│   ├── devops-honors.service
│   ├── ec2-setup.sh
│   └── jenkins-setup.sh
└── src/
    ├── main/
    │   ├── java/com/mansiii77/devopshonors/
    │   │   ├── DevopsHonorsApplication.java
    │   │   └── controller/
    │   │       ├── HealthController.java
    │   │       └── HelloController.java
    │   └── resources/application.properties
    └── test/java/com/mansiii77/devopshonors/DevopsHonorsApplicationTests.java
```

## Local Run (Quick Test)
```bash
mvn clean package
java -jar target/devops-honors-project.jar
```
Open:
- http://localhost:8080/
- http://localhost:8080/api/health

## Jenkins Setup (Ubuntu/Debian)
Run the script on your Jenkins server:
```bash
chmod +x scripts/jenkins-setup.sh
./scripts/jenkins-setup.sh
```
If you use a different OS, install Java 17, Maven 3.x, and Jenkins using your OS packages.

### Required Jenkins Plugins
- Git Plugin
- GitHub Plugin
- GitHub Integration Plugin
- Maven Integration Plugin
- SSH Agent Plugin
- Pipeline Plugin
- Credentials Binding Plugin
- Blue Ocean (optional)

### Jenkins Global Tools
- Configure Java 17 (or use system Java)
- Configure Maven 3.x (or use system Maven)

### Jenkins Credentials (Required)
Create these credentials in Jenkins:
1. **SSH key**
   - Type: SSH Username with private key
   - ID: `ec2-ssh-key`
   - Username: `ec2-user`
   - Private key: contents of your EC2 PEM key
2. **EC2 host**
   - Type: Secret text
   - ID: `ec2-host`
   - Secret: your EC2 public IP or DNS

### Jenkins Pipeline Job
- Create a **Pipeline** or **Multibranch Pipeline** job.
- Repository URL: `https://github.com/mansiii77/devops-honors-project`
- Jenkinsfile path: `Jenkinsfile`

## GitHub Webhook Setup
1. Go to **GitHub Repo > Settings > Webhooks**.
2. Click **Add webhook**.
3. Payload URL: `http://<JENKINS_PUBLIC_IP>:8080/github-webhook/`
4. Content type: `application/json`
5. Events: **Just the push event** (or include PR events if needed).
6. Save, then test by pushing a commit.

## EC2 Setup (Amazon Linux)
1. Launch an Amazon Linux EC2 instance.
2. Open inbound ports in the Security Group:
   - **22** (SSH) from your IP
   - **8080** (App) from 0.0.0.0/0
3. SSH into EC2:
```bash
chmod 400 devops-honors.pem
ssh -i "devops-honors.pem" ec2-user@<EC2-PUBLIC-IP>
```
4. Run the setup script once:
```bash
chmod +x scripts/ec2-setup.sh
./scripts/ec2-setup.sh
```

## SSH Configuration (PEM Permissions)
```bash
chmod 400 devops-honors.pem
ssh -i "devops-honors.pem" ec2-user@<EC2-PUBLIC-IP>
```

## Systemd Service (EC2)
The service file is in:
- `scripts/devops-honors.service`

It runs the application from:
- `/home/ec2-user/app/app.jar`

Service commands:
```bash
sudo systemctl daemon-reload
sudo systemctl enable devops-honors
sudo systemctl restart devops-honors
sudo systemctl status devops-honors --no-pager
```

## Jenkins Pipeline Stages (Jenkinsfile)
- Checkout
- Build
- Test
- Archive Artifacts
- Deploy to EC2
- Start Service

## Deployment (What Jenkins Does)
1. Build the JAR with Maven.
2. Archive the JAR in Jenkins.
3. Copy the JAR to `/home/ec2-user/app/app.jar`.
4. Upload the systemd service file to `/etc/systemd/system/`.
5. Restart the service.

## GitHub Actions (Optional)
An optional GitHub Actions workflow is included:
- `.github/workflows/maven-ci.yml`

It builds, tests, and uploads the JAR artifact on pushes to `main`.

## Docker (Optional)
Build and run locally:
```bash
docker build -t devops-honors .
docker run -p 8080:8080 devops-honors
```

## Screenshots (To Add)
- Jenkins pipeline success screen
- GitHub webhook configuration
- EC2 instance running app (browser on port 8080)
- AWS Security Group inbound rules
- Jenkins credentials configuration

## Submission Checklist
- Jenkins pipeline runs successfully
- Artifact archived in Jenkins
- EC2 deployment works (app reachable at `http://<EC2-PUBLIC-IP>:8080/`)
- GitHub webhook triggers build automatically
- README includes all required steps and commands

## Notes
- Do not commit `.pem` files or any secrets.
- If the service fails, check logs on EC2:
```bash
sudo journalctl -u devops-honors -n 100 --no-pager
```
