#!/bin/bash

cd bixat_key_mouse_rust
# Run cargo build in release mode
cargo build --release

# Create the native directory if it doesn't exist
mkdir -p ../native

# Copy all files with the name libbixat_key_mouse_rust to the native directory
find target/release -name 'libbixat_key_mouse_rust*' -exec cp {} ../../native/ \;

echo "Build and copy completed."