# Changelog

All notable user-visible changes to Intelli-Repo are documented here. Versions follow Semantic Versioning with a beta-first progression.

## Unreleased

No unreleased user-visible changes are currently recorded.

## v0.1.0-beta.1 — 2026-08-20

First public beta of the exact-pinned Intelli-Repo agent substrate and repository-local lifecycle tooling.

### Added

- Authoritative sources for the stable bootstrap, lifecycle command facade, public documentation, licensing, security posture, and sanitized provenance.
- POSIX-shell and capability-based runtime preflight without host-permutation certification.
- Read-only structured doctor results, optional approved agent configuration, exact-version lifecycle updates, lifecycle-protocol compatibility checks, and named-receipt rollback with intervening-state refusal.
- Exact-version installation, ownership-checked conservative uninstall, separately confirmed bounded purge, failure recovery, and clean reinstall.
- Executable POSIX-capability, adversarial-input, redaction, lifecycle, reproducibility, and release-refusal conformance gates with exact revision evidence.

### Security

- Apache-2.0 "AS IS" distribution with no guaranteed support, response time, security maintenance, fixes, or confidential vulnerability-reporting channel.
- Inspectable immutable tagged scripts, exact component provenance, and checksums for user-directed risk evaluation.

### Migrations

- No migration is required because this is the first public release. Later compatible updates record their migration disposition before mutation.

### Rollback and removal

- A successful compatible update can be reversed with `intelli-repo update --rollback OPERATION_ID` while its receipt remains valid and owned state has not changed.
- Ordinary uninstall removes only exact Intelli-Repo-owned integration and preserves user configuration, knowledge, workspace content, unrelated files, unrelated submodules, and Git history.

### Known limitations

- This beta defines a pre-1.0 compatibility contract that may change in a later release.
- Host compatibility is determined by the declared POSIX shell-and-capability contract; the project does not certify operating-system, distribution, WSL, architecture, container, or CI permutations.
- GNU Make integration is optional. Direct repository-local command execution remains the canonical interface.
- Agent-provided `lint`, `audit`, `ingest`, `task`, and `release` capabilities fail closed until their respective implementations are present.
