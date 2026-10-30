#!/bin/sh
# Frozen from release 0.4.3. Modern features belong in Sources/CZPickerUI.
set -eu
cd "$(dirname "$0")/.."
shasum -a 256 -c docs/legacy-source.sha256
