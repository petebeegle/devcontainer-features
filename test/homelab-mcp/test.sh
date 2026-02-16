#!/bin/bash

set -e

source dev-container-features-test-lib

check "homelab-mcp wrapper exists" which homelab-mcp
check "npm deps installed" test -d /opt/homelab-mcp/node_modules
check "tsx available" test -f /opt/homelab-mcp/node_modules/.bin/tsx

reportResults
