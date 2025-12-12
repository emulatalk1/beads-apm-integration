# Development Workflow

This guide explains how to develop this kit without breaking your own workflow.

## The Problem

When using this kit to develop itself, changes to production files (`.apm/guides/`, `.claude/commands/`) immediately affect your development workflow. This creates a chicken-and-egg problem.

## The Solution

Use the `dev/` directory for development work. When changes are stable, sync them to production.

## Directory Structure

```
dev/
├── .apm/
│   └── guides/              # Development versions of guides
└── .claude/
    └── commands/            # Development versions of commands

.apm/
└── guides/                  # Production versions (used by install script)

.claude/
└── commands/                # Production versions (active commands)
```

## Workflow

### 1. Development

Work in the `dev/` directory:

```bash
# Edit guides
vim dev/.apm/guides/Context_Synthesis_Guide.md

# Edit commands
vim dev/.claude/commands/apm-setup.md
```

### 2. Testing

To test your changes, manually reference dev files in your work:

```bash
# Test a guide by reading it directly
cat dev/.apm/guides/Context_Synthesis_Guide.md

# Or temporarily copy to test with commands
cp dev/.claude/commands/apm-setup.md .claude/commands/apm-setup-test.md
# Then use /apm-setup-test to test
# Delete when done: rm .claude/commands/apm-setup-test.md
```

### 3. Sync to Production

When your changes are ready:

```bash
./sync-dev.sh
```

This copies files from `dev/` to production directories:
- `dev/.apm/guides/` → `.apm/guides/`
- `dev/.claude/commands/` → `.claude/commands/`

### 4. Review and Commit

```bash
# Review changes
git diff

# Test production commands
/apm-setup  # or /apm-start

# Commit if satisfied
git add .
git commit -m "Update guides: description of changes"
git push
```

## Best Practices

### Keep Dev and Production Separate

- **Always edit in `dev/`** - Never directly edit production files
- **Test thoroughly** - Make sure changes work before syncing
- **Commit often** - Small commits make it easier to track changes

### When Developing Features

1. Create/update files in `dev/`
2. Test by referencing dev files directly
3. When stable, run `./sync-dev.sh`
4. Test production versions
5. Commit and push

### When Fixing Bugs

1. Identify the bug in production files
2. Make fix in `dev/` version
3. Sync to production
4. Verify fix works
5. Commit

### Using Git Branches

For major changes, consider using branches:

```bash
# Create feature branch
git checkout -b feature/improve-context-synthesis

# Work in dev/ directory
vim dev/.apm/guides/Context_Synthesis_Guide.md

# Sync and commit
./sync-dev.sh
git add .
git commit -m "Improve context synthesis questions"

# Test thoroughly, then merge
git checkout main
git merge feature/improve-context-synthesis
git push
```

## Installation Script

The `install.sh` script pulls files from GitHub's `main` branch:

```bash
GITHUB_RAW_BASE="https://raw.githubusercontent.com/emulatalk1/beads-apm-integration/main"
```

This means:
- Local changes don't affect remote installs
- Only committed and pushed changes to `main` are distributed
- You can develop locally without worrying about breaking user installations

## Common Scenarios

### Scenario 1: Adding a New Guide

```bash
# Create in dev
vim dev/.apm/guides/New_Guide.md

# Update install script to include it
vim install.sh  # Add to guides array

# Sync to production
./sync-dev.sh

# Test the install script locally
./install.sh /tmp/test-project

# Commit
git add .
git commit -m "Add New_Guide.md"
git push
```

### Scenario 2: Updating Command Logic

```bash
# Edit dev version
vim dev/.claude/commands/apm-start.md

# Sync to production
./sync-dev.sh

# Test command
/apm-start

# If it works, commit
git add .
git commit -m "Update apm-start: improve error handling"
git push
```

### Scenario 3: Major Refactor

```bash
# Use a branch
git checkout -b refactor/guides

# Work in dev/
vim dev/.apm/guides/*.md

# Sync and test multiple times
./sync-dev.sh
# Test...
# Make more changes in dev/
./sync-dev.sh
# Test again...

# When satisfied
git add .
git commit -m "Refactor all guides for clarity"
git checkout main
git merge refactor/guides
git push
```

## Tips

1. **Keep dev/ in sync** - After syncing, dev/ and production should match
2. **Document changes** - Update this file if you change the workflow
3. **Test before pushing** - Remember that pushed changes affect new installations
4. **Use branches** - For experimental work, use git branches
5. **Backup important work** - Git history is your friend

## Troubleshooting

### "I edited production files by mistake"

```bash
# Copy changes to dev
cp .apm/guides/modified-file.md dev/.apm/guides/

# Reset production
git checkout .apm/guides/modified-file.md

# Now dev has your changes, production is clean
```

### "Dev and production are out of sync"

```bash
# Make production match dev
./sync-dev.sh

# Or make dev match production
cp -r .apm/guides/* dev/.apm/guides/
cp -r .claude/commands/* dev/.claude/commands/
```

### "Install script broke"

```bash
# Test locally first
./install.sh /tmp/test-project

# Check what's in the production directories
ls -la .apm/guides/
ls -la .claude/commands/

# Verify install script references correct files
grep "guides=(" install.sh
```
