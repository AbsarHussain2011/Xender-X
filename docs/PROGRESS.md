# Xender-X Progress

## Done
- Phase 0 closed: hello workflow passed, runner facts in docs/RUNNER.md.
- Phase 1, Step 1.1 files prepared (fetch Buildroot 2025.02.14 + signature facts). Result pending.

## Current phase
Phase 1, Step 1.1: download and inspect Buildroot tarball + PGP signature (no build yet).

## Facts confirmed
- Buildroot 2025.02.14 is the latest 2025.02.x LTS (released 2026-05-20, EOL March 2028).
- Files: buildroot-2025.02.14.tar.gz and .tar.gz.sign at https://buildroot.org/downloads/
- phase0-hello is now manual-only (workflow_dispatch).

## Next step
Step 1.2: independently verify the signing key fingerprint, then pin it and the tarball SHA-256.

## Open issues
- Signing key fingerprint NOT verified yet. Do not pin anything before Step 1.2.
- 6 hour job limit and Actions cache size limit: verify in GitHub docs.
- Need job time of each build to plan limits.
