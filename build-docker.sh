#!/usr/bin/env bash
set -euo pipefail

sync_proxy_var() {
  local upper_name=$1
  local lower_name=$2
  local upper_value=${!upper_name-}
  local lower_value=${!lower_name-}
  local value=${upper_value:-$lower_value}

  if [[ -n "${value}" ]]; then
    export "${upper_name}=${value}"
    export "${lower_name}=${value}"
  fi
}

sync_proxy_var HTTP_PROXY http_proxy
sync_proxy_var HTTPS_PROXY https_proxy
sync_proxy_var ALL_PROXY all_proxy
sync_proxy_var NO_PROXY no_proxy

export FUTURECODER_LANGUAGE="${FUTURECODER_LANGUAGE:-en}"
export FUTURECODER_LANGUAGES="${FUTURECODER_LANGUAGES:-$FUTURECODER_LANGUAGE}"
export REACT_APP_LANGUAGE="${REACT_APP_LANGUAGE:-$FUTURECODER_LANGUAGE}"

docker compose -f docker/docker-compose.yml build
docker compose -f docker/docker-compose.yml up
