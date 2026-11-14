#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

: "${DEB_VERSION:?DEB_VERSION must be set (run .ci/set-version.sh first)}"

ARTIFACT_DIR="${ARTIFACT_DIR:-$ROOT_DIR/artifacts}"
BUILD_ROOT="$(mktemp -d)"

cleanup() {
  rm -rf "$BUILD_ROOT"
}
trap cleanup EXIT

mkdir -p "$ARTIFACT_DIR"
cp -a "$ROOT_DIR/." "$BUILD_ROOT/cosmic-panel"

cd "$BUILD_ROOT/cosmic-panel"

export DEBFULLNAME="${DEBFULLNAME:-Cosmic Panel CI}"
export DEBEMAIL="${DEBEMAIL:-ci@cosmic-panel.local}"

dch --newversion "$DEB_VERSION" \
  --distribution noble \
  "Automated CI build from ${SOURCE_SHA:-${GITHUB_SHA:-local}}" < /dev/null

dpkg-buildpackage -us -uc -b

shopt -s nullglob
for deb in "$BUILD_ROOT"/*.deb; do
  cp -v "$deb" "$ARTIFACT_DIR/"
done

ls -la "$ARTIFACT_DIR"
