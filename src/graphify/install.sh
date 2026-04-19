#!/bin/sh
set -e

GRAPHIFY_VERSION=${VERSION:-"latest"}

check_packages() {
	if ! dpkg -s "$@" >/dev/null 2>&1; then
		if [ "$(find /var/lib/apt/lists/* | wc -l)" = "0" ]; then
			echo "Running apt-get update..."
			apt-get update -y
		fi
		apt-get -y install --no-install-recommends "$@"
	fi
}

# Ensure Python and pip are installed
if ! command -v python3 &> /dev/null; then
    echo "Installing Python..."
    check_packages python3 python3-pip
fi

# Install graphify
echo "Installing graphify..."
if [ "$GRAPHIFY_VERSION" = "latest" ]; then
    pip install graphifyy
else
    pip install "graphifyy==$GRAPHIFY_VERSION"
fi

# Run graphify install
echo "Running graphify install..."
graphify install

echo "graphify installation complete!"
