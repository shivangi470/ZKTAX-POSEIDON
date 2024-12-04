#!/bin/bash
# Setup script for ZKTAX project

# Install dependencies
echo "Installing dependencies..."
npm install

# Confirm circom version
circom --version
echo "Setup complete! You can now compile circuits."
