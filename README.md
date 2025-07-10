# rpi-scripts

A collection of handy Raspberry Pi scripts. Starting with a simple installer for Docker Engine and Portainer CE on Raspberry Pi OS (or any Debian-based ARM).

---

## Quick Install (Docker + Portainer)

```bash
curl -sL https://raw.githubusercontent.com/<your-username>/rpi-scripts/main/install_docker_portainer.sh \
  -o install_docker_portainer.sh
chmod +x install_docker_portainer.sh
sudo ./install_docker_portainer.sh
```

After completion:

* Log out/in (or reboot) to activate Docker group membership.
* Access Portainer: `https://<PI_IP>:9443` (admin setup on first visit).

---

## What’s Inside

* **install\_docker\_portainer.sh**: Installs and configures Docker, adds your user to the `docker` group, creates a `portainer_data` volume, and deploys Portainer CE (ports 8000 & 9443).

More scripts coming soon – stay tuned!

---

