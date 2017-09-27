#!/bin/bash

mkdir -p /root/.puppetlabs/

echo "Create a deployment role"
/opt/puppetlabs/puppet/bin/curl -k -X POST -H 'Content-Type: application/json' \
	https://`facter fqdn`:4433/rbac-api/v1/roles \
	-d '{"permissions": [{"object_type": "environment", "action": "deploy_code", "instance": "*"},
{"object_type": "tokens", "action": "override_lifetime", "instance": "*"}],"user_ids": [], "group_ids": [], "display_name": "Deploy Environments", "description": "Ability to deploy environment"}' \
	--cert /`puppet config print ssldir`/certs/`facter fqdn`.pem \
	--key /`puppet config print ssldir`/private_keys/`facter fqdn`.pem \
	--cacert /`puppet config print ssldir`/certs/ca.pem

echo "Create a deployment user"
/opt/puppetlabs/puppet/bin/curl -k -X POST -H 'Content-Type: application/json' \
	https://`facter fqdn`:4433/rbac-api/v1/users \
	-d '{"login": "deploy", "password": "puppetlabs", "email": "", "display_name": "", "role_ids": [4]}' \
	--cert /`puppet config print ssldir`/certs/`facter fqdn`.pem \
	--key /`puppet config print ssldir`/private_keys/`facter fqdn`.pem \
	--cacert /`puppet config print ssldir`/certs/ca.pem

echo "Create a token"
/opt/puppetlabs/puppet/bin/curl -k -X POST -H 'Content-Type: application/json' \
	-d '{"login": "deploy", "password": "puppetlabs", "lifetime": "0"}' \
	https://`facter fqdn`:4433/rbac-api/v1/auth/token \
	| /opt/puppetlabs/puppet/bin/ruby -e 'require "json"; puts JSON.load(STDIN.read)["token"]' \
	> /root/.puppetlabs/token