#!/bin/sh
set -e

FLUX_VERSION=${VERSION:-"latest"}

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
                    echo "There is no flux $os support for $arch. Please open an issue with your platform details."
                    exit 1
                    ;;
            esac
            ;;
        *)
            echo "There is no flux support for $os/$arch. Please open an issue with your platform details."
            exit 1
            ;;
    esac

    os=$(echo $os | tr '[:upper:]' '[:lower:]')
    echo "flux-$os-$cli_arch"
}


check_packages curl ca-certificates
binary=$(get_bin)
# Install flux
if [ "${FLUX_VERSION}" = "latest" ] ; then
    curl -s https://fluxcd.io/install.sh | bash
else
    curl -s https://fluxcd.io/install.sh | FLUX_VERSION=$FLUX_VERSION bash
fi
