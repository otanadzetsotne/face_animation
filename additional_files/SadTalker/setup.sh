#!/bin/bash
set -e  # Exit immediately if a command exits with a non-zero status.

echo "Checking for conda installation..."
if ! command -v conda &> /dev/null; then
    echo "conda could not be found. Please install Miniconda or Anaconda."
    exit 1
else
    echo "Conda found."
fi

# Optionally, to ensure conda is properly initialized in your shell, uncomment the next line.
# echo "Initializing conda for Bash..."
# conda init bash

echo "Locating the base script..."
base_sh="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)/../base.sh"
echo "Sourcing the base script from $base_sh"
source "$base_sh"

if [ -z "$1" ]; then
  echo "Usage: $0 <directory>"
  exit 1
fi

directory=$1
echo "Setting up the directory at $directory for the repository."
mkdir -p "$directory"
cd "$directory"

echo "Downloading repository..."
repo_url=https://github.com/OpenTalker/SadTalker
download_repo "$repo_url"

repo_dir=$(basename $repo_url)
repo_dir="$directory/$repo_dir"

echo "Navigating to the repository directory: $repo_dir"
cd "$repo_dir"

echo "Creating conda environment $env_name..."
env_name=face_animation_SadTalker
conda create -n $env_name python=3.8 -y

echo "Activating conda environment: $env_name"
conda activate $env_name

echo "Installing PyTorch and dependencies..."
pip install torch torchvision torchaudio
echo "Installing ffmpeg via conda..."
conda install ffmpeg -y
echo "Installing Python packages from requirements.txt..."
pip install -r requirements.txt
echo "Installing dlib..."
pip install dlib # Note: macOS might need additional steps for dlib.

echo "Setup completed successfully."
