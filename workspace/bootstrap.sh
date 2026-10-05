#!/usr/bin/env bash
# Clone the working set into a directory, shallow by default.
#
#   workspace/bootstrap.sh                 # into ~/work
#   workspace/bootstrap.sh --into /srv/wh  # somewhere else
#   workspace/bootstrap.sh --cluster lightning
#   workspace/bootstrap.sh --full          # full history instead of --depth 1
#   workspace/bootstrap.sh --dry-run
#
# This replaces cloning the fletchervaughn-workspace home-directory repo.
# The whole working set is a few hundred megabytes; the workspace repo is
# over 100 GB and carries dotfiles, caches, backups and credentials.
set -uo pipefail

ROOT="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")" && pwd)"
MANIFEST="$ROOT/repos.tsv"

INTO="$HOME/work"
CLUSTER=""
DEPTH="--depth 1"
DRY=0

while [ $# -gt 0 ]; do
  case "$1" in
    --into)    INTO="${2:?--into needs a directory}"; shift 2 ;;
    --cluster) CLUSTER="${2:?--cluster needs a name}"; shift 2 ;;
    --full)    DEPTH=""; shift ;;
    --dry-run) DRY=1; shift ;;
    -h|--help) sed -n '2,14p' "$0"; exit 0 ;;
    *) echo "unknown argument: $1" >&2; exit 2 ;;
  esac
done

[ -f "$MANIFEST" ] || { echo "manifest not found: $MANIFEST" >&2; exit 1; }

echo "bootstrap into $INTO${CLUSTER:+ (cluster: $CLUSTER)}"
[ "$DRY" = 1 ] || mkdir -p "$INTO"

failed=0
cloned=0
skipped=0

while IFS=$'\t' read -r name owner branch cluster _notes; do
  case "$name" in ''|'#'*) continue ;; esac
  if [ -n "$CLUSTER" ] && [ "$cluster" != "$CLUSTER" ]; then continue; fi

  url="https://github.com/$owner/$name"
  dest="$INTO/$name"

  if [ -d "$dest/.git" ]; then
    echo "  skip   $name (already cloned)"
    skipped=$((skipped+1))
    continue
  fi

  if [ "$DRY" = 1 ]; then
    echo "  would  git clone $DEPTH --branch $branch $url $dest"
    continue
  fi

  echo "  clone  $name ($branch)"
  # shellcheck disable=SC2086
  if git clone --quiet $DEPTH --branch "$branch" "$url" "$dest"; then
    cloned=$((cloned+1))
  else
    echo "  FAIL   $name" >&2
    failed=$((failed+1))
  fi
done < "$MANIFEST"

echo
echo "cloned=$cloned skipped=$skipped failed=$failed"
[ "$failed" = 0 ]
