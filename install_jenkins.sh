#!/bin/bash

# Exit immediately if any command fails
set -e

# Update the system
echo "Updating system..."
sudo dnf update -y

# Install Java (Jenkins requires Java, Amazon Corretto is a good choice)
echo "Installing Java (Amazon Corretto)..."
sudo dnf install -y java-17-amazon-corretto
java --version  # Confirm Java installation

# Install Jenkins
echo "Installing Jenkins..."
sudo dnf install -y wget
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
sudo dnf upgrade -y
sudo dnf install -y jenkins
sudo systemctl enable --now jenkins
sudo systemctl status jenkins || { echo "Jenkins failed to start"; exit 1; }

# Jenkins should be running now. The default port for Jenkins is 8080.
echo "Jenkins is now installed and running on port 8080."
