#!/bin/bash

# Retrieve current GitLab version
current_version=$(sudo /opt/gitlab/bin/gitlab-rake gitlab:env:info | grep -i "Version:" | awk '{print $2}' | head -1)

# Target version passed as an argument
target_version="$1"

# Define valid upgrade paths
valid_upgrade_paths=(
  "16.10.10-ee:17.0"
  "17.0:17.1"
  "17.1:17.3"
)

# Function to validate upgrade path
validate_upgrade_path() {
  for path in "${valid_upgrade_paths[@]}"; do
    if [[ "$current_version:$target_version" == "$path" ]]; then
      return 0
    fi
  done
  return 1
}

# Check if upgrade is valid
if validate_upgrade_path; then
  echo "Direct upgrade from $current_version to $target_version is possible."
  exit 0
else
  echo "Direct upgrade from $current_version to $target_version is NOT possible. Upgrade to intermediate version first."
  exit 1
fi
