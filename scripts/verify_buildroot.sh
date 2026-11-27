#!/usr/bin/env bash
# Hard-fail verification of a downloaded Buildroot tarball.
# Usage: verify_buildroot.sh VERSION EXPECTED_SHA256 PINNED_FPR KEYFILE DOWNLOAD_DIR
# Needs in DOWNLOAD_DIR: buildroot-VERSION.tar.gz and buildroot-VERSION.tar.gz.sign (clearsigned)
set -euo pipefail

fail() {
  echo "FAIL: $*" >&2
  exit 1
}

if [ "$#" -ne 5 ]; then
  echo "Usage: $0 VERSION EXPECTED_SHA256 PINNED_FPR KEYFILE DOWNLOAD_DIR" >&2
  exit 2
fi

VERSION="$1"
EXPECTED_SHA256="$2"
PINNED_FPR="$3"
KEYFILE="$4"
DLDIR="$5"

printf '%s' "$VERSION" | grep -Eq '^2025\.02(\.[0-9]+)?$' || fail "unexpected version format"
printf '%s' "$EXPECTED_SHA256" | grep -Eq '^[0-9a-f]{64}$' || fail "pinned sha256 must be 64 lowercase hex chars"
printf '%s' "$PINNED_FPR" | grep -Eq '^[0-9A-F]{40}$' || fail "pinned fingerprint must be 40 uppercase hex chars"
[ -f "$KEYFILE" ] || fail "key file not found: $KEYFILE"

TARBALL="$DLDIR/buildroot-${VERSION}.tar.gz"
SIGN="${TARBALL}.sign"
[ -f "$TARBALL" ] || fail "tarball not found: $TARBALL"
[ -f "$SIGN" ] || fail "signature file not found: $SIGN"

WORK="$(mktemp -d)"
chmod 700 "$WORK"
export GNUPGHOME="$WORK/gnupg"
mkdir -m 700 "$GNUPGHOME"
trap 'gpgconf --kill all >/dev/null 2>&1 || true; rm -rf "$WORK"' EXIT

echo "== 1. pinned key file: exact fingerprint or fail =="
gpg --batch --no-tty --show-keys --with-colons --with-subkey-fingerprints "$KEYFILE" > "$WORK/keyfile_colons.txt"
COUNT="$(grep -c '^pub:' "$WORK/keyfile_colons.txt" || true)"
PRIMARIES="$(awk -F: '$1=="pub"{p=1;next} $1=="fpr"&&p==1{print $10;p=0}' "$WORK/keyfile_colons.txt")"
STATE="$(awk -F: '$1=="pub"{print $2}' "$WORK/keyfile_colons.txt")"
echo "primary keys in key file: $COUNT"
echo "primary fingerprint     : $PRIMARIES"
echo "pub validity flag       : '$STATE' (e = expired, r = revoked)"
[ "$COUNT" -eq 1 ] || fail "key file must contain exactly one primary key"
[ "$PRIMARIES" = "$PINNED_FPR" ] || fail "key file fingerprint does not match pinned fingerprint"
case "$STATE" in
  e|r) fail "key is expired or revoked" ;;
esac
gpg --batch --no-tty --import "$KEYFILE"

echo "== 2. clearsigned .sign: hard fail =="
SM="$(grep -c '^-----BEGIN PGP SIGNED MESSAGE-----' "$SIGN" || true)"
SG="$(grep -c '^-----BEGIN PGP SIGNATURE-----' "$SIGN" || true)"
echo "signed-message blocks: $SM, signature blocks: $SG"
{ [ "$SM" -eq 1 ] && [ "$SG" -eq 1 ]; } || fail ".sign must contain exactly one signed block"

RC=0
gpg --batch --no-tty --status-fd 3 --verify "$SIGN" 3> "$WORK/status.txt" 2> "$WORK/verify.txt" || RC=$?
echo "--- gpg human output ---"
cat "$WORK/verify.txt"
echo "--- gpg status lines ---"
cat "$WORK/status.txt"
echo "gpg exit code: $RC"
[ "$RC" -eq 0 ] || fail "gpg --verify returned non-zero"
if grep -E '^\[GNUPG:\] (BADSIG|EXPSIG|EXPKEYSIG|REVKEYSIG|ERRSIG|NO_PUBKEY) ' "$WORK/status.txt"; then
  fail "bad, expired, revoked or unknown-key signature status found"
fi
GS="$(grep -c '^\[GNUPG:\] GOODSIG ' "$WORK/status.txt" || true)"
VS="$(grep -c '^\[GNUPG:\] VALIDSIG ' "$WORK/status.txt" || true)"
{ [ "$GS" -eq 1 ] && [ "$VS" -eq 1 ]; } || fail "expected exactly one GOODSIG and one VALIDSIG (got $GS and $VS)"
PRIM="$(awk '$1=="[GNUPG:]" && $2=="VALIDSIG"{print $NF}' "$WORK/status.txt")"
echo "primary key fingerprint of signature: $PRIM"
[ "$PRIM" = "$PINNED_FPR" ] || fail "signature is not from the pinned primary key"

echo "== 3. signed SHA256 vs tarball vs pinned SHA256 =="
awk '/^-----BEGIN PGP SIGNED MESSAGE-----/{f=1;next} /^-----BEGIN PGP SIGNATURE-----/{f=0} f' "$SIGN" > "$WORK/signed_text.txt"
echo "--- signed text (as is) ---"
cat -v "$WORK/signed_text.txt"
echo "--- end of signed text ---"
grep -i 'sha256' "$WORK/signed_text.txt" | grep -oE '\b[0-9a-fA-F]{64}\b' | tr 'A-F' 'a-f' | sort -u > "$WORK/signed_sha256.txt" || true
SCOUNT="$(wc -l < "$WORK/signed_sha256.txt")"
[ "$SCOUNT" -eq 1 ] || fail "expected exactly 1 sha256 value in signed text (got $SCOUNT)"
SIGNED_SHA="$(cat "$WORK/signed_sha256.txt")"
ACTUAL_SHA="$(sha256sum "$TARBALL" | cut -d' ' -f1)"
echo "signed text : $SIGNED_SHA"
echo "tarball     : $ACTUAL_SHA"
echo "pinned      : $EXPECTED_SHA256"
[ "$SIGNED_SHA" = "$ACTUAL_SHA" ] || fail "tarball sha256 does not match the signed value"
[ "$ACTUAL_SHA" = "$EXPECTED_SHA256" ] || fail "tarball sha256 does not match the pinned value"

echo "RESULT: VERIFIED version=${VERSION} sha256=${ACTUAL_SHA}"
