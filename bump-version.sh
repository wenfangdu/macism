#!/bin/bash

# Get the most recent tag
TAG=$1

# Remove 'v' prefix if present
VERSION=$(echo "$TAG" | sed 's/^v//')

# Update the Homebrew formula
sed -i.bak \
    -e "s/version \".*\"/version \"$VERSION\"/" \
    -e "/url.*macism-arm64/{ n; s/sha256 \"[-_ a-zA-Z0-9]*\"/sha256 \"PLACE_HOLDER\"/; }" \
    -e "/url.*macism-x86_64/{ n; s/sha256 \"[-_ a-zA-Z0-9]*\"/sha256 \"PLACE_HOLDER\"/; }" \
    macism.rb

# Remove the backup files created by sed
rm macism.rb.bak

# Stage the changed files
git add macism.rb

# Commit the changes
git commit -m "Bump version to $VERSION"

# Amend the tag to include this new commit
git tag -f "$TAG"

echo "Updated Homebrew formula to version $VERSION"
