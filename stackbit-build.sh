#!/usr/bin/env bash

set -e
set -o pipefail
set -v

curl -s -X POST https://api.stackbit.com/project/5e28844f5356d3001abd568d/webhook/build/pull > /dev/null
if [[ -z "${STACKBIT_API_KEY}" ]]; then
    echo "WARNING: No STACKBIT_API_KEY environment variable set, skipping stackbit-pull"
else
    npx @stackbit/stackbit-pull --stackbit-pull-api-url=https://api.stackbit.com/pull/5e28844f5356d3001abd568d 
fi
curl -s -X POST https://api.stackbit.com/project/5e28844f5356d3001abd568d/webhook/build/ssgbuild > /dev/null
npm run build
./inject-netlify-identity-widget.js dist
curl -s -X POST https://api.stackbit.com/project/5e28844f5356d3001abd568d/webhook/build/publish > /dev/null
