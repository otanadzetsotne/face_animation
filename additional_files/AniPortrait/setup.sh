#!/bin/bash
set -e  # Exit immediately if a command exits with a non-zero status.

# Get the path to the base script and source it
base_sh="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )/../base.sh"
echo "Sourcing the base script from $base_sh"
source "$base_sh"

# Check if a directory argument is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <directory>"
  exit 1
fi

# Set up the directory for the repository
directory=$1
echo "Creating directory $directory if it does not exist."
mkdir -p "$directory"
cd "$directory"

# Define the repository URL and download the repository
repo_url="https://github.com/Zejun-Yang/AniPortrait"
echo "Downloading repository from $repo_url"
download_repo $repo_url

# Navigate into the repository directory
repo_dir=$(basename $repo_url)
repo_dir="$directory/$repo_dir"
echo "Changing directory to $repo_dir"
cd "$repo_dir"

# Set up Python virtual environment
echo "Setting up Python virtual environment in the current directory"
python -m venv venv
source venv/bin/activate

# Determine the platform and install dependencies accordingly
additional_files_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
echo "Determining platform for dependency installation"
if [ "$(uname -m)" == "arm64" ]; then
  echo "Detected arm64 architecture. Using custom installation scripts."
#  source "$additional_files_dir/xformers_fix.sh"
#  source "$additional_files_dir/install_torch_torchvision_m1.sh"
#  python install -r "$additional_files_dir/requirements.txt"
else
  echo "Using standard requirements.txt for installation."
  python install -r "$repo_dir/requirements.txt"
fi

# Download the weights for the model
weights_dir="$repo_dir/pretrained_model"
echo "Downloading model weights to $weights_dir"
source "$additional_files_dir/download_weights.sh" "$weights_dir"
