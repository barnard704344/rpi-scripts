#!/usr/bin/env bash
#
# install_docker_portainer.sh
# Installs Docker Engine and Portainer CE on Raspberry Pi OS / Debian ARM
# Usage: sudo ./install_docker_portainer.sh

set -euo pipefail

# Ensure running as root
if [[ "$(id -u)" -ne 0 ]]; then
  echo "⚠️  Please run as root (e.g. sudo $0)"
  exit 1
fi

echo "🔄 Updating package lists…"
apt-get update -y

echo "📦 Installing prerequisites…"
apt-get install -y \
  apt-transport-https \
  ca-certificates \
  curl \
  gnupg \
  lsb-release

echo "🔐 Adding Docker’s official GPG key…"
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo "🏷️  Setting up Docker repo…"
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] \
  https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" \
  > /etc/apt/sources.list.d/docker.list

echo "🔄 Updating package lists (with Docker repo)…"
apt-get update -y

echo "📦 Installing Docker Engine…"
apt-get install -y docker-ce docker-ce-cli containerd.io

echo "✅ Enabling and starting Docker service…"
systemctl enable docker
systemctl start docker

# Determine which non-root user to add to 'docker' group
TARGET_USER="${SUDO_USER:-${USER:-pi}}"
if id "$TARGET_USER" &>/dev/null; then
  echo "➕ Adding user '$TARGET_USER' to docker group…"
  usermod -aG docker "$TARGET_USER"
else
  echo "⚠️  Could not find user '$TARGET_USER'; skipping group add."
fi

echo "🔄 Creating Portainer data volume…"
docker volume create portainer_data

echo "🚀 Deploying Portainer CE container…"
docker run -d \
  --name portainer \
  --restart=always \
  -p 8000:8000 \        # Portainer agent
  -p 9443:9443 \        # Portainer UI (HTTPS)
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v portainer_data:/data \
  portainer/portainer-ce:latest

echo
echo "🎉 Done! Docker & Portainer are installed."
echo " • To finish, log out and back in (or reboot) so your user can run Docker without sudo."
echo " • Browse to https://<your-pi-ip>:9443 to complete Portainer setup."
