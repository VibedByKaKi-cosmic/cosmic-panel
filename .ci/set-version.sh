#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

# The workspace members share one version, so read it from the binary crate.
UPSTREAM_VERSION="$(sed -n 's/^version = "\(.*\)"$/\1/p' cosmic-panel-bin/Cargo.toml | head -n 1)"
: "${UPSTREAM_VERSION:?unable to read version from cosmic-panel-bin/Cargo.toml}"

SOURCE_SHA="$(git rev-parse HEAD)"
SHORT_SHA="${SOURCE_SHA:0:7}"

# The source format is 3.0 (native), which rejects a Debian revision such as "-1".
DEB_VERSION="${UPSTREAM_VERSION}+git${SHORT_SHA}"
TAG="v${UPSTREAM_VERSION}+git.${SHORT_SHA}"
TITLE="Cosmic Panel ${UPSTREAM_VERSION} (${SHORT_SHA})"

export UPSTREAM_VERSION DEB_VERSION SHORT_SHA SOURCE_SHA TAG TITLE

echo "Package version set to ${DEB_VERSION}"

if [[ -n "${GITHUB_ENV:-}" ]]; then
  {
    echo "UPSTREAM_VERSION=${UPSTREAM_VERSION}"
    echo "DEB_VERSION=${DEB_VERSION}"
    echo "SHORT_SHA=${SHORT_SHA}"
    echo "SOURCE_SHA=${SOURCE_SHA}"
    echo "TAG=${TAG}"
    echo "TITLE=${TITLE}"
  } >> "$GITHUB_ENV"
fi
