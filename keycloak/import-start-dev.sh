#!/bin/bash
set -e

# Start Keycloak in the background
/opt/keycloak/bin/kc.sh start-dev &

# Wait for Keycloak to be ready
until curl -s -f -o /dev/null "http://localhost:8080"
do
  echo "Waiting for Keycloak to start..."
  sleep 10
done

# Import the realm file
/opt/keycloak/bin/kc.sh import --file /opt/keycloak/data/import/master-realm.json

# Bring Keycloak to foreground
fg %1
