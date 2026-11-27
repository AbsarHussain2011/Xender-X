# Xender-X Progress

## Done
- Phase 0 closed: hello workflow passed, runner facts in docs/RUNNER.md.
- Phase 1, Step 1.1 / 1.1b: .sign is CLEARSIGNED, internal sha256 match confirmed.
- Phase 1, Step 1.2: key evidence collected (docs/KEYS.md). Level: PARTIALLY VERIFIED (Option A).
- Phase 1, Step 1.3 / 1.3b: PASSED (12 sec). Key committed as keys/buildroot-2025.02-lts.asc,
  verify run passed with exact fingerprint match.
- Phase 1, Step 1.4 files prepared (first base build). Result pending.

## Pinned source (verified in CI run 2)
- Buildroot 2025.02.20, SHA-256 44904ee44ac6750e06135454ed5cbcb8ea9354e6d5b7e2b2668581bd8b6ba1b6
- Signer primary fingerprint 18C7DF2819C1733D822D599EA500D6EE9CB0E540 (partially verified key)

## Current phase
Phase 1, Step 1.4: first base build (x86_64, glibc, BusyBox init, cpio.gz, default Buildroot
kernel + "-xenderx" fragment). No QEMU boot test yet.

## Next step
Step 1.5: KVM QEMU boot test in CI (udev rule from docs/RUNNER.md), serial log artifact.

## Open issues
- Root password is EMPTY (temporary, Step 1.4 decision). Anyone with console access gets root.
  Fix in Phase 3. Do not run this image on a real network before that.
- Key is only partially verified (docs/KEYS.md). A release signed by another key fails closed.
- Kconfig symbols in xenderx_defconfig were written from memory; check_defconfig.sh checks them in CI.
- Kernel version = Buildroot default for 2025.02.20; record it from the CI log.
- Old diagnostic workflows (phase1-fetch-buildroot, phase1-verify-key) still exist; delete in a later step.
- 6 hour job limit and Actions cache size limit: verify in GitHub docs.
- Need job time of each build to plan limits (cold build estimate 40-60 min).
