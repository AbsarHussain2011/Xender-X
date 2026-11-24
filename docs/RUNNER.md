# GitHub Runner Facts (ubuntu-latest, public repo)

Source: phase0-hello workflow run, Step 0.1 (2026-11-24). Re-check before big builds,
because GitHub can change runner specs. Verify limits in GitHub's docs, do not assume.

## Confirmed from the log
- CPU: AMD EPYC 9V45, 4 cores (nproc = 4), AMD-V (svm) enabled
- RAM: 15Gi total, 14Gi free, swap 3.0Gi
- Disk: / is 145G total, 58G used, 88G free
- /mnt is NOT a separate disk (same /dev/root), so total free space is 88G, not more
- Job time of the hello workflow: 5 sec
- /dev/kvm: present
  - Before udev rule: NOT usable (crw-rw---- root kvm)
  - After udev rule: usable (crw-rw-rw-)

## KVM rule used (must be repeated in every job that needs KVM)
    echo 'KERNEL=="kvm", GROUP="kvm", MODE="0666", OPTIONS+="static_node=kvm"' | sudo tee /etc/udev/rules.d/99-kvm4all.rules
    sudo udevadm control --reload-rules
    sudo udevadm trigger --name-match=kvm

The runner is a fresh VM each run, so this step is needed in every job.

## PENDING (not yet confirmed, do not rely on these)
- Whether qemu-system-x86_64 is preinstalled (CI will install it if missing)
- Whether KVM stays usable on every run (re-check each time, runners may vary)
- 6 hour job limit: from project notes, verify in GitHub docs
- GitHub Actions cache size limit per repo: verify in GitHub docs

## Planning notes
- Budget about 88G of disk for Buildroot output, downloads and cache staging.
- Disk may become the limit in Phase 5 (browser) and Phase 6 (tools). Estimate before building.
