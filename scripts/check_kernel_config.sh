#!/usr/bin/env bash
# Check that every option from fragment file(s) landed in a final config.
# Usage: check_kernel_config.sh FINAL_CONFIG FRAGMENT [FRAGMENT...]
# Env:   PREFIX = symbol prefix (default CONFIG; use BR2 for Buildroot defconfigs)
set -euo pipefail

PREFIX="${PREFIX:-CONFIG}"

if [ "$#" -lt 2 ]; then
  echo "Usage: $0 FINAL_CONFIG FRAGMENT [FRAGMENT...]" >&2
  exit 2
fi

FINAL="$1"
shift
if [ ! -f "$FINAL" ]; then
  echo "FAIL: final config not found: $FINAL" >&2
  exit 2
fi

re_set="^(${PREFIX}_[A-Za-z0-9_]+)="
re_unset="^#[[:space:]](${PREFIX}_[A-Za-z0-9_]+)[[:space:]]is[[:space:]]not[[:space:]]set$"

checked=0
bad=0

for FRAG in "$@"; do
  if [ ! -f "$FRAG" ]; then
    echo "FAIL: fragment not found: $FRAG" >&2
    exit 2
  fi
  echo "checking fragment: $FRAG"
  while IFS= read -r line || [ -n "$line" ]; do
    line="${line%$'\r'}"
    if [[ "$line" =~ $re_set ]]; then
      sym="${BASH_REMATCH[1]}"
      checked=$((checked + 1))
      if ! grep -qxF -- "$line" "$FINAL"; then
        bad=$((bad + 1))
        echo "MISSING/DIFFERENT"
        echo "  wanted: $line"
        echo "  actual: $(grep -E "^(# )?${sym}[= ]" "$FINAL" || echo '(symbol not present in final config)')"
      fi
    elif [[ "$line" =~ $re_unset ]]; then
      sym="${BASH_REMATCH[1]}"
      checked=$((checked + 1))
      if grep -q "^${sym}=" "$FINAL"; then
        bad=$((bad + 1))
        echo "MISSING/DIFFERENT"
        echo "  wanted: $line"
        echo "  actual: $(grep "^${sym}=" "$FINAL")"
      fi
    fi
  done < "$FRAG"
done

echo "checked $checked option(s), $bad problem(s)"
if [ "$checked" -eq 0 ]; then
  echo "FAIL: no options were checked (empty or wrong fragment?)" >&2
  exit 1
fi
if [ "$bad" -ne 0 ]; then
  exit 1
fi
echo "RESULT: all options landed"
