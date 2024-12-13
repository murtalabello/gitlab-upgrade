#!/bin/bash

# Retrieve current GitLab version
current_version=$(sudo /opt/gitlab/bin/gitlab-rake gitlab:env:info | grep -i "Version:" | awk 'NR==1{print $2}')

# Target version passed as an argument
target_version="$1"

# Log current and target versions for debugging
echo "Current GitLab version: $current_version"
echo "Target GitLab version: $target_version"

# Define valid upgrade paths
declare -A valid_upgrade_paths
valid_upgrade_paths["16.10.10-ee"]="17.0"
valid_upgrade_paths["17.0"]="17.1"
valid_upgrade_paths["17.1"]="17.3"

# Validate upgrade path
if [[ "${valid_upgrade_paths[$current_version]}" == "$target_version" ]]; then
  echo "Direct upgrade from $current_version to $target_version is possible."
  exit 0
else
  echo "Direct upgrade from $current_version to $target_version is NOT possible. Upgrade to intermediate version first."
  exit 1
fi
