#!/bin/bash

# Fetch the current GitLab version
CURRENT_VERSION=$(sudo /opt/gitlab/bin/gitlab-rake gitlab:env:info | grep 'Version:' | awk '{print $2}')

# Target GitLab version from argument
TARGET_VERSION=$1

# Check if the current version is empty
if [ -z "$CURRENT_VERSION" ]; then
  echo "Error: Unable to fetch the current GitLab version."
  exit 1
fi

echo "Current GitLab version: $CURRENT_VERSION"
echo "Target GitLab version: $TARGET_VERSION"

# Define the upgrade path logic
if [[ "$CURRENT_VERSION" < "17.0" ]]; then
  if [[ "$TARGET_VERSION" == "17.0" ]]; then
    echo "Direct upgrade from $CURRENT_VERSION to $TARGET_VERSION is NOT possible. Upgrade to intermediate version first."
    exit 1
  fi
else
  echo "Upgrade path is valid."
  exit 0
fi
