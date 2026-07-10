# WP Lab Marketplace

This repository contains a Codex/ChatGPT plugin marketplace with one plugin: `wp-lab`.

WP Lab starts a local WordPress sandbox with Docker Compose, automatically installs WordPress on first run, and mounts local folders for plugin and theme testing.

## Install In ChatGPT/Codex

Use the ChatGPT/Codex app plugin marketplace flow and choose this repository or local marketplace folder.

Marketplace file:

```text
marketplace.json
```

Plugin path:

```text
plugins/wp-lab
```

## Local Requirements

- Docker Desktop installed and running.
- Ports `8088` and `8089` available.

## Start WP Lab

From the installed plugin folder:

```powershell
.\scripts\wp-lab.ps1 start
```

Default URLs:

```text
WordPress:  http://localhost:8088
Admin:      http://localhost:8088/wp-admin
User:       admin
Password:   admin
phpMyAdmin: http://localhost:8089
```
