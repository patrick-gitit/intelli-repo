#!/bin/sh
set -eu

readonly_default_version='v0.1.0-beta.1'
readonly_public_base='https://raw.githubusercontent.com/patrick-gitit/intelli-repo'

fail() {
    printf 'intelli-repo bootstrap: %s\n' "$1" >&2
    exit "${2:-64}"
}

require_command() {
    command -v "$1" >/dev/null 2>&1 || fail "required command not found: $1" 65
}

digest_file() {
    if command -v sha256sum >/dev/null 2>&1; then
        sha256sum "$1" | awk '{ print $1 }'
    elif command -v shasum >/dev/null 2>&1; then
        shasum -a 256 "$1" | awk '{ print $1 }'
    else
        fail 'sha256sum or shasum is required' 65
    fi
}

yaml_scalar() {
    yaml_key=$1
    yaml_file=$2
    yaml_lines=$(grep -Ec "^$yaml_key: \"[^\"]*\"$" "$yaml_file" || true)
    [ "$yaml_lines" -eq 1 ] || fail "provenance field is missing or ambiguous: $yaml_key" 65
    sed -n "s/^$yaml_key: \"\([^\"]*\)\"$/\1/p" "$yaml_file"
}

version=$readonly_default_version
selection_context=embedded-default
while [ "$#" -gt 0 ]; do
    case "$1" in
        --version)
            [ "$#" -ge 2 ] || fail '--version requires a value'
            version=$2
            selection_context=explicit-version
            shift 2
            ;;
        --help|-h)
            cat <<USAGE
Usage: install.sh [--version VERSION] [intelli-repo install options]

Downloads and verifies the immutable Intelli-Repo command for VERSION, then
runs its install operation. The default approved release is
$readonly_default_version.
USAGE
            exit 0
            ;;
        *) break ;;
    esac
done

require_command curl
require_command grep
require_command awk
require_command chmod
require_command cp
require_command sed
require_command mktemp
require_command rm
if ! printf '%s\n' "$version" | grep -Eq '^v(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)(-[0-9A-Za-z][0-9A-Za-z.-]*)?$'; then
    fail "invalid version: $version"
fi
if ! command -v sha256sum >/dev/null 2>&1 && ! command -v shasum >/dev/null 2>&1; then
    fail 'sha256sum or shasum is required' 65
fi

umask 077
bootstrap_directory=$(mktemp -d "${TMPDIR:-/tmp}/intelli-repo-bootstrap.XXXXXX") || fail 'could not create temporary directory' 65
cleanup() {
    case ${bootstrap_directory##*/} in
        intelli-repo-bootstrap.??????) rm -rf -- "$bootstrap_directory" ;;
        *) printf 'intelli-repo bootstrap: refusing unsafe temporary cleanup path: %s\n' "$bootstrap_directory" >&2 ;;
    esac
}
trap cleanup EXIT HUP INT TERM

for artifact in intelli-repo PROVENANCE.yaml SHA256SUMS; do
    artifact_source="$readonly_public_base/$version/$artifact"
    curl -fsSL "$artifact_source" -o "$bootstrap_directory/$artifact" || fail "could not retrieve $artifact_source" 65
done
chmod 0700 "$bootstrap_directory/intelli-repo"
chmod 0600 "$bootstrap_directory/PROVENANCE.yaml" "$bootstrap_directory/SHA256SUMS"

provenance_version=$(yaml_scalar distribution_version "$bootstrap_directory/PROVENANCE.yaml")
[ "$provenance_version" = "$version" ] || fail 'selected version does not match immutable provenance' 65

expected_paths='CHANGELOG.md LICENSE PROVENANCE.yaml README.md SECURITY.md install.sh intelli-repo'
checksum_paths=''
while IFS= read -r checksum_line || [ -n "$checksum_line" ]; do
    printf '%s\n' "$checksum_line" | grep -Eq '^[0-9a-f]{64}  [A-Za-z0-9][A-Za-z0-9._-]*$' || fail 'invalid SHA256SUMS syntax or path' 65
    checksum_digest=${checksum_line%%  *}
    checksum_path=${checksum_line#*  }
    case " $expected_paths " in *" $checksum_path "*) ;; *) fail "unexpected checksum path: $checksum_path" 65 ;; esac
    case " $checksum_paths " in *" $checksum_path "*) fail "duplicate checksum path: $checksum_path" 65 ;; esac
    checksum_paths="$checksum_paths $checksum_path"
    if [ "$checksum_path" = intelli-repo ]; then
        actual_digest=$(digest_file "$bootstrap_directory/intelli-repo")
        [ "$actual_digest" = "$checksum_digest" ] || fail 'immutable command checksum mismatch' 65
    fi
done <"$bootstrap_directory/SHA256SUMS"
for expected_path in $expected_paths; do
    case " $checksum_paths " in *" $expected_path "*) ;; *) fail "missing checksum path: $expected_path" 65 ;; esac
done

INTELLI_REPO_BOOTSTRAP_VERSION=$version \
INTELLI_REPO_BOOTSTRAP_PROVENANCE=$bootstrap_directory/PROVENANCE.yaml \
INTELLI_REPO_BOOTSTRAP_CHECKSUMS=$bootstrap_directory/SHA256SUMS \
INTELLI_REPO_BOOTSTRAP_SELECTION=$selection_context \
    "$bootstrap_directory/intelli-repo" install --version "$version" "$@"
