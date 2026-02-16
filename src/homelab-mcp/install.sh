#!/bin/sh
set -e

export DEBIAN_FRONTEND=noninteractive

check_packages() {
	if ! dpkg -s "$@" >/dev/null 2>&1; then
		if [ "$(find /var/lib/apt/lists/* | wc -l)" = "0" ]; then
			echo "Running apt-get update..."
			apt-get update -y
		fi
		apt-get -y install --no-install-recommends "$@"
	fi
}

check_packages git ca-certificates

if ! command -v npm >/dev/null 2>&1; then
	check_packages nodejs npm
fi

git clone https://github.com/petebeegle/homelab-mcp /opt/homelab-mcp

cd /opt/homelab-mcp && npm install

cat > /usr/local/bin/homelab-mcp << 'EOF'
#!/bin/sh
exec npm --prefix /opt/homelab-mcp run mcp "$@"
EOF

chmod +x /usr/local/bin/homelab-mcp
