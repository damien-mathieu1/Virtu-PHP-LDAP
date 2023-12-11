#!/usr/bin/env bash

LDAP_HOST=${1:-localhost}

ldapadd -c -x -D "cn=admin,dc=virtu,dc=org" -w admin -H ldap://$LDAP_HOST -f ldap-seed/user.ldif