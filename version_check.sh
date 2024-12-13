#!/bin/bash

# Retrieve current GitLab version
current_version=$(sudo /opt/gitlab/bin/gitlab-rake gitlab:env:info | grep "Version:" | awk '{print $2}')

# Target version
target_version="17.3"

if [[ "$current_version" == "16.10.10-ee" && "$target_version" == "17.0" ]]; then
  echo "Direct upgrade from $current_version to $target_version is possible."
  exit 0
elif [[ "$current_version" == "17.0" && "$target_version" == "17.3" ]]; then
  echo "Direct upgrade from $current_version to $target_version is possible."
  exit 0
else
  echo "Direct upgrade from $current_version to $target_version is NOT possible. Upgrade to intermediate version first."
  exit 1
fi
