# Intelli-Repo

Intelli-Repo adds an exact-pinned agent substrate, governed knowledge workflow, and inspectable lifecycle commands to an ordinary Git repository.

> **Beta status:** `v0.1.0-beta.1` is the current public beta. Its pre-1.0 compatibility contract may change in later releases.

## Install

Stable convenience entrypoint:

```sh
curl -fsSL https://raw.githubusercontent.com/patrick-gitit/intelli-repo/main/install.sh | sh
```

Explicit immutable beta:

```sh
curl -fsSL https://raw.githubusercontent.com/patrick-gitit/intelli-repo/v0.1.0-beta.1/install.sh | sh
```

The moving `main` script selects an immutable version before installing versioned content. Git commits, exact submodule gitlinks, and immutable annotated tags are version authority.

A plain bootstrap invocation is the default latest request: no version number is required. The `main/install.sh` facade contains one literal mapping to the current approved release and downloads executable content only from that immutable tag. It never discovers “latest” at runtime, follows a component branch, or queries a hosting-provider API. The mapping advances only through an approved release publication. Use `--version VERSION` only when an explicit immutable override is required; the selected tag's provenance and checksums are verified before execution.

## Runtime contract

Intelli-Repo defines compatibility through a POSIX shell-and-capability contract, not through certification of operating systems, Linux distributions, WSL versions, architectures, containers, or other host permutations. The repository owner is responsible for establishing that a chosen environment satisfies this contract.

Required capabilities are:

- POSIX `sh`;
- Git 2.34 or newer;
- curl 7.81 or newer;
- `sha256sum` or `shasum -a 256`;
- the POSIX utilities exercised by the lifecycle scripts;
- a functioning CA trust store and HTTPS access to GitHub-hosted public artifacts and repositories;
- filesystem behavior sufficient for canonical paths, symlinks, permissions, executable modes, temporary directories, Git worktrees, and submodules.

GNU Make is optional. Managed Make targets are provided as a convenience when compatible Make is available; installation and direct `.intelli-repo/bin/intelli-repo` invocation do not require it. Preflight checks detectable required capabilities and fails before mutation when they are absent or incompatible. Passing preflight is not certification or a warranty for the user's host environment.

## Command placement

Intelli-Repo keeps all distribution-owned command and orchestration code, executable and non-executable, under `.intelli-repo/bin/`. The canonical command is `.intelli-repo/bin/intelli-repo`; no separate utility `lib`, `libexec`, global executable directory, or global symlink is part of the installation. Exact-pinned agent repositories remain separate substrate components under their declared `.intelli-repo/*-agent/` paths.

Managed `intelli-repo-*` Make targets invoke the repository-local command directly. From the repository root, direct invocation is also available:

```sh
./.intelli-repo/bin/intelli-repo doctor
```

Installation never modifies `PATH` or shell startup files. A user may optionally prepend the canonical absolute repository-local `bin` path for the current shell session; Intelli-Repo does not execute or persist that change.

## Commands

```text
intelli-repo install [--repo PATH] [--version VERSION] [--dry-run] [--yes]
intelli-repo configure [--repo PATH] [--set-agent NAME=enabled|disabled]... [--dry-run] [--yes]
intelli-repo update [--repo PATH] --version VERSION [--dry-run] [--yes]
intelli-repo update [--repo PATH] --rollback OPERATION_ID [--dry-run] [--yes]
intelli-repo doctor [--repo PATH]
intelli-repo uninstall [--repo PATH] [--dry-run] [--yes]
intelli-repo uninstall [--repo PATH] --purge-user-data --confirm-purge DELETE-USER-DATA [--yes]
intelli-repo lint|audit|ingest|task|release
```

Install and update operate on explicit compatible commits, display the complete proposed change, preserve unrelated work, validate before finalizing, and leave collision-free operation receipts. Updates acquire only the explicitly requested immutable tag, require the same lifecycle protocol, and retain their exact previous owned state in a named rollback payload. `update --rollback OPERATION_ID` refuses missing, consumed, ambiguous, or stale evidence and any intervening owned-state change. Failed mutations restore captured pre-state and record the outcome. Lifecycle operations never stage unrelated paths, commit, push, publish, follow a moving component branch, or change PATH.

Configuration is optional. With no mutation options, `configure` explains the convention defaults and reports current overrides. `--set-agent NAME=enabled|disabled` writes the strict schema-version-1 control plane only after displaying the proposal and receiving approval; recoverable pre-state is retained with the operation receipt. `doctor` is read-only and reports pass, fail, warning, not-applicable, and skipped checks for runtime, command, pins, submodule integrity, managed integration, configuration, operation state, optional Make, and rollback evidence.

Ordinary uninstall removes only exact, verified Intelli-Repo-owned integration and preserves `repo-agent-config.yaml`, user knowledge, workspace content, repository history, unrelated staging, unrelated files, and unrelated submodules. Altered or ambiguous owned integration fails before mutation. A recovery bundle restores captured state if mutation fails; after successful removal, reinstall works through the same immutable bootstrap.

`--purge-user-data` separately enumerates and removes `repo-agent-config.yaml`, `wiki/`, and `workspace/` where present. It requires the literal `--confirm-purge DELETE-USER-DATA`; `--yes` alone cannot authorize it. Purged data is recoverable during a failed transaction but not from Intelli-Repo after successful completion.

The exact-pin install, configure, update, doctor, named rollback, conservative uninstall, purge, and reinstall transactions are implemented. Agent-provided capability commands continue to fail closed until their respective implementations are present. A release tag is not ready until the complete lifecycle and rollback gates pass.

Release candidates are evaluated against executable public-tree, reproducibility, bootstrap, lifecycle, adversarial-input, redaction, and publication-refusal gates. The private evidence identifies the exact source, tooling, agent, and public-distribution revisions and fails closed for missing or required skipped gates. This evidence establishes conformance to the declared script contract, not certification of a user's host permutation, and never grants publication authority.

## Troubleshooting

Run `intelli-repo doctor --repo PATH` and retain the redacted operation identifier. Check that the target is a bounded Git worktree, the supported tools are available, network certificate validation succeeds, and installed submodule pins match the selected distribution version. Do not publish logs containing credentials, repository-private paths, or vulnerability details.

## Security

See [SECURITY.md](SECURITY.md) for the no-warranty, no-guaranteed-security-support posture and reporting limitations. Public issues may be used for non-sensitive defects; do not publish credentials, private content, personal data, or sensitive exploit details.

## License

Intelli-Repo distribution files are licensed under the [Apache License 2.0](LICENSE).
