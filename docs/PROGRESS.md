# Xender-X Progress

## Done
- Phase 0 closed: hello workflow passed, runner facts in docs/RUNNER.md.
- Phase 1, Step 1.1 and 1.1b: PASSED (job time 8 sec).
  - buildroot-2025.02.14.tar.gz.sign is a CLEARSIGNED message (not detached).
  - Tarball sha256 = dc36c895d189d37f443d0352202ffd6a2436afcaf21570b4d9fbb177b56dee0b
  - The sha256 inside the signed text matches (internal consistency only, signature NOT verified).
  - Signature made Wed May 20 12:01:13 2026 UTC, using RSA key
    18C7DF2819C1733D822D599EA500D6EE9CB0E540 (claimed by the signature, NOT yet verified, may be a subkey).
- Web search for this fingerprint found no independent source (lead only, not verification).

## Current phase
Phase 1, Step 1.2: gather independent evidence for the signing key. Nothing pinned.

## Next step
Step 1.3: decide from Step 1.2 results + my manual checks; if 2 independent sources agree,
pin the key fingerprint and make gpg --verify a hard-fail step, then pin the tarball hash.

## Open issues
- Signing key fingerprint NOT verified yet. Do not pin anything.
- 6 hour job limit and Actions cache size limit: verify in GitHub docs.
- Need job time of each build to plan limits.
