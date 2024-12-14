#!/bin/bash

current_version=$(sudo /opt/gitlab/bin/gitlab-rake gitlab:env:info | grep "Version:" | awk '{print $2}')
target_version=$1

if [[ -z "$current_version" ]]; then
  echo "Error: Unable to determine the current GitLab version."
  exit 1
fi

echo "Current GitLab version: $current_version"
echo "Target GitLab version: $target_version"

if [[ "$current_version" == "16.10.10-ee" && "$target_version" == "17.0" ]]; then
  echo "Upgrade path validated. Proceeding with upgrade to $target_version."
  exit 0
elif [[ "$current_version" == "17.0" && "$target_version" == "17.3" ]]; then
  echo "Upgrade path validated. Proceeding with upgrade to $target_version."
  exit 0
else
  echo "Direct upgrade from $current_version to $target_version is NOT possible. Upgrade to intermediate version first."
  exit 1
fi
