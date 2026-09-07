
# Kiri Pull Request GitHub Action

This action runs [Kiri](https://github.com/leoheck/kiri) against a pull request and publishes an HTML preview.

The base image is hosted at <https://github.com/wang-edward/kiri-github-action/pkgs/container/kiri>. It ships KiCad 10 and diffs projects entirely through `kicad-cli`, so KiCad 9 and 10 projects are supported. Older formats that require the legacy OCaml plotting path (`plotgitsch`) are not supported.

## PR HTML Preview Setup

The action pushes previews to `gh-pages`, under `pr-previews/<PR number>/`. This retains previews for simultaneous pull requests.

The repository must have a `gh-pages` branch containing `.nojekyll` (so `_KIRI_` folders do not return 404s). Configure GitHub Pages to publish from that branch.

The caller workflow needs these permissions:

```yaml
permissions:
  contents: write
  issues: write
  pull-requests: write
```

Fork pull requests receive a read-only `GITHUB_TOKEN` for normal `pull_request` workflows and therefore cannot publish to `gh-pages` or update comments. Use a trusted workflow design only if publishing fork previews is required; do not expose write-capable secrets to untrusted PR code.

This can be done quickly like so:

```bash
git init tempfolder
cd tempfolder
touch .nojekyll
git add .nojekyll
git commit -m "Initial Commit"
git branch gh-pages
git remote add origin <your origin>
git push origin HEAD:refs/heads/gh-pages
cd ..
rm -rf tempfolder
```

### Deleting PRs on close

Running this action in the context of `pull_request.closed` will delete any Kiri previews that were made for the PR.

## Action inputs

All inputs are **optional**.

|           Name           |                               Description                                |
| ------------------------ | ------------------------------------------------------------------------ |
| `all`                    | If set, include all commits even if schematics/layout don't have changes |
| `last`                   | Show last N commits                                                      |
| `newer`                  | Show commits up to this one                                              |
| `older`                  | Show commits starting from this one                                      |
| `force-layout-view`      | If set, force starting with the Layout view selected                     |
| `pcb-page-frame`         | If set, disable page frame for PCB                                       |
| `archive`                | If set, archive generated files                                          |
| `remove`                 | If set, remove generated folder before running it                        |
| `output-dir`             | If set, change output folder path/name                                   |
| `project-file`           | Path to the KiCad project file                                           |
| `extra-args`             | Extra arguments to pass to Kiri                                          |
| `kiri-debug`             | If set, enable debugging output                                          |

## Examples

Use a release tag for the action. Action releases use the maintained `ghcr.io/wang-edward/kiri:v2` image, so changing workflow code does not rebuild KiCad.

### Quick Start

```yaml
# .github/workflows/pr-kicad-diff.yaml
name: KiCad Pull Request Diff

concurrency:
  group: ${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: true

on:
  pull_request:
    types:
    - opened
    - synchronize

jobs:
  kiri-diff:
    runs-on: ubuntu-latest
    permissions:
      contents: write
      issues: write
      pull-requests: write
    steps:
    - uses: actions/checkout@v4
      with:
        ref: ${{ github.event.pull_request.head.sha }}
    - name: Kiri
      uses: wang-edward/kiri-github-action@v2
      with:
        project-file: kicad/productname.kicad_pro
```

```yaml
# .github/workflows/pr-kicad-diff-delete.yaml
name: KiCad Diff Delete

concurrency:
  group: ${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: false

on:
  pull_request:
    types:
    - closed

jobs:
  kiri-delete:
    runs-on: ubuntu-latest
    permissions:
      contents: write
      issues: write
      pull-requests: write
    steps:
    - name: Kiri
      uses: wang-edward/kiri-github-action@v2
```
