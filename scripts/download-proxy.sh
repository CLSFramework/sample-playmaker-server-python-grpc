#!/bin/sh

# check proxy directory exists, if exists, remove it
if [ -d proxy ]; then
    echo "proxy directory exists, remove it"
    rm -rf proxy
fi

mkdir proxy

cd proxy

# Check if curl exists
if command -v curl >/dev/null 2>&1; then
    echo "curl is installed."
else
    echo "curl is not installed. Please install it."
    exit 1
fi

# Check if get exists
if command -v wget >/dev/null 2>&1; then
    echo "wget is installed."
else
    echo "wget is not installed. Please install it."
    exit 1
fi

# download soccer simulation proxy
wget $(curl -s "https://api.github.com/repos/clsframework/soccer-simulation-proxy/releases/latest" | grep -oP '"browser_download_url": "\K[^"]*' | grep "soccer-simulation-proxy.tar.gz")

tar -xvf soccer-simulation-proxy.tar.gz

mv soccer-simulation-proxy/* .

rm -rf soccer-simulation-proxy

rm soccer-simulation-proxy.tar.gz
