# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased]

### Added
- `tests_path` input: configures the path or glob appended after `-- ` to the test runner command
- Short git hash (`sha-<7chars>`) included in every release as a dist-tag alongside semver tags

### Changed
- All step scripts use `#!/usr/bin/env psh` as the shebang — psh intercepts and logs every command automatically
- `setup-psh.sh` detects runner architecture dynamically (amd64 and arm64)
- `config_file` is now loaded via a dedicated step at the start of the composite action
- `node_version` input wired to `actions/setup-node` step

## [0.1.0] - Initial scaffold
