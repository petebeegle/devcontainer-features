#!/bin/bash

# This test file will be executed against the graphify devcontainer feature.

set -e

# Optional: Import test library bundled with the devcontainer CLI
source dev-container-features-test-lib

# Feature-specific tests
# The 'check' command comes from the dev-container-features-test-lib.

check "graphify executable exists" command -v graphify

check "graphify version command works" graphify --version

check "graphify help command works" graphify --help

# Report results
# If any of the checks above exited with a non-zero exit code, the test will fail.
reportResults
