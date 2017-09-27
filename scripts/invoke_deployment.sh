#!/bin/bash

echo "Invoking a deployment... "
curl -v -k -X POST -H 'Content-Type: application/json' \
	https://`facter fqdn`:8170/code-manager/v1/deploys?token=`cat /root/.puppetlabs/token` \
	-d '{"environments": ["production"], "wait": true}' | cat