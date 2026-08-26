# Security Policy

## Support posture

Intelli-Repo is provided under the Apache License 2.0 on an "AS IS" basis, without warranties or guaranteed support, response times, security maintenance, or fixes. You are responsible for evaluating whether the utility is suitable for your use and for assuming the risks of running it.

Review the immutable tagged scripts, provenance, exact component commits, and checksums before use. Their availability supports independent evaluation; it is not a security warranty or certification.

## Local dotenv risk

The optional beta.2 dotenv provider is verified for Linux only and stores user-supplied values as plaintext in `.intelli-repo/.env`. Intelli-Repo validates ownership, restrictive access mode, Git exclusion, literal syntax, and bounded exact-name delivery, but it cannot prevent operating-system administrators, backups, malware, crash data, or sufficiently privileged software from reading the file. Users remain responsible for choosing this provider, creating and protecting the file, selecting suitable values, and rotating, revoking, or deleting them.

Never commit or publish `.intelli-repo/.env`, paste its values into commands or chat, or use it to configure GitHub CLI. Windows and macOS support is unavailable until separately validated in a future release.

## Reporting limitations

No confidential vulnerability-reporting channel is currently maintained. Public issues may be used for non-sensitive defects, but do not publish credentials, private repository content, personal data, or sensitive exploit details in an issue, discussion, pull request, commit, or repository file.

The project makes no commitment to investigate, respond to, remediate, or coordinate disclosure of reported security concerns. A confidential reporting channel may be established later if the maintenance posture changes.
