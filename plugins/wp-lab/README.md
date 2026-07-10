# WP Lab

WP Lab is a Codex plugin that starts a local WordPress sandbox for testing plugins and themes.
It includes a minimal default theme so the front end works immediately on fresh installs.

## Requirements

- Docker Desktop installed and running.
- Ports `8088` and `8089` available.

## Start

From the plugin folder:

```powershell
.\scripts\wp-lab.ps1 start
```

The first start installs WordPress automatically and activates the included `wp-lab-minimal` theme.
If an existing install points to a missing theme, WP Lab repairs it by activating the minimal theme.

```text
WordPress:  http://localhost:8088
Admin:      http://localhost:8088/wp-admin
User:       admin
Password:   admin
phpMyAdmin: http://localhost:8089
```

## Add WordPress Plugins

Place plugin folders in:

```text
workspace/plugins/
```

Example:

```text
workspace/plugins/my-plugin/my-plugin.php
```

## Add Themes

Place theme folders in:

```text
workspace/themes/
```

Example:

```text
workspace/themes/my-theme/style.css
```

## Commands

```powershell
.\scripts\wp-lab.ps1 start
.\scripts\wp-lab.ps1 stop
.\scripts\wp-lab.ps1 restart
.\scripts\wp-lab.ps1 status
.\scripts\wp-lab.ps1 logs
.\scripts\wp-lab.ps1 reset
```
