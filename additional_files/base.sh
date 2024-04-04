#!/bin/bash
set -e

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