#!/usr/bin/env sh
##
# Create some example content for extension BDD tests.
#
set -e

export CKAN_ACTION_URL=http://ckan:3000/api/action
export CKAN_INI_FILE=/app/ckan/default/production.ini

. /app/ckan/default/bin/activate \
    && cd /app/ckan/default/src/ckan

# We know the "admin" sysadmin account exists, so we'll use her API KEY to create further data
export API_KEY=$(paster --plugin=ckan user admin -c ${CKAN_INI_FILE} | tr -d '\n' | sed -r 's/^(.*)apikey=(\S*)(.*)/\2/')

##
# BEGIN: Create a test organisation with test users for admin, editor and member
#
TEST_ORG_NAME=test-organisation-2
TEST_ORG_TITLE="Test Organisation 2"

echo "Creating ${TEST_ORG_TITLE} Organisation:"

TEST_ORG=$( \
    wget -O- --header="Authorization: ${API_KEY}" \
    --post-data "name=${TEST_ORG_NAME}&title=${TEST_ORG_TITLE}" \
    ${CKAN_ACTION_URL}/organization_create
)

TEST_ORG_ID=$(echo $TEST_ORG | sed -r 's/^(.*)"id": "(.*)",(.*)/\2/')

echo "Assigning test users to ${TEST_ORG_TITLE} Organisation:"

wget -O- --header="Authorization: ${API_KEY}" \
    --post-data "id=${TEST_ORG_ID}&object=org_admin&object_type=user&capacity=admin" \
    ${CKAN_ACTION_URL}/member_create

wget -O- --header="Authorization: ${API_KEY}" \
    --post-data "id=${TEST_ORG_ID}&object=org_editor&object_type=user&capacity=editor" \
    ${CKAN_ACTION_URL}/member_create

wget -O- --header="Authorization: ${API_KEY}" \
    --post-data "id=${TEST_ORG_ID}&object=org_member&object_type=user&capacity=member" \
    ${CKAN_ACTION_URL}/member_create

echo "Creating test dataset..."

TEST_PKG_NAME=test-dataset
TEST_PKG_TITLE="Test Dataset"

TEST_PKG=$( \
    wget -O- --header="Authorization: ${API_KEY}" \
    --post-data "name=${TEST_PKG_NAME}&title=${TEST_PKG_TITLE}&owner_org=${TEST_ORG_ID}" \
    ${CKAN_ACTION_URL}/package_create
)

echo "Creating test resource for dataset..."

TEST_RES=$( \
    wget -O- --header="Authorization: ${API_KEY}" \
    --post-data "package_id=${TEST_PKG_NAME}&name=test-resource&url=http://example.com/test.csv" \
    ${CKAN_ACTION_URL}/resource_create
)

echo "Creating test groups..."

TEST_GROUP_1=$( \
    wget -O- --header="Authorization: ${API_KEY}" \
    --post-data "name=group-1&title=Test Group 1" \
    ${CKAN_ACTION_URL}/group_create
)

TEST_GROUP_2=$( \
    wget -O- --header="Authorization: ${API_KEY}" \
    --post-data "name=group-2&title=Test Group 2" \
    ${CKAN_ACTION_URL}/group_create
)
