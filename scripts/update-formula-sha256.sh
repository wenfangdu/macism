#!/bin/bash

# Get the most recent tag
TAG=$(git describe --tags --abbrev=0)

# Remove 'v' prefix if present
VERSION=$(echo "$TAG" | sed 's/^v//')

# Function to download asset and calculate SHA256
download_and_hash() {
    local asset_name=$1
    local url="https://github.com/laishulu/macism/releases/download/v${VERSION}/${asset_name}"
    local tmp_file="/tmp/${asset_name}"

    # Download the asset
    curl -L -o "$tmp_file" "$url"

    # Check if download was successful
    if [[ ! -f "$tmp_file" ]]; then
        echo "Error: Failed to download $asset_name"
        exit 1
    fi

    # Calculate SHA256
    if [[ "$OSTYPE" == "darwin"* ]]; then
        sha256=$(shasum -a 256 "$tmp_file" | awk '{print $1}')
    else
        sha256=$(sha256sum "$tmp_file" | awk '{print $1}')
    fi

    # Clean up
    rm "$tmp_file"

    echo "$sha256"
}

# Calculate SHA256 for macism assets
macism_arm64_sha256=$(download_and_hash "macism-arm64")
macism_x86_64_sha256=$(download_and_hash "macism-x86_64")

# Calculate SHA256 for TemporaryWindow assets
tempwindow_arm64_sha256=$(download_and_hash "TemporaryWindow-arm64.zip")
tempwindow_x86_64_sha256=$(download_and_hash "TemporaryWindow-x86_64.zip")

# Update the macism Homebrew formula with actual SHA256 hashes and version
sed -i.bak \
    -e "s/version \".*\"/version \"$VERSION\"/" \
    -e "/url.*macism-arm64/{ n; s/sha256 \".*\"/sha256 \"$macism_arm64_sha256\"/; }" \
    -e "/url.*macism-x86_64/{ n; s/sha256 \".*\"/sha256 \"$macism_x86_64_sha256\"/; }" \
    homebrew/macism.rb

# Remove the backup file created by sed for macism
rm homebrew/macism.rb.bak

# Update the TemporaryWindow Homebrew formula with actual SHA256 hashes and version
sed -i.bak \
    -e "s/version \".*\"/version \"$VERSION\"/" \
    -e "/url.*TemporaryWindow-arm64.zip/{ n; s/sha256 \".*\"/sha256 \"$tempwindow_arm64_sha256\"/; }" \
    -e "/url.*TemporaryWindow-x86_64.zip/{ n; s/sha256 \".*\"/sha256 \"$tempwindow_x86_64_sha256\"/; }" \
    homebrew/temporary-window.rb

# Remove the backup file created by sed for TemporaryWindow
rm homebrew/temporary-window.rb.bak

echo "Updated Homebrew formulas with actual SHA256 hashes for macism and TemporaryWindow"
echo "Please review the changes, commit, and push them to GitHub"
