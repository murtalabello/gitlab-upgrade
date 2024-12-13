#!/bin/bash

# Get the current GitLab version
current_version=$(/opt/gitlab/bin/gitlab-rake gitlab:env:info | grep "GitLab version" | awk '{print $4}')

# Target GitLab version
target_version="17.3"

# Function to check upgrade path
check_upgrade_path() {
  local current="$1"
  local target="$2"

  case "$current" in
    "16.10")
      [[ "$target" == "17.0" ]] && return 0
      ;;
    "17.0")
      [[ "$target" == "17.1" || "$target" == "17.2" || "$target" == "17.3" ]] && return 0
      ;;
    *)
      echo "Upgrade path not defined for $current"
      return 1
      ;;
  esac
  return 1
}

# Perform the check
if check_upgrade_path "$current_version" "$target_version"; then
  echo "Direct upgrade from $current_version to $target_version is possible."
  exit 0
else
  echo "Direct upgrade from $current_version to $target_version is NOT possible."
  exit 1
fi
