#!/bin/bash

# Get the current GitLab version (using the full path to gitlab-rake)
current_version=$(/opt/gitlab/bin/gitlab-rake gitlab:env:info | grep "GitLab version" | awk '{print $4}')

# Check if gitlab-rake command was successful
if [[ -z "$current_version" ]]; then
  echo "Failed to retrieve the current GitLab version. Ensure gitlab-rake is available and configured correctly."
  exit 1
fi

# Target GitLab version
target_version="17.3"

# Function to check if the upgrade path is valid
check_upgrade_path() {
  local current="$1"
  local target="$2"

  case "$current" in
    "16.10")
      # Valid upgrade paths from 16.10
      if [[ "$target" == "17.0" ]]; then
        return 0  # Valid upgrade to 17.0
      fi
      ;;
    "17.0")
      # Valid upgrade paths from 17.0
      if [[ "$target" == "17.1" || "$target" == "17.2" || "$target" == "17.3" ]]; then
        return 0  # Valid upgrade to 17.1, 17.2, or 17.3
      fi
      ;;
    *)
      echo "Upgrade path not defined for version $current."
      return 1  # Invalid upgrade for other versions
      ;;
  esac

  # If no match was found in the case statement, the upgrade is not valid
  return 1
}

# Perform the upgrade path validation
if check_upgrade_path "$current_version" "$target_version"; then
  echo "Direct upgrade from $current_version to $target_version is possible."
  exit 0  # Exit with 0 for success
else
  echo "Direct upgrade from $current_version to $target_version is NOT possible."
  echo "You may need to upgrade to an intermediate version first."
  exit 1  # Exit with 1 for failure
fi
