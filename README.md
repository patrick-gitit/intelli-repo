# Intelli-Repo

![Intelli-Repo banner](readme-banner.png)

Intelli-Repo turns an ordinary Git repository into a structured, inspectable environment for doing valuable work—and improving how that work gets done. Knowledge stays close to the work it informs. Decisions and policies make direction explicit, while tasks turn intent into action. Evidence preserves what happened and why. Humans and agents collaborate in the same version-controlled space, keeping the journey from idea to outcome understandable, reusable, and continuously improvable.

> **Beta status:** `v0.1.0-beta.1` is the current public beta. Its pre-1.0 compatibility contract may change in later releases.

## Install

For a normal installation, use the stable entrypoint:

```sh
curl -fsSL https://raw.githubusercontent.com/patrick-gitit/intelli-repo/main/install.sh | sh
```

The script on `main` points to one approved, immutable release. It does not search for the latest tag at runtime. It does not follow a component branch or query a hosting provider API. The mapping changes only when a new release is approved and published.

To install the current beta from its immutable tag, use:

```sh
curl -fsSL https://raw.githubusercontent.com/patrick-gitit/intelli-repo/v0.1.0-beta.1/install.sh | sh
```

You can also use `--version VERSION` when you need an explicit immutable version. Before running versioned content, the bootstrap verifies the selected tag's provenance and checksums.

Git commits identify the exact content. Submodule gitlinks identify the exact agent revisions. Immutable annotated tags identify public releases. Together, these records provide the version authority for Intelli-Repo.

## Runtime requirements

Intelli-Repo checks what an environment can do instead of relying on its operating system label. It does not certify individual Linux distributions, WSL versions, processor architectures, containers, CI runners, or other host combinations. You are responsible for confirming that your environment meets the requirements below.

The required capabilities are:

- A POSIX-compatible `sh` for running the scripts
- Git 2.34 or newer for repository and submodule operations
- curl 7.81 or newer for downloading public release artifacts
- Either `sha256sum` or `shasum -a 256` for integrity checks
- The POSIX utilities used by the lifecycle scripts
- A working CA trust store for validating HTTPS connections
- HTTPS access to the public artifacts and repositories hosted on GitHub
- Filesystem support for canonical paths and symbolic links
- Filesystem support for permissions and executable modes
- Filesystem support for temporary directories, Git worktrees, and submodules

GNU Make is optional. If a compatible version is available, Intelli-Repo adds convenient managed Make targets. Installation does not require Make, and you can always run `.intelli-repo/bin/intelli-repo` directly.

Preflight checks look for requirements that can be detected before a change begins. If a required capability is missing or incompatible, the operation stops before making changes. Passing preflight confirms the declared requirements only. It is not a certification or warranty for the host environment.

## Where the command lives

Intelli-Repo keeps its command and orchestration code under `.intelli-repo/bin/`. The canonical command is:

```text
.intelli-repo/bin/intelli-repo
```

The installation does not create separate `lib` or `libexec` directories. It does not install a global executable or create a global symbolic link. Each exact-pinned agent remains a separate component under its declared `.intelli-repo/*-agent/` path.

Managed `intelli-repo-*` Make targets call the repository-local command. You can also invoke it directly from the repository root:

```sh
./.intelli-repo/bin/intelli-repo doctor
```

Installation never changes `PATH` or your shell startup files. You may add the repository's absolute `.intelli-repo/bin/` path to `PATH` for the current shell session. Intelli-Repo will not make that choice or persist it for you.

## Command reference

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

## How lifecycle operations behave

### Install and update

Install and update work with explicit, compatible commits. Before changing anything, the command shows the complete proposal. It preserves unrelated work and validates the result before finalizing the operation. Each completed operation leaves a uniquely named receipt.

An update downloads only the immutable tag you request. The requested release must use the same lifecycle protocol as the installed version. Before applying the update, Intelli-Repo captures the exact owned state needed for rollback.

Use the operation ID from a successful update receipt to roll back:

```sh
intelli-repo update --rollback OPERATION_ID
```

Rollback fails safely when the receipt is missing, ambiguous, stale, or already consumed. It also refuses to continue if Intelli-Repo-owned state has changed since the update.

If an install, update, or rollback fails after mutation begins, Intelli-Repo attempts to restore the captured state. It records whether recovery succeeded and never reports success when restoration fails.

Lifecycle operations stay within their declared scope. They do not stage unrelated paths. They do not create commits, push changes, publish releases, follow moving component branches, or alter `PATH`.

### Configuration

Configuration is optional. Run `configure` without change options to see the convention-based defaults and any current overrides.

To enable or disable an agent, use:

```sh
intelli-repo configure --set-agent NAME=enabled|disabled
```

Intelli-Repo displays the proposed configuration before writing it and requires approval. The resulting `repo-agent-config.yaml` follows the strict version 1 schema. The operation receipt retains enough prior state to recover from a failed change.

### Doctor

`doctor` is read-only. It checks the installed runtime, command, agent pins, submodule integrity, managed integration, configuration, operation state, optional Make support, and available rollback evidence.

Each applicable check has one of these results:

- `pass` means the check succeeded
- `fail` means the installation does not meet the requirement
- `warning` identifies a concern that does not make the installation invalid
- `not-applicable` means the check does not apply to the current state
- `skipped` means the check could not or did not need to run

### Uninstall

An ordinary uninstall removes only verified Intelli-Repo-owned integration. It preserves the following user and repository state:

- `repo-agent-config.yaml`
- Knowledge stored under `wiki/`
- Content stored under `workspace/`
- Repository history
- Unrelated staged changes
- Unrelated files
- Unrelated submodules

If owned integration has been changed or cannot be identified safely, uninstall stops before mutation. If removal fails after mutation begins, a recovery bundle is used to restore the captured state. After a successful uninstall, you can reinstall through the same immutable bootstrap.

### Purge user data

Purge is a separate destructive operation. It removes these paths when they exist:

- `repo-agent-config.yaml`
- `wiki/`
- `workspace/`

Purge requires the literal confirmation below:

```text
--confirm-purge DELETE-USER-DATA
```

The `--yes` option is not enough to authorize a purge. During a failed transaction, Intelli-Repo attempts to recover purged data from its temporary recovery state. After a successful purge, Intelli-Repo makes no recovery promise.

## Current capability status

The following lifecycle operations are implemented:

- Exact-pin install
- Optional configuration
- Exact-version update
- Read-only doctor
- Named rollback
- Conservative uninstall
- Explicit purge
- Clean reinstall

Agent-provided `lint`, `audit`, `ingest`, `task`, and `release` commands remain unavailable until their respective agents implement them. These commands fail closed instead of pretending to complete work.

A release is not ready until its lifecycle and rollback gates pass. Release candidates are checked for public-tree integrity and reproducibility. They are also tested for bootstrap behavior, lifecycle behavior, adversarial input handling, secret redaction, and refusal to publish without approval.

Private release evidence records the exact source revision. It also records the tooling revision, agent revisions, public distribution revision, and gate results. A missing required gate or a required skipped gate makes the evaluation fail.

This evidence shows conformance to the declared script contract. It does not certify every possible host environment, and it never grants permission to publish a release.

## Troubleshooting

Start with:

```sh
intelli-repo doctor --repo PATH
```

Keep the redacted operation identifier from the output. It can help connect a problem to the relevant local evidence.

If an operation fails, check each of these conditions:

- The target is a bounded Git worktree
- The required tools are installed at supported versions
- Network certificate validation succeeds
- The installed submodule pins match the selected distribution version

Review logs before sharing them. Do not publish credentials. Remove private repository paths and other private content. Do not place sensitive vulnerability details in a public issue.

## Security

Read [SECURITY.md](SECURITY.md) for the project's support and reporting posture. Intelli-Repo is provided without guaranteed security support or maintenance.

Public issues may be used for non-sensitive defects. Do not publish credentials, private content, personal data, or sensitive exploit details.

## License

Intelli-Repo distribution files are licensed under the [Apache License 2.0](LICENSE).
