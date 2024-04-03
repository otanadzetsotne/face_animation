#!/bin/bash
set -e

# This script takes a directory as a positional argument and downloads all necessary weights and models to it.
# It checks for existing directories and completes downloads if they were interrupted.

# Check if the argument is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <directory>"
  exit 1
fi

directory=$1

# Check if the directory exists
if [ ! -d "$directory" ]; then
  echo "Error: Directory '$directory' does not exist."
  exit 1
fi

echo "Listing contents of $directory:"
ls -l "$directory"
cd "$directory"
echo "Working directory changed to $directory"


download_repo() {
  repo_url=$1
  local_dir=$(basename $repo_url)

  if [ -d "$local_dir" ]; then
    echo "$local_dir already exists. Checking for updates..."
    cd "$local_dir"
    # Check if dir is GIT repository
    if git rev-parse --git-dir > /dev/null 2>&1; then
        echo "Resetting local repository to remote"
        git reset --hard
        git pull
    else
        echo "The existing directory is not a git repository."
        exit 1
    fi
    cd ..
  else
    echo "Cloning $local_dir ..."
    git clone $repo_url
  fi
  echo "Done with $local_dir"
}

# Download models repositories
download_repo https://huggingface.co/stabilityai/sd-vae-ft-mse
download_repo https://huggingface.co/facebook/wav2vec2-base-960h
download_repo https://huggingface.co/lambdalabs/sd-image-variations-diffusers/image_encoder
download_repo https://huggingface.co/runwayml/stable-diffusion-v1-5
download_repo https://huggingface.co/ZJYang/AniPortrait
echo "Copying AniPortrait to pretrained_models root..."
cp AniPortrait/* .
echo "Done with copying"
