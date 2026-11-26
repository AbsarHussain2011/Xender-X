# Xender-X Progress

## Done
- Phase 0 closed: hello workflow passed, runner facts in docs/RUNNER.md.
- Phase 1, Step 1.1 / 1.1b: .sign is CLEARSIGNED, internal sha256 match confirmed.
- Phase 1, Step 1.2 (28 sec): key evidence collected, see docs/KEYS.md.
  - Claimed key 18C7DF2819C1733D822D599EA500D6EE9CB0E540 = primary key,
    uid Arnout Vandecappelle, created 2019-04-26, expires 2032-04-26.
  - Verification level: PARTIALLY VERIFIED (decision: Option A).
  - 2025.02.17 exists (23 Aug 2026), so 2025.02.14 is NOT the newest 2025.02.x.
- Phase 1, Step 1.3 files prepared (verify workflow + docs/KEYS.md). Result pending.

## Current phase
Phase 1, Step 1.3: pin key file and verify source with hard-fail checks. No build yet.

## Next step
- 1.3b: take key artifact from run 1, commit keys/buildroot-2025.02-lts.asc, run 2 must verify.
- 1.4: choose the Buildroot version to build (newest 2025.02.x recommended), pin version + hash.

## Open issues
- Key is partially verified only (see docs/KEYS.md). Future release signed by another key
  makes the workflow fail closed; owner must decide.
- Old diagnostic workflows (phase1-fetch-buildroot, phase1-verify-key) still exist; delete later.
- 6 hour job limit and Actions cache size limit: verify in GitHub docs.
- Need job time of each build to plan limits.
