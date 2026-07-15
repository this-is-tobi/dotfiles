#!/bin/bash
set -eo pipefail
# Note: deliberately no `set -u` — macOS ships bash 3.2, where an empty array
# (e.g. SECURE_PROXIES when no proxy matches below) combined with nounset
# makes "${arr[@]}" a hard "unbound variable" error (fixed only in bash 4.4+).

# Add proxy configuration to proto
if ([ -n "$HTTP_PROXY" ] || [ -n "$HTTPS_PROXY" ]) && ! grep -q 'proxies =' "$HOME/.proto/.prototools" 2>/dev/null; then
  PROXIES=()
  SECURE_PROXIES=()
  CUSTOM_HOSTS=()

  quote_and_join() {
    local arr=("$@")
    local out=""
    for item in "${arr[@]}"; do
      [ -n "$out" ] && out+=", "
      out+="\"$item\""
    done
    echo "$out"
  }

  if [ -n "$HTTP_PROXY" ]; then
    PROXIES+=("$HTTP_PROXY")
    CUSTOM_HOSTS+=("${HTTP_PROXY#*://}")
    if echo "$HTTP_PROXY" | grep -q 'http://'; then
      SECURE_PROXIES+=("$HTTP_PROXY")
    fi
  fi

  if [ -n "$HTTPS_PROXY" ] && [ "$HTTPS_PROXY" != "$HTTP_PROXY" ]; then
    PROXIES+=("$HTTPS_PROXY")
    CUSTOM_HOSTS+=("${HTTPS_PROXY#*://}")
    if echo "$HTTPS_PROXY" | grep -q 'http://'; then
      SECURE_PROXIES+=("$HTTPS_PROXY")
    fi
  fi

  if [ -n "$(quote_and_join "${SECURE_PROXIES[@]}")" ]; then
    PROTO_ADDITIONAL_CONF="
      [settings.offline]
      custom-hosts = [ $(quote_and_join "${CUSTOM_HOSTS[@]}") ]
      override-default-hosts = true
      
      [settings.http]
      proxies = [ $(quote_and_join "${PROXIES[@]}") ]
      secure-proxies = [ $(quote_and_join "${SECURE_PROXIES[@]}") ]
    "
  else
    PROTO_ADDITIONAL_CONF="
      [settings.offline]
      custom-hosts = [ $(quote_and_join "${CUSTOM_HOSTS[@]}") ]
      override-default-hosts = true
      
      [settings.http]
      proxies = [ $(quote_and_join "${PROXIES[@]}") ]
    "
  fi

  echo "$PROTO_ADDITIONAL_CONF" | sed 's/^ *[[:space:]]*//' >> "$HOME/.proto/.prototools"
fi
