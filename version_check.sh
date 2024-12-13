#!/bin/bash

# Locate gitlab-rake dynamically
GITLAB_RAKE="/opt/gitlab/bin/gitlab-rake"

# Check if gitlab-rake exists and is executable
if [[ ! -x "$GITLAB_RAKE" ]]; then
  echo "Error: gitlab-rake not found or not executable at $GITLAB_RAKE"
  exit 1
fi

# Get the current GitLab version
current_version=$($GITLAB_RAKE gitlab:env:info | grep "GitLab version" | awk '{print $4}')

# Check if the version was retrieved successfully
if [[ -z "$current_version" ]]; then
  echo "Error: Unable to retrieve the current GitLab version."
  exit 1
fi

echo "Current GitLab version: $current_version"

# Target GitLab version
target_version="17.3"

# Function to check upgrade path
check_upgrade_path() {
  local current="$1"
  local target="$2"

  case "$current" in
    "16.10")
      # Valid upgrade path: 16.10 -> 17.0
      if [[ "$target" == "17.0" ]]; then
        return 0
      fi
      ;;
    "17.0")
      # Valid upgrade paths: 17.0 -> 17.1, 17.2, 17.3
      if [[ "$target" == "17.1" || "$target" == "17.2" || "$target" == "17.3" ]]; then
        return 0
      fi
      ;;
    *)
      echo "Upgrade path not defined for current version: $current"
      return 1
      ;;
  esac

  # If no match, the upgrade path is invalid
  return 1
}

# Validate the upgrade path
if check_upgrade_path "$current_version" "$target_version"; then
  echo "Direct upgrade from $current_version to $target_version is possible."
  exit 0
else
  echo "Direct upgrade from $current_version to $target_version is NOT possible."
  echo "Please upgrade to an intermediate version first."
  exit 1
fi
