# Dummy Systemd Service

This project demonstrates a simple long-running systemd service that logs messages every 10 seconds.  
It helps you learn systemd concepts like creating and enabling services, monitoring logs, auto-restart, and managing services.

---

## Project Structure

```

DevOps-Projects/
│
├─ scripts/
│   └─ dummy.sh
├─ dummy.service
└─ README.md

````

- `scripts/dummy.sh` → The script run by the service  
- `dummy.service` → The systemd service unit file

---

## dummy.sh

```bash
#!/bin/bash

while true; do
  echo "Dummy service is running..." | tee -a /var/log/dummy-service.log
  sleep 10
done
````

* Prints `"Dummy service is running..."` every 10 seconds
* Writes logs both to **journalctl** and `/var/log/dummy-service.log`

Make sure the script is executable:

```bash
chmod +x scripts/dummy.sh
```

---

## dummy.service

```ini
[Unit]
Description=Dummy long-running service
After=multi-user.target

[Service]
Type=simple
ExecStart=/opt/dummy/dummy.sh
Restart=always
RestartSec=5
User=root
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
```

* `ExecStart` → Path to the script (`/opt/dummy/dummy.sh`)
* `Restart=always` → Automatically restarts if the service crashes
* `StandardOutput` & `StandardError` → Logs go to journal
* Runs as **root** (can be changed if needed)

---

## Deployment Instructions

1. Create a fixed directory for the script:

```bash
sudo mkdir -p /opt/dummy
sudo cp scripts/dummy.sh /opt/dummy/dummy.sh
sudo chmod +x /opt/dummy/dummy.sh
```

2. Copy the service file:

```bash
sudo cp dummy.service /etc/systemd/system/dummy.service
```

3. Reload systemd and start the service:

```bash
sudo systemctl daemon-reload
sudo systemctl enable --now dummy
```

---

## Managing the Service

* Start service:

```bash
sudo systemctl start dummy
```

* Stop service:

```bash
sudo systemctl stop dummy
```

* Enable service at boot:

```bash
sudo systemctl enable dummy
```

* Disable service at boot:

```bash
sudo systemctl disable dummy
```

* Check status:

```bash
sudo systemctl status dummy
```

* View logs in real-time:

```bash
sudo journalctl -u dummy -f
```

---

## Logs

* **Journal logs** → `journalctl -u dummy -f`
* **File logs** → `/var/log/dummy-service.log`

Using `tee -a` in `dummy.sh` ensures logs are written both to the journal and the file.

---

## Notes

* Always use **absolute paths** for `ExecStart` to avoid dependency on local directories
* Ensure the script is executable and writable logs exist
* This setup is ready for deployment on any Linux server with systemd

```

---

 This project is part of [roadmap.sh](https://roadmap.sh/projects/dummy-systemd-service) DevOps projects.
