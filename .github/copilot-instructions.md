# Copilot Instructions for sx110-TWRP

## Project Overview

This is a GitHub Actions-based automated TWRP (Team Win Recovery Project) builder. It uses the repo manifest tool to fetch Android source code and device trees, then compiles recovery images for Android devices.

**Key concept**: Users fork/template this repo and configure GitHub Actions to build TWRP recovery images by providing build parameters via workflow dispatch inputs.

## Architecture & Data Flow

### Build Pipeline (two workflows)
- **Recovery Build.yml**: For Android 9+ (modern). Uses `twrp-11`, `twrp-12.1` manifests, Java 8.
- **Recovery Build (Legacy).yml**: For Android 8.1 and below. Uses `twrp-7.1` (omni) manifest, ubuntu-20.04.

### Build Process Steps
1. **Initialization**: `repo init` with manifest URL/branch
2. **Sync**: `repo sync` to pull source code
3. **Device Trees**: Clone device-specific and common device trees
4. **Dependencies**: `scripts/convert.sh` parses `*.dependencies` files, generates `roomservice.xml` for repo
5. **Build**: `lunch <makefile>-eng && make <build-target>image`
6. **Release**: Upload `.img` files and `.zip` packages to GitHub Releases

### Critical Data Flows
- **Manifest URL/Branch** → determines Android version and base source
- **Device Tree URLs/Branches** → provide device-specific build configurations
- **Dependencies files** → `convert.sh` converts them to repo manifest XML format
- **Build outputs** → `out/target/product/<device>/` contains `.img` files and flashable zips

## Patterns & Conventions

### convert.sh Script Pattern
- Reads device `.dependencies` files (format: `remote="...", repository="...", target_path="...", branch="..."`)
- Parses fields using `grep` and `cut` for extracting quoted values
- Generates or appends to `.repo/local_manifests/roomservice.xml`
- Loops through arrays of remotes, repositories, and paths (indices 0-5 max)

### Workflow Input Convention
All build parameters passed via `workflow_dispatch` inputs (no hardcoding):
```yaml
MANIFEST_URL, MANIFEST_BRANCH, DEVICE_TREE_URL, DEVICE_TREE_BRANCH,
DEVICE_PATH, COMMON_TREE_URL (optional), COMMON_PATH (optional),
DEVICE_NAME, MAKEFILE_NAME, BUILD_TARGET
```

### Build Environment Setup
- Installs repo tool from `https://storage.googleapis.com/git-repo-downloads/repo`
- Installs extensive development dependencies (compilers, Java 8, Android build tools)
- Conditionally sets up SSH keys if manifest URL starts with `git@github.com`
- Uses `ALLOW_MISSING_DEPENDENCIES=true` to proceed despite missing optional deps

## Key Files & Patterns

| File | Purpose | Pattern |
|------|---------|---------|
| `.github/workflows/Recovery Build.yml` | Modern Android builds | Dispatch-driven, uses twrp-11/12.1, Ubuntu latest |
| `.github/workflows/Recovery Build (Legacy).yml` | Legacy Android (8.1-) | Same pattern, uses twrp-7.1, Ubuntu 20.04 |
| `scripts/convert.sh` | Dependency resolution | Parses `.dependencies` files, generates XML manifests |
| `README.md` | Usage docs, SSH setup guide | Extensive setup instructions with screenshots |

## Important Constraints & Guardrails

- **Ownership check**: `if: github.event.repository.owner.id == github.event.sender.id` — prevents running in forks without explicit permission
- **Error tolerance**: `Sync Device Dependencies` step has `continue-on-error: true` (missing dependencies don't fail build)
- **Python 3 only**: Python 2 removed from Debian (Ubuntu), affects Android 8.1 builds
- **Swap requirement**: Sets 12GB swap for large builds
- **Limited repo indices**: `convert.sh` loops through indices 0-5; dependencies with >5 entries partially processed

## Common Modifications

When users fork/template this repo:
1. Update Git username/email in workflow (lines ~100-101 in workflows)
2. Provide device tree repository URLs specific to their device
3. Add SSH private key to `secrets.SSH_PRIVATE_KEY` if using private repos
4. Trigger workflow with correct `MAKEFILE_NAME` (e.g., `twrp_devicename`)
5. Adjust `COMMON_TREE_URL` if their device requires a common device tree

## Development Notes

- Workflows run on push of workflow files themselves (can test changes via Actions tab)
- Builds are time-intensive (30+ minutes); logs are verbose for debugging compilation failures
- Device tree structure (`device/manufacturer/codename/`) must match `DEVICE_PATH` parameter
- Build target defaults to `recovery`, but `boot` and `vendorboot` are also supported
