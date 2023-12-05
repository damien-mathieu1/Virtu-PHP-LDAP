#!/usr/bin/env bash

KEYCLOAK_HOST_PORT=${1:-"localhost:8080"}
echo
echo "KEYCLOAK_HOST_PORT: $KEYCLOAK_HOST_PORT"
echo

echo "Getting admin access token"
echo "=========================="

ADMIN_TOKEN=$(curl -s -X POST "http://$KEYCLOAK_HOST_PORT/realms/master/protocol/openid-connect/token" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "username=admin" \
  -d 'password=admin' \
  -d 'grant_type=password' \
  -d 'client_id=admin-cli' | jq -r '.access_token')

echo "ADMIN_TOKEN=$ADMIN_TOKEN"
echo

echo "Creating realm"
echo "=============="

curl -i -X POST "http://$KEYCLOAK_HOST_PORT/admin/realms" \
  -H "Authorization: Bearer $ADMIN_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"realm": "virtu-corp", "enabled": true}'

echo "Creating iut realm"
echo "=============="

curl -i -X POST "http://$KEYCLOAK_HOST_PORT/admin/realms" \
  -H "Authorization: Bearer $ADMIN_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"realm": "virtu-corp-iut", "enabled": true}'

echo "Creating client"
echo "==============="

CLIENT_ID=$(curl -si -X POST "http://$KEYCLOAK_HOST_PORT/admin/realms/virtu-corp/clients" \
  -H "Authorization: Bearer $ADMIN_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"clientId": "ldap-service", "directAccessGrantsEnabled": true,"redirectUris": ["http://localhost:80/index.php"], "webOrigins": ["http://localhost:8081"], "publicClient": true}' \
  | grep -oE '[a-fA-F0-9]{8}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{12}')

echo "CLIENT_ID=$CLIENT_ID"
echo


echo "Creating client iut"
echo "==============="

CLIENT_ID_IUT=$(curl -si -X POST "http://$KEYCLOAK_HOST_PORT/admin/realms/virtu-corp-iut/clients" \
  -H "Authorization: Bearer $ADMIN_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"clientId": "ldap-service", "directAccessGrantsEnabled": true,"redirectUris": ["http://localhost:80/index.php"], "webOrigins": ["http://localhost:8081"], "publicClient": true}' \
  | grep -oE '[a-fA-F0-9]{8}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{12}')


echo "Getting client secret"
echo "====================="

SIMPLE_SERVICE_CLIENT_SECRET=$(curl -s -X POST "http://$KEYCLOAK_HOST_PORT/admin/realms/virtu-corp/clients/$CLIENT_ID/client-secret" \
  -H "Authorization: Bearer $ADMIN_TOKEN" | jq -r '.value')

echo "SIMPLE_SERVICE_CLIENT_SECRET=$SIMPLE_SERVICE_CLIENT_SECRET"
echo

echo "Getting client secret iut"
echo "====================="

SIMPLE_SERVICE_CLIENT_SECRET_IUT=$(curl -s -X POST "http://$KEYCLOAK_HOST_PORT/admin/realms/virtu-corp-iut/clients/$CLIENT_ID_IUT/client-secret" \
  -H "Authorization: Bearer $ADMIN_TOKEN" | jq -r '.value')

echo "SIMPLE_SERVICE_CLIENT_SECRET_IUT=$SIMPLE_SERVICE_CLIENT_SECRET_IUT"
echo

echo "Creating client role"
echo "===================="

curl -i -X POST "http://$KEYCLOAK_HOST_PORT/admin/realms/virtu-corp/clients/$CLIENT_ID/roles" \
-H "Authorization: Bearer $ADMIN_TOKEN" \
-H "Content-Type: application/json" \
-d '{"name": "USER"}'

ROLE_ID=$(curl -s "http://$KEYCLOAK_HOST_PORT/admin/realms/virtu-corp/clients/$CLIENT_ID/roles" \
  -H "Authorization: Bearer $ADMIN_TOKEN" | jq -r '.[0].id')

echo "ROLE_ID=$ROLE_ID"
echo

echo "Creating client role iut"
echo "===================="

curl -i -X POST "http://$KEYCLOAK_HOST_PORT/admin/realms/virtu-corp-iut/clients/$CLIENT_ID_IUT/roles" \
-H "Authorization: Bearer $ADMIN_TOKEN" \
-H "Content-Type: application/json" \
-d '{"name": "USER"}'

ROLE_ID_IUT=$(curl -s "http://$KEYCLOAK_HOST_PORT/admin/realms/virtu-corp-iut/clients/$CLIENT_ID_IUT/roles" \
  -H "Authorization: Bearer $ADMIN_TOKEN" | jq -r '.[0].id')

echo "ROLE_ID_IUT=$ROLE_ID_IUT"
echo

echo "Configuring LDAP"
echo "================"

LDAP_ID=$(curl -si -X POST "http://$KEYCLOAK_HOST_PORT/admin/realms/virtu-corp/components" \
  -H "Authorization: Bearer $ADMIN_TOKEN" \
  -H "Content-Type: application/json" \
  -d '@ldap-seed/ldap-config.json' \
  | grep -oE '[a-fA-F0-9]{8}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{12}')

echo "LDAP_ID=$LDAP_ID"
echo

echo "Sync LDAP Users"
echo "==============="

curl -i -X POST "http://$KEYCLOAK_HOST_PORT/admin/realms/virtu-corp/user-storage/$LDAP_ID/sync?action=triggerFullSync" \
  -H "Authorization: Bearer $ADMIN_TOKEN"

echo
echo

echo "Configuring LDAP IUT"
echo "================"

LDAP_ID_IUT=$(curl -si -X POST "http://$KEYCLOAK_HOST_PORT/admin/realms/virtu-corp-iut/components" \
  -H "Authorization: Bearer $ADMIN_TOKEN" \
  -H "Content-Type: application/json" \
  -d '@ldap-seed/ldap-config-iut.json' \
  | grep -oE '[a-fA-F0-9]{8}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{12}')

echo "LDAP_ID_IUT=$LDAP_ID_IUT"
echo

echo "Sync LDAP Users IUT"
echo "==============="

curl -i -X POST "http://$KEYCLOAK_HOST_PORT/admin/realms/virtu-corp-iut/user-storage/$LDAP_ID/sync?action=triggerFullSync" \
  -H "Authorization: Bearer $ADMIN_TOKEN"

echo
echo
echo "Get mathieud id"
echo "============="

BGATES_ID=$(curl -s "http://$KEYCLOAK_HOST_PORT/admin/realms/virtu-corp/users?username=mathieud" \
  -H "Authorization: Bearer $ADMIN_TOKEN"  | jq -r '.[0].id')

echo "BGATES_ID=$BGATES_ID"
echo

echo "Setting client role to bgates"
echo "============================="

curl -i -X POST "http://$KEYCLOAK_HOST_PORT/admin/realms/virtu-corp/users/$BGATES_ID/role-mappings/clients/$CLIENT_ID" \
  -H "Authorization: Bearer $ADMIN_TOKEN" \
  -H "Content-Type: application/json" \
  -d '[{"id":"'"$ROLE_ID"'","name":"USER"}]'

echo "Get sjobs id"
echo "============"

SJOBS_ID=$(curl -s "http://$KEYCLOAK_HOST_PORT/admin/realms/virtu-corp/users?username=sjobs" \
  -H "Authorization: Bearer $ADMIN_TOKEN"  | jq -r '.[0].id')

echo "SJOBS_ID=$SJOBS_ID"
echo

echo "Setting client role to sjobs"
echo "============================"

curl -i -X POST "http://$KEYCLOAK_HOST_PORT/admin/realms/virtu-corp/users/$SJOBS_ID/role-mappings/clients/$CLIENT_ID" \
  -H "Authorization: Bearer $ADMIN_TOKEN" \
  -H "Content-Type: application/json" \
  -d '[{"id":"'"$ROLE_ID"'","name":"USER"}]'

echo "Getting bgates access token"
echo "==========================="

curl -s -X POST "http://$KEYCLOAK_HOST_PORT/realms/virtu-corp/protocol/openid-connect/token" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "username=mathieud" \
  -d "password=mathieud" \
  -d "grant_type=password" \
  -d "client_secret=$SIMPLE_SERVICE_CLIENT_SECRET" \
  -d "client_id=ldap-service" | jq -r .access_token
echo

echo "Getting sjobs access token"
echo "=========================="

curl -s -X POST "http://$KEYCLOAK_HOST_PORT/realms/virtu-corp/protocol/openid-connect/token" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "username=sjobs" \
  -d "password=sjobs" \
  -d "grant_type=password" \
  -d "client_secret=$SIMPLE_SERVICE_CLIENT_SECRET" \
  -d "client_id=ldap-service" | jq -r .access_token

echo
echo "============================"
echo "SIMPLE_SERVICE_CLIENT_SECRET=$SIMPLE_SERVICE_CLIENT_SECRET"
echo "============================"
