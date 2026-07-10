param(
  [Parameter(Position = 0)]
  [ValidateSet("start", "stop", "restart", "status", "open", "reset", "logs")]
  [string] $Command = "status"
)

$ErrorActionPreference = "Stop"
$PluginRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$ComposeFile = Join-Path $PSScriptRoot "docker-compose.yml"
$Workspace = Join-Path $PluginRoot "workspace"
$SiteUrl = "http://localhost:8088"
$AdminUser = "admin"
$AdminPassword = "admin"
$AdminEmail = "admin@example.local"
$DefaultTheme = "wp-lab-minimal"

function Ensure-Workspace {
  New-Item -ItemType Directory -Force -Path `
    (Join-Path $Workspace "plugins"), `
    (Join-Path $Workspace "themes"), `
    (Join-Path $Workspace "uploads") | Out-Null
}

function Require-Docker {
  if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
    throw "Docker is not available. Install and start Docker Desktop, then run this command again."
  }
}

function Invoke-Compose {
  param([string[]] $ComposeArgs)
  Require-Docker
  Ensure-Workspace
  $PreviousErrorActionPreference = $ErrorActionPreference
  $ErrorActionPreference = "Continue"

  try {
    & docker compose -f $ComposeFile -p wp-lab @ComposeArgs
    $ExitCode = $LASTEXITCODE
  }
  finally {
    $ErrorActionPreference = $PreviousErrorActionPreference
  }

  $global:LASTEXITCODE = $ExitCode
}

function Invoke-WpCli {
  param([string[]] $WpArgs)
  $WpCliArgs = @("run", "--rm", "--no-deps", "wpcli", "--allow-root") + $WpArgs
  Invoke-Compose $WpCliArgs
}

function Wait-For-WordPress {
  Write-Host "Waiting for WordPress files and database..."

  for ($i = 0; $i -lt 60; $i++) {
    Invoke-WpCli @("core", "version") *> $null
    if ($LASTEXITCODE -eq 0) {
      return
    }

    Start-Sleep -Seconds 2
  }

  throw "WordPress did not become ready in time."
}

function Install-WordPressIfNeeded {
  Wait-For-WordPress

  Invoke-WpCli @("core", "is-installed") *> $null
  if ($LASTEXITCODE -eq 0) {
    Write-Host "WordPress is already installed."
    Ensure-DefaultThemeIfNeeded
    Ensure-AdminUser
    return
  }

  Write-Host "Installing WordPress automatically..."
  Invoke-WpCli @(
    "core", "install",
    "--url=$SiteUrl",
    "--title=WP Lab",
    "--admin_user=$AdminUser",
    "--admin_password=$AdminPassword",
    "--admin_email=$AdminEmail",
    "--skip-email"
  )

  Invoke-WpCli @("option", "update", "timezone_string", "Europe/Madrid") | Out-Null
  Invoke-WpCli @("theme", "activate", $DefaultTheme) | Out-Null
  Invoke-WpCli @("rewrite", "structure", "/%postname%/", "--hard") | Out-Null
  Ensure-AdminUser
  Write-Host "WordPress is ready."
}

function Ensure-DefaultThemeIfNeeded {
  Invoke-WpCli @("theme", "is-installed", $DefaultTheme) *> $null
  if ($LASTEXITCODE -ne 0) {
    return
  }

  $currentTheme = Invoke-WpCli @("option", "get", "stylesheet") 2>$null |
    Where-Object { $_ -and $_ -notmatch "^\s*Container " } |
    Select-Object -First 1

  if (-not $currentTheme) {
    Invoke-WpCli @("theme", "activate", $DefaultTheme) | Out-Null
    return
  }

  Invoke-WpCli @("theme", "is-installed", $currentTheme) *> $null
  if ($LASTEXITCODE -ne 0) {
    Invoke-WpCli @("theme", "activate", $DefaultTheme) | Out-Null
  }
}

function Ensure-AdminUser {
  Invoke-WpCli @("user", "get", $AdminUser) *> $null
  if ($LASTEXITCODE -eq 0) {
    Invoke-WpCli @("user", "update", $AdminUser, "--user_pass=$AdminPassword", "--role=administrator") | Out-Null
    Write-Host "Admin user is ready."
    return
  }

  Invoke-WpCli @(
    "user", "create",
    $AdminUser,
    $AdminEmail,
    "--user_pass=$AdminPassword",
    "--role=administrator"
  ) | Out-Null
  Write-Host "Admin user is ready."
}

switch ($Command) {
  "start" {
    Invoke-Compose @("up", "-d")
    Install-WordPressIfNeeded
    Write-Host "WP Lab is ready."
    Write-Host "WordPress:  $SiteUrl"
    Write-Host "Admin:      $SiteUrl/wp-admin"
    Write-Host "User:       $AdminUser"
    Write-Host "Password:   $AdminPassword"
    Write-Host "phpMyAdmin: http://localhost:8089"
  }
  "stop" {
    Invoke-Compose @("down")
  }
  "restart" {
    Invoke-Compose @("down")
    Invoke-Compose @("up", "-d")
    Install-WordPressIfNeeded
  }
  "status" {
    Invoke-Compose @("ps")
  }
  "open" {
    Start-Process "http://localhost:8088"
    Start-Process "http://localhost:8089"
  }
  "reset" {
    Invoke-Compose @("down", "-v")
    Write-Host "WP Lab data has been reset. Run '.\scripts\wp-lab.ps1 start' to create a fresh site."
  }
  "logs" {
    Invoke-Compose @("logs", "-f", "--tail", "200")
  }
}
