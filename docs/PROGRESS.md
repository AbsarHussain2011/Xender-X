# Xender-X Progress

## Done
- Phase 0 closed: hello workflow passed, runner facts in docs/RUNNER.md.
- Phase 1, Step 1.1: PASSED. Findings:
  - buildroot-2025.02.14.tar.gz.sign is a CLEARSIGNED message (not detached).
  - Tarball sha256 = dc36c895d189d37f443d0352202ffd6a2436afcaf21570b4d9fbb177b56dee0b
  - The sha256 inside the signed text matches (internal consistency only, signature NOT verified).

## Current phase
Phase 1, Step 1.1b: fix workflow for clearsigned format, show signing key ID.

## Next step
Step 1.2: verify the signing key fingerprint from independent sources, then pin key + hash.

## Open issues
- Signing key fingerprint NOT verified yet. Do not pin the tarball hash before Step 1.2.
- 6 hour job limit and Actions cache size limit: verify in GitHub docs.
- Need job time of each build to plan limits (Step 1.1 job time not recorded).
