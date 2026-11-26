# Trusted keys (Xender-X)

## Buildroot 2025.02 LTS release signing key
- Pinned primary fingerprint: 18C7 DF28 19C1 733D 822D  599E A500 D6EE 9CB0 E540
- Key file in repo: keys/buildroot-2025.02-lts.asc (public key only)
- uid: Arnout Vandecappelle <arnout@rnout.be> (plus an essensium uid)
- Created 2019-04-26, expires 2032-04-26

## Verification status: PARTIALLY VERIFIED
Decision (Option A): proceed with this key as partially verified.

Evidence for:
- Key found on keyserver.ubuntu.com (primary key, uid as above).
- Buildroot mailing-list announcements: 2025.02.7 and 2025.02.11 were announced by
  Arnout Vandecappelle (arnout at rnout.be), so the identity is plausible.
- Continuity: this key signed 2025.02.5, 2025.02.17 and 2026.08.2.

Evidence missing / neutral:
- NO second independent channel confirmed the FINGERPRINT itself.
- keys.openpgp.org: no data. WKD: no match (both emails). Debian keyring: not found.
  These were neutral, not red flags.
- The fingerprint was learned from the same host (buildroot.org) as the signature.
  Pinning protects against later changes (tarball swapped, or key swapped later),
  not against an attacker who controlled buildroot.org at the time of pinning.

## Older key (NOT trusted by this repo)
- AB07 D806 D2CE 741F B886  EE50 B025 BA8B 5936 3319 signed releases from 2013 up to
  2025.11 and 2026.08 (per continuity table).
- If a future release is signed by this key (or any other key), the workflow FAILS CLOSED
  (NO_PUBKEY). Do not "fix" it by importing a key automatically. Stop, and the owner
  decides: verify that key's fingerprint from independent sources first, then add it
  as a new pinned key file and a new pinned fingerprint.

## Rules
- Never put private keys or secrets in the repo.
- Never disable signature checks to make a build pass.
- Key import in CI happens only from keys/*.asc with an exact fingerprint check.
