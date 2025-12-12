# Development Directory

This directory contains development versions of the kit files.

## Purpose

When developing this kit, edit files here instead of the production files in `.apm/` and `.claude/`. This prevents breaking your own workflow while developing.

## Structure

```
dev/
├── .apm/
│   ├── guides/              # Development versions of methodology guides
│   └── metadata.json        # Development metadata
└── .claude/
    └── commands/            # Development versions of slash commands
```

## Workflow

1. **Edit files here** - Make all changes in this directory
2. **Test your changes** - Reference these files directly or copy temporarily to test
3. **Sync to production** - When ready, run `../sync-dev.sh` to promote changes
4. **Commit** - Review and commit the synced production files

## Key Points

- Files here are version controlled (committed to git)
- Production files are synced FROM here, not the other way around
- The install script uses production files from the repo's `main` branch
- Your local dev work doesn't affect remote installations

See `../DEVELOPMENT.md` for detailed workflow documentation.
