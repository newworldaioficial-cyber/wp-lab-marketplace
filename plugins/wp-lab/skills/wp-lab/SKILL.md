---
name: wp-lab
description: Start, manage, and use a local WordPress sandbox for testing WordPress plugins and themes with Docker Compose.
---

# WP Lab

Use this skill when the user wants to install WordPress locally, start or stop a WordPress sandbox, test a WordPress plugin, test a WordPress theme, or inspect files mounted into a local WordPress environment.

## Environment

The lab lives inside this plugin at:

- `scripts/docker-compose.yml`
- `workspace/plugins/`
- `workspace/themes/`
- `workspace/uploads/`

The WordPress site runs at `http://localhost:8088` and phpMyAdmin runs at `http://localhost:8089`.

Default credentials:

- WordPress database: `wordpress`
- Database user: `wordpress`
- Database password: `wordpress`
- Database root password: `root`

## Commands

Run commands from the plugin root.

Start the lab:

```powershell
.\scripts\wp-lab.ps1 start
```

The start command automatically installs WordPress when the site is fresh. The local admin login is:

- Admin URL: `http://localhost:8088/wp-admin`
- User: `admin`
- Password: `admin`

Stop the lab:

```powershell
.\scripts\wp-lab.ps1 stop
```

Show status:

```powershell
.\scripts\wp-lab.ps1 status
```

Open WordPress and phpMyAdmin:

```powershell
.\scripts\wp-lab.ps1 open
```

Reset WordPress data:

```powershell
.\scripts\wp-lab.ps1 reset
```

## Testing Plugins

Put plugin folders in `workspace/plugins/`. Each plugin should have its own folder, for example:

```text
workspace/plugins/my-plugin/my-plugin.php
```

After starting the lab, activate the plugin in WordPress at `http://localhost:8088/wp-admin/plugins.php`.

## Testing Themes

Put theme folders in `workspace/themes/`. Each theme should have its own folder, for example:

```text
workspace/themes/my-theme/style.css
```

After starting the lab, activate the theme in WordPress at `http://localhost:8088/wp-admin/themes.php`.

## Notes

Docker Desktop must be installed and running. If `docker` is not available, explain that the plugin is ready but WordPress cannot start until Docker Desktop is installed.
