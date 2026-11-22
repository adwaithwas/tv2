<#
.SYNOPSIS
    Automated setup script for GuitarTab AI on Windows.
#>
$ErrorActionPreference = "Stop"

Write-Host "=============================================" -ForegroundColor Cyan
Write-Host " GuitarTab AI - Automated Setup (Windows)    " -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan

# 1. Submodules
Write-Host "`n[1/4] Updating submodules (TabVision)..." -ForegroundColor Yellow
if (Test-Path ".git") {
    git submodule update --init --recursive
}

# 2. Backend Environment
Write-Host "`n[2/4] Setting up Backend Python virtual environment..." -ForegroundColor Yellow
if (-not (Test-Path "backend\.venv")) {
    python -m venv backend\.venv
}
& "backend\.venv\Scripts\python.exe" -m pip install --upgrade pip
& "backend\.venv\Scripts\python.exe" -m pip install -r backend\requirements.lock.txt

# 3. TabVision Environment
Write-Host "`n[3/4] Setting up TabVision environment..." -ForegroundColor Yellow
$tvDir = "scratch\tab_vision\tabvision"
if (Test-Path $tvDir) {
    if (-not (Test-Path "$tvDir\.venv")) {
        python -m venv "$tvDir\.venv"
    }
    & "$tvDir\.venv\Scripts\python.exe" -m pip install --upgrade pip
    & "$tvDir\.venv\Scripts\python.exe" -m pip install -e "$tvDir"
    & "$tvDir\.venv\Scripts\python.exe" -m pip install basic-pitch ffmpeg-python
} else {
    Write-Warning "TabVision source not found in $tvDir. Please ensure submodules are initialized."
}

# 4. Frontend Dependencies
Write-Host "`n[4/4] Installing Lovable frontend dependencies..." -ForegroundColor Yellow
if (Test-Path "guitartab-lovable") {
    Push-Location "guitartab-lovable"
    npm install
    Pop-Location
}

Write-Host "`n=============================================" -ForegroundColor Green
Write-Host " Setup Complete!                             " -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Green
Write-Host "To run backend:  cd backend; .\.venv\Scripts\uvicorn app.main:app --reload --port 8000"
Write-Host "To run frontend: cd guitartab-lovable; npm run dev -- --port 5173"
