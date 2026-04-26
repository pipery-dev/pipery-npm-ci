# Pipery npm CI

CI pipeline for npm/Node.js: SAST, SCA, lint, build, test, versioning, packaging, publish, reintegration

## Status

- Owner: `pipery-dev`
- Repository: `pipery-npm-ci`
- Marketplace category: `continuous-integration`
- Current version: `0.1.0`

## Usage

```yaml
name: Example
on: [push]

jobs:
  run-action:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: pipery-dev/pipery-npm-ci@v0
        with:
          project_path: .
```

## Inputs

### Core

| Name | Default | Description |
|---|---|---|
| `project_path` | `.` | Path to the project source tree. |
| `config_file` | `.github/pipery/config.yaml` | Path to pipery config file. |
| `log_file` | `pipery.jsonl` | Path to the JSONL log file. |
| `node_version` | `20` | Node.js version to use. |
| `package_manager` | `auto` | Package manager: `auto`, `npm`, or `yarn`. |

### Registry / publish credentials

| Name | Default | Description |
|---|---|---|
| `registry` | `npmjs` | Registry target for release. |
| `npm_token` | `` | npm registry auth token for publishing. |
| `github_token` | `` | GitHub token for reintegration. |

### Pipeline controls (skip flags)

| Name | Default | Description |
|---|---|---|
| `skip_sast` | `false` | Skip SAST scan. |
| `skip_sca` | `false` | Skip SCA scan. |
| `skip_lint` | `false` | Skip lint step. |
| `skip_build` | `false` | Skip build step. |
| `skip_test` | `false` | Skip test step. |
| `skip_versioning` | `false` | Skip versioning step. |
| `skip_packaging` | `false` | Skip packaging step. |
| `skip_release` | `false` | Skip release step. |
| `skip_reintegration` | `false` | Skip reintegration step. |

### Versioning & release

| Name | Default | Description |
|---|---|---|
| `version_bump` | `patch` | Version bump kind: `patch`, `minor`, or `major`. |

### Testing

| Name | Default | Description |
|---|---|---|
| `tests_path` | `` | Path or glob passed to the test runner as an argument (appended after `-- ` to the test command). |

## Outputs

| Name | Description |
|---|---|
| `version` | The new version string after the versioning step. |

## Steps

| Step | Skip flag | What it does |
|---|---|---|
| SAST | `skip_sast` | Static analysis via pipery-steps |
| SCA | `skip_sca` | Dependency vulnerability scan |
| Lint | `skip_lint` | ESLint (when a config file is found in `project_path`) |
| Build | `skip_build` | Run build script via detected package manager |
| Test | `skip_test` | Run test suite; `tests_path` is appended after `-- ` to the test command |
| Versioning | `skip_versioning` | Bump version, write to `GITHUB_OUTPUT` |
| Packaging | `skip_packaging` | `npm pack` to create a tarball artifact |
| Release | `skip_release` | `npm publish` and add `sha-<shortsha>` as a dist-tag |
| Reintegration | `skip_reintegration` | Merge release branch back to default |

## Development

This repository is managed with `pipery-tooling`.

```bash
pipery-actions test --repo .
pipery-actions release --repo . --dry-run
```
