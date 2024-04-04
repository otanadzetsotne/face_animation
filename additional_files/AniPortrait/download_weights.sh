#!/bin/bash
set -e

# Get the path to the base script and source it
base_sh="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )/../base.sh"
source "$base_sh"

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

# Download models repositories
download_repo https://huggingface.co/stabilityai/sd-vae-ft-mse
download_repo https://huggingface.co/facebook/wav2vec2-base-960h
download_repo https://huggingface.co/lambdalabs/sd-image-variations-diffusers
mkdir -p image_encoder
cp -r sd-image-variations-diffusers/image_encoder/* image_encoder/
download_repo https://huggingface.co/runwayml/stable-diffusion-v1-5
download_repo https://huggingface.co/ZJYang/AniPortrait
echo "Copying AniPortrait to pretrained_models root..."
cp AniPortrait/* .
echo "Done with copying"
