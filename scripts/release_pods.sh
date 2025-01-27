#!/bin/bash

# Ordered list of .podspecs to push
PODSPECS=(
  "OpenWebCommon.podspec"
  "OpenWebSDK.podspec"
)

# Fetches the remote pod version
get_remote_pod_version() {
  podspec=$1
  pod trunk info "$(basename "$podspec" .podspec)" | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | tail -n 1
}

# get the local pod version
get_local_pod_version() {
  podspec=$1
  pod ipc spec "$podspec" | grep '"version"' | awk -F'"' '{print $4}'
}

# Push a podspec with retries
push_retrying() {
  local podspec=$1
  local max_retries=${2:-10}
  local retries=0

  while :; do
    current_remote_version=$(get_remote_pod_version "$podspec")
    current_local_version=$(get_local_pod_version "$podspec")
    if [[ "$current_remote_version" == "$current_local_version" ]]; then
      echo "No need to push: $podspec. Latest version is already $current_local_version."
      return 0
    fi

    pod trunk push "$podspec" --synchronous --allow-warnings
    if [[ $? -eq 0 ]]; then
      return 0
    elif [[ $retries -ge $max_retries ]]; then
      echo "Unable to push pod $podspec after $max_retries attempts."
      return 1
    fi

    retries=$((retries + 1))
    delay=$((2**retries < 32 ? 2**retries : 32))
    echo "Something went wrong. Trying again in $delay seconds..."
    sleep "$delay"
    echo "Retrying..."
  done
}

# Push all podspecs
push_all() {
  echo "If this is your first time running this command, it's going to take a while."
  echo "Go for a 🚶 or take a ☕️ break."
  echo ""
  echo "Pushing the following podspecs to 'trunk': ${PODSPECS[*]}"

  for podspec in "${PODSPECS[@]}"; do
    push_retrying "$podspec" 5
    if [[ $? -ne 0 ]]; then
      echo "Aborting: Unable to push $podspec."
      echo "If the spec failed due to a missing dependency, wait a few minutes and try again."
      exit 1
    fi
  done
}

# Main execution
push_all