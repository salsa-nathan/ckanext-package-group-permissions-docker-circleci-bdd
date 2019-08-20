#!/usr/bin/env sh
##
# Initialise CKAN instance.
#
set -e

dockerize -wait tcp://postgres:5432 -timeout 1m
dockerize -wait tcp://solr:8983 -timeout 1m

CKAN_USER_NAME="${CKAN_USER_NAME:-admin}"
CKAN_USER_PASSWORD="${CKAN_USER_PASSWORD:-password}"
CKAN_USER_EMAIL="${CKAN_USER_EMAIL:-admin@localhost}"

. /app/ckan/default/bin/activate \
  && cd /app/ckan/default/src/ckan \
  && paster db init -c /app/ckan/default/production.ini \
  && paster --plugin=ckan user add "${CKAN_USER_NAME}" email="${CKAN_USER_EMAIL}" password="${CKAN_USER_PASSWORD}" -c /app/ckan/default/production.ini \
  && paster --plugin=ckan sysadmin add "${CKAN_USER_NAME}" -c /app/ckan/default/production.ini \
  && paster --plugin=ckan user add "org_editor" email="org_editor@localhost" password="${CKAN_USER_PASSWORD}" -c /app/ckan/default/production.ini \
  && paster --plugin=ckan user add "org_admin" email="org_admin@localhost" password="${CKAN_USER_PASSWORD}" -c /app/ckan/default/production.ini \
  && paster --plugin=ckan user add "org_member" email="org_member@localhost" password="${CKAN_USER_PASSWORD}" -c /app/ckan/default/production.ini \
  && paster --plugin=ckan user add "test_user" email="test_user@localhost" password="${CKAN_USER_PASSWORD}" -c /app/ckan/default/production.ini

# Create some base test data
. /app/scripts/create-test-data.sh
