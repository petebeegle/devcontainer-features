#!/bin/sh
set -e

TALOSCTL_VERSION=${VERSION:-"latest"}

check_packages() {
	if ! dpkg -s "$@" >/dev/null 2>&1; then
		if [ "$(find /var/lib/apt/lists/* | wc -l)" = "0" ]; then
			echo "Running apt-get update..."
			apt-get update -y
		fi
		apt-get -y install --no-install-recommends "$@"
	fi
}

get_bin() {
    local os=$(uname -s)
    local arch=$(uname -m)
    local cli_arch=""

    case $os in
        CYGWIN* | MINGW64*)
            os="windows-amd64.exe"
            ;;
        Darwin | Linux | FreeBSD)
            case $arch in
                x86_64)
                    cli_arch="amd64"
                    ;;
                armv8*)
                    cli_arch="arm64"
                    ;;
                aarch64*)
                    cli_arch="arm64"
                    ;;
                amd64|arm64)
                    cli_arch=$arch
                    ;;
                *)
                    echo "There is no talosctl $os support for $arch. Please open an issue with your platform details."
                    exit 1
                    ;;
            esac
            ;;
        *)
            echo "There is no talosctl support for $os/$arch. Please open an issue with your platform details."
            exit 1
            ;;
    esac

    os=$(echo $os | tr '[:upper:]' '[:lower:]')
    echo "talosctl-$os-$cli_arch"
}


check_packages curl ca-certificates
binary=$(get_bin)

# Install talosctl
curl -LO https://github.com/talos-systems/talos/releases/${TALOSCTL_VERSION}/download/${binary}
chmod +x $binary
mv $binary /usr/local/bin/talosctl


