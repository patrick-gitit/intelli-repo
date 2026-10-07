# Intelli-Repo

![Intelli-Repo banner](readme-banner.png)

Intelli-Repo turns an ordinary Git repository into a structured, inspectable environment for doing valuable work—and improving how that work gets done. Knowledge stays close to the work it informs. Decisions and policies make direction explicit, while tasks turn intent into action. Evidence preserves what happened and why. Humans and agents collaborate in the same version-controlled space, keeping the journey from idea to outcome understandable, reusable, and continuously improvable.

> **Beta status:** `v0.1.0-beta.2.9` is the current public beta. Its pre-1.0 compatibility contract may change in later releases.

## Current release: v0.1.0-beta.2.9

Validate ordinary release scope and publication capability

Date: 2026-10-07. Channel: beta. Profile: fix.

### Highlights

- Derive release change scope from Git ancestry and exact shipped bytes.
- Verify publication capability and exact read-back without a version-scoped override.
- Preserve immutable tags, Parent pins, and no-op retry identity across publication.

### Migration

No runtime migration is required. Use the current stable or immutable bootstrap for an existing compatible installation.

### Rollback

Use intelli-repo update --rollback OPERATION_ID while its receipt remains valid and owned state is unchanged.

### Known limitations

The beta compatibility contract may change. Dotenv support is Linux-only and stores user-managed plaintext. Native macOS and Windows dotenv validation remains deferred. Installed lint and release capabilities remain planned. Agent skills require agent-mediated invocation.

### Verification

Release gates verify deterministic bytes, checksums, fresh installation, capability catalog agreement, user-file preservation, source exclusion, immutable Git identity, and Presentation read-back.

[Versioned release note](release-notes/v0.1.0-beta.2.9.md).

## Install

For a normal installation, use the stable entrypoint:

```sh
curl -fsSL https://raw.githubusercontent.com/patrick-gitit/intelli-repo/main/install.sh | sh
```

The script on `main` points to one approved, immutable release. It does not search for the latest tag at runtime. It does not follow a component branch or query a hosting provider API. The mapping changes only when a new release is approved and published.

To install the current beta from its immutable tag, use:

```sh
curl -fsSL https://raw.githubusercontent.com/patrick-gitit/intelli-repo/v0.1.0-beta.2.9/install.sh | sh
```

You can also use `--version VERSION` when you need an explicit immutable version. Before running versioned content, the bootstrap verifies the selected tag's provenance and checksums.

### Compatible prior-release upgrade

To upgrade an exact, unmodified installation whose older updater cannot acquire the current complete manifest, run the current stable or immutable bootstrap again with the same `--repo` target. The verified current bootstrap recognizes only explicitly supported command digests and performs the normal transactional migration. Current installations use `intelli-repo update --version VERSION`; altered, unhealthy, or unknown installations continue to fail conservatively.

Git commits identify the exact content. Submodule gitlinks identify the exact agent revisions. Immutable annotated tags identify public releases. Together, these records provide the version authority for Intelli-Repo.

## Wiki support directories

Inside `wiki/`, `_inbox/` holds incoming material, `_ingest/` holds source accounting, `_capabilities/` holds local processing extensions, and `_archive/` holds preserved history. The underscore distinguishes these support areas from substantive content registers.

Fresh installations create this layout. Updating an earlier installation does not move content from the old directory names; conversion of a populated legacy layout requires manual review.

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
intelli-repo capabilities [--repo PATH] [--format text|json]
intelli-repo capability show CAPABILITY_ID [--repo PATH] [--format text|json]
intelli-repo capability instructions CAPABILITY_ID [--repo PATH]
intelli-repo uninstall [--repo PATH] [--dry-run] [--yes]
intelli-repo uninstall [--repo PATH] --purge-user-data --confirm-purge DELETE-USER-DATA [--yes]
intelli-repo lint|audit|ingest|task|release
intelli-repo version
intelli-repo help
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

To explicitly select beta.2 local dotenv retrieval for one named value, use:

```sh
intelli-repo configure --set-secret-provider dotenv --set-secret-name NAME
```

Beta.2 dotenv support is verified for Linux only. Windows and macOS support is unavailable until their native validation tasks pass in a future release.

Intelli-Repo displays the proposed configuration before writing it and requires approval. The resulting `repo-agent-config.yaml` follows the strict version 1 schema. The operation receipt retains enough prior state to recover from a failed change.

### Doctor

`doctor` is read-only. It checks the installed runtime, command, agent pins, submodule integrity, managed integration, configuration, selected dotenv readiness, operation state, optional Make support, and available rollback evidence. A dotenv readiness check validates the fixed file, access controls, Git exclusion, complete literal grammar, and exact configured name while discarding the value.

Each applicable check has one of these results:

- `pass` means the check succeeded
- `fail` means the installation does not meet the requirement
- `warning` identifies a concern that does not make the installation invalid
- `not-applicable` means the check does not apply to the current state
- `skipped` means the check could not or did not need to run

### Local dotenv secrets — Linux beta support

Dotenv is optional and never selected automatically. From the repository root:

1. Select exactly one name with `intelli-repo configure --set-secret-provider dotenv --set-secret-name NAME`. After approval, configure adds the exact standalone `.intelli-repo/.env` rule to the root `.gitignore` when absent while preserving existing bytes. Review and commit that ignore protection before creating the secret file.
2. Create `.intelli-repo/.env` yourself. Do not paste its values into chat, commands, screenshots, issues, logs, or documentation.
3. Restrict the file with `chmod 600 .intelli-repo/.env` (read-only owner mode `0400` is also accepted).
4. Add literal `NAME=value` assignments. Multiple unrelated names are allowed; names must be unique. Shell syntax, `export`, interpolation, command substitution, includes, multiline values, and executable expressions are rejected rather than evaluated.
5. Run `intelli-repo doctor`. It reports a safe reason such as missing file, unsafe path, wrong owner, unsafe permissions, Git exposure, malformed grammar, duplicate name, missing name, empty value, or excessive size without printing any value.

`.intelli-repo/.env` stores secrets as plaintext on this device. Intelli-Repo checks access controls, Git exclusion, file format, and bounded delivery, but operating-system administrators, backups, malware, crash data, or other software with sufficient access may still read it. You create, protect, rotate, revoke, and delete these values. Intelli-Repo uses only the exact name selected for the approved consumer and does not use this file to authenticate GitHub CLI.

Install never creates or populates the file. Update, rollback, and ordinary uninstall preserve it. Remove or rotate a value by editing your user-owned file and rerunning `doctor`; Intelli-Repo does not create, rotate, revoke, synchronize, or delete credentials. GitHub Presentation uses only an already configured and authenticated `gh` client and cannot select dotenv. Beta.2 includes no keychain, OAuth/connector, interactive-entry, ambient-variable, discovery, or fallback provider.

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

The installed facade exposes a harness-neutral capability catalog. `audit` resolves to the available `audit-wiki` Agent Skills package. `ingest` and `task` resolve to their installed agent skills. These are agent-mediated capabilities, not shell commands. Use `capability instructions` to retrieve the exact effective `SKILL.md` bytes for an available skill.

`lint` and `release` are planned capabilities. Their legacy command positions, along with the agent-mediated legacy positions, fail closed and report catalog-derived kind, availability, and invocation truth. Optional harness adapters may consume the neutral JSON catalog, but the core installation does not detect, configure, or depend on a named harness.

A release is not ready until its lifecycle and rollback gates pass. Release candidates are checked for public-tree integrity and reproducibility. They are also tested for bootstrap behavior, lifecycle behavior, adversarial input handling, secret redaction, and refusal to publish without approval.

Private release evidence records the exact source revision. It also records the tooling revision, agent revisions, public distribution revision, and gate results. A missing required gate or a required skipped gate makes the evaluation fail.

This evidence shows conformance to the declared script contract. It does not certify every possible host environment, and it never grants permission to publish a release.

### Capability reference

The following catalog is generated from the exact release inputs. Available agent skills are interpreted by an authorized agent; they are not directly runnable shell commands.

| Capability | Aliases | Kind | Availability | Invocation | Agent | Authority | Description |
|---|---|---|---|---|---|---|---|
| `audit-wiki` | `audit` | agent-skill | available | agent-mediated | wiki-agent | read-only | Inspect wiki metadata, links, provenance, and lifecycle conformance without mutation. |
| `capability-composition` | none | agent-skill | available | agent-mediated | base-agent | read-only | Resolve layered capabilities and the authority that constrains them. |
| `classify-authority` | none | agent-skill | available | agent-mediated | wiki-agent | read-only-until-classification-recording-is-authorized | Classify source authority before recording an authorized disposition. |
| `complete-work` | none | agent-skill | available | agent-mediated | base-agent | repository-local-note-editing-when-authorized | Verify task gates and record authorized completion evidence. |
| `decompose-claims` | none | agent-skill | available | agent-mediated | wiki-agent | wiki-note-editing-when-authorized | Split an intake source into material claims for traceable accounting. |
| `escalate-and-handoff` | none | agent-skill | available | agent-mediated | operator-agent | read-only-until-authority-is-granted | Identify an authority gap and prepare an authorized handoff. |
| `evidence-receipts` | none | agent-skill | available | agent-mediated | base-agent | repository-local-log-editing-when-authorized | Record bounded evidence for an authorized operation. |
| `execute-approved-plan` | none | agent-skill | available | agent-mediated | operator-agent | task-scoped-workspace-editing-when-authorized | Carry out explicitly authorized workspace work under the applicable contract. |
| `governance-preflight` | none | agent-skill | available | agent-mediated | base-agent | read-only-until-scope-is-confirmed | Read task-relevant governance before acting. |
| `ingest-and-archive` | `ingest` | agent-skill | available | agent-mediated | wiki-agent | archive-mutation-when-authorized | Account for source claims and archive only after the ingestion gates pass. |
| `inventory-inbox` | none | agent-skill | available | agent-mediated | wiki-agent | read-only-until-inventory-recording-is-authorized | Inventory intake sources and material claims before ingestion. |
| `lint-wiki` | `lint` | planned | planned | agent-mediated | distribution | none | Planned wiki lint capability; direct shell execution is unavailable. |
| `maintain-wiki-scaffold` | none | agent-skill | available | agent-mediated | wiki-agent | wiki-path-editing-when-authorized | Maintain the declared wiki layout within authorized paths. |
| `manage-plan-task-lifecycle` | `task` | agent-skill | available | agent-mediated | wiki-agent | plan-and-task-note-editing-when-authorized | Track plan and task lifecycle transitions with evidence and archival gates. |
| `mutate-workspace` | none | agent-skill | available | agent-mediated | operator-agent | task-scoped-workspace-editing-when-authorized | Apply bounded, explicitly authorized workspace changes. |
| `preserve-unrelated-state` | none | agent-skill | available | agent-mediated | operator-agent | read-only-until-mutation-scope-is-confirmed | Inspect and preserve user files and unrelated repository state. |
| `record-operation` | none | agent-skill | available | agent-mediated | operator-agent | repository-local-log-editing-when-authorized | Record non-secret evidence for an authorized operation. |
| `release-workflow` | `release` | planned | planned | agent-mediated | distribution | none | Planned installed release capability; maintainer publication uses the separate design workflow. |
| `route-artifacts` | none | agent-skill | available | agent-mediated | wiki-agent | wiki-note-editing-when-authorized | Route knowledge artifacts to their authoritative registers. |
| `run-workflow` | none | agent-skill | available | agent-mediated | operator-agent | local-command-execution-when-authorized | Run declared local workflows only within granted command authority. |
| `scoped-planning` | none | agent-skill | available | agent-mediated | base-agent | repository-local-note-editing-when-authorized | Define a bounded scope and evidence gates for authorized work. |

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
