# Xender-X Progress

## Done
- Phase 0, Step 0.1: repo skeleton and hello-world workflow. PASSED (job time 5 sec).
- Phase 0, Step 0.2: runner facts saved in docs/RUNNER.md (disk numbers included).

## Current phase
Phase 0 closed. Phase 1 plan is ready, waiting for "next".

## Runner facts (short)
- 4 cores (AMD EPYC 9V45, svm on), 15Gi RAM, 3Gi swap
- Disk: 88G free on / (145G total, 58G used), /mnt is the same disk
- /dev/kvm exists, usable only after the udev rule (works, repeat it in every job)

## Next step
Phase 1, Step 1.1: base build workflow (Buildroot 2025.02.14, verified download).

## Open issues
- Buildroot 2025.02.14 tarball SHA-256 must be verified via PGP before pinning (Phase 1).
- 6 hour job limit and Actions cache size limit: verify in GitHub docs.
- qemu-system-x86_64 preinstalled or not: CI will show it.
- Need job time of each build to plan limits.
