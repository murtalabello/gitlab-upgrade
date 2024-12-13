#!/bin/bash

current_version=$(/opt/gitlab/bin/gitlab-rake gitlab:env:info | grep "GitLab version" | awk '{print $3}')
target_version=$1

echo "Current GitLab version: $current_version"
echo "Target GitLab version: $target_version"

if [[ "$current_version" == "16.10" && "$target_version" == "17.0" ]]; then
  echo "Upgrade path valid: $current_version -> $target_version"
  exit 0
elif [[ "$current_version" == "17.0" && "$target_version" == "17.3" ]]; then
  echo "Upgrade path valid: $current_version -> $target_version"
  exit 0
else
  echo "Direct upgrade from $current_version to $target_version is NOT possible. Upgrade to intermediate version first."
  exit 1
fi
