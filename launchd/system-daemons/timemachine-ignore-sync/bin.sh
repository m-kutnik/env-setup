#!/usr/bin/env bash

set -euo pipefail

dry_run=false

if [[ "${1:-}" == "--dry" ]]; then
  dry_run=true
  echo "[DRY RUN]"
fi

echo "--- $(date) ---"
echo ""

find_stderr_file=$(mktemp)
tmutil_stderr_file=$(mktemp)

trap 'rm -f "$find_stderr_file" "$tmutil_stderr_file"' EXIT

# Collect matches as NUL-separated to handle spaces/newlines in paths safely.
dirs=()
while IFS= read -r -d '' dir; do
  dirs+=("$dir")
done < <(
  # Prune user media/library dirs (avoid permission errors and irrelevant paths)
  find /Users \
    \( -path "*/Library" \
    -o -path "*/.Trash" \
    -o -path "*/Music" \
    -o -path "*/Pictures" \
    -o -path "*/Desktop" \
    -o -path "*/Movies" \
    -o -path "*/Documents" \
    -o -path "*/Downloads" \) -prune \
    -o -type d -name "node_modules" -prune -print0 \
    2>"$find_stderr_file"
) || find_exit=$?
find_exit=${find_exit:-0}

if [ "$find_exit" -ne 0 ] && [ "$find_exit" -ne 1 ]; then
  echo "find failed unexpectedly with exit code $find_exit"
  exit 1
fi

if [ -s "$find_stderr_file" ]; then
  echo "Warnings:"
  sed 's/^/  /' "$find_stderr_file"
  echo ""
fi

if [ "${#dirs[@]}" -eq 0 ]; then
  echo "No matching directories found."
  echo ""
  echo "--- Done ---"
  exit 0
fi

if [[ "$dry_run" == true ]]; then
  printf 'Would exclude %d directories from TimeMachine:\n' "${#dirs[@]}"
  printf '  %s\n' "${dirs[@]}"
else
  printf 'Excluding %d directories from TimeMachine:\n' "${#dirs[@]}"
  printf '  %s\n' "${dirs[@]}"

  # tmutil addexclusion accepts multiple paths in a single invocation,
  # but ARG_MAX (~1MB) can be exceeded with very many paths. Batch in chunks of 1000.
  # -p marks the paths as excluded (persists across moves)
  batch_size=1000
  tmutil_failed=false
  for ((i = 0; i < ${#dirs[@]}; i += batch_size)); do
    if ! tmutil addexclusion -p "${dirs[@]:i:batch_size}" 2>>"$tmutil_stderr_file"; then
      tmutil_failed=true
    fi
  done
  if [[ "$tmutil_failed" == true ]]; then
    echo "" >&2
    echo "ERROR: tmutil addexclusion failed. Common cause: missing Full Disk Access." >&2
    echo "Grant it to fda-launcher in:" >&2
    echo "  System Settings -> Privacy & Security -> Full Disk Access" >&2
    echo "Path: /usr/local/bin/env-setup/fda-launcher" >&2
    echo "" >&2
    echo "tmutil output:" >&2
    sed 's/^/  /' "$tmutil_stderr_file" >&2
    echo "" >&2
    exit 1
  fi
fi

echo ""
echo "--- Done ---"
