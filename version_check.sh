#!/bin/bash

current_version=$(sudo /opt/gitlab/bin/gitlab-rake gitlab:env:info | grep "Version:" | awk '{print $2}')

target_version="17.3"

case "$current_version" in
  "16.10.10-ee")
    if [[ "$target_version" == "17.0" ]]; then
      echo "Direct upgrade from $current_version to $target_version is possible."
      exit 0
    fi
    ;;
  "17.0")
    if [[ "$target_version" == "17.3" ]]; then
      echo "Direct upgrade from $current_version to $target_version is possible."
      exit 0
    fi
    ;;
  *)
    echo "Direct upgrade from $current_version to $target_version is NOT possible."
    echo "Please upgrade to an intermediate version first."
    exit 1
    ;;
esac
