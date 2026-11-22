#!/usr/bin/env bash
# ==============================================================================
# GuitarTab AI - Automated Setup (Linux / macOS)
# ==============================================================================
set -e

echo "=== GuitarTab AI - Automated Setup (Linux/macOS) ==="

# 1. Submodules
if [ -d ".git" ]; then
    echo "[1/4] Updating submodules (TabVision)..."
    git submodule update --init --recursive
fi

# 2. Backend Environment
echo "[2/4] Setting up Backend Python virtual environment..."
if [ ! -d "backend/.venv" ]; then
    python3 -m venv backend/.venv
fi
backend/.venv/bin/pip install --upgrade pip
backend/.venv/bin/pip install -r backend/requirements.lock.txt

# 3. TabVision Environment
echo "[3/4] Setting up TabVision environment..."
TV_DIR="scratch/tab_vision/tabvision"
if [ -d "$TV_DIR" ]; then
    if [ ! -d "$TV_DIR/.venv" ]; then
        python3 -m venv "$TV_DIR/.venv"
    fi
    "$TV_DIR/.venv/bin/pip" install --upgrade pip
    "$TV_DIR/.venv/bin/pip" install -e "$TV_DIR"
    "$TV_DIR/.venv/bin/pip" install basic-pitch ffmpeg-python
else
    echo "Warning: TabVision directory not found. Please ensure submodules are initialized."
fi

# 4. Frontend Dependencies
echo "[4/4] Installing Lovable frontend dependencies..."
if [ -d "guitartab-lovable" ]; then
    (cd guitartab-lovable && npm install)
fi

echo "=== Setup Complete! ==="
echo "To run backend:  cd backend && .venv/bin/uvicorn app.main:app --reload --port 8000"
echo "To run frontend: cd guitartab-lovable && npm run dev -- --port 5173"
