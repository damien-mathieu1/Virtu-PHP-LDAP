#!/usr/bin/env bash
echo "Starting docker containers"
echo "=========================="

docker compose up -d

KEYCLOAK_HOST_PORT=${1:-"localhost:8080"}

ADMIN_TOKEN=$(curl -s -X POST "http://$KEYCLOAK_HOST_PORT/realms/master/protocol/openid-connect/token" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "username=admin" \
  -d 'password=admin' \
  -d 'grant_type=password' \
  -d 'client_id=admin-cli' | jq -r '.access_token')

while [ -z "$ADMIN_TOKEN" ]
do
  echo "Waiting for Keycloak to start"
  sleep 5
  ADMIN_TOKEN=$(curl -s -X POST "http://$KEYCLOAK_HOST_PORT/realms/master/protocol/openid-connect/token" \
    -H "Content-Type: application/x-www-form-urlencoded" \
    -d "username=admin" \
    -d 'password=admin' \
    -d 'grant_type=password' \
    -d 'client_id=admin-cli' | jq -r '.access_token')
done

sleep 20
./scripts/import-openldap-users.sh
./scripts/init-keycloak.sh

echo "Keycloak is ready"
echo "=================="
echo "Keycloak URL: http://$KEYCLOAK_HOST_PORT"

echo "PHP is ready"
echo "============"
echo "PHP URL: http://localhost:80/index.php"