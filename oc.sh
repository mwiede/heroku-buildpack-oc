#!/bin/bash

OC_HOME=${HOME}/".oc-cli"
export PATH=$OC_HOME:$PATH

function log {
  echo "oc-cli  event=$1"
}

function is_configured {
  [[ \
    -v OC_LOGIN_ENDPOINT && \
    -v OC_LOGIN_TOKEN && \
    -v OC_POD_NAME && \
    -v OC_LOCAL_PORT && \
    -v OC_REMOTE_PORT
  ]] && return 0 || return 1
}

function info {
    ${OC_HOME}/oc version
}

function login {
  ${OC_HOME}/oc login ${OC_LOGIN_ENDPOINT} --token=${OC_LOGIN_TOKEN}
}

function spawn_tunnel {
  while true; do
    ACTUAL_OC_POD_NAME=$(oc get pod | grep -Eo "$OC_POD_NAME[^[:space:]]*")
    log "start port-forward to pod ${ACTUAL_OC_POD_NAME}"
    ${OC_HOME}/oc port-forward ${ACTUAL_OC_POD_NAME} ${OC_LOCAL_PORT}:${OC_REMOTE_PORT}
    log "port-forward ended."
    sleep 5;
  done &
}

log "starting"

if is_configured; then
  info
  login
  spawn_tunnel
  log "spawned";
else
  log "missing-configuration"
fi