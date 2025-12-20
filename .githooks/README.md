# Git Hooks for Auto-Commit

This directory contains git hooks that automatically commit and push changes to the parent `dev-env` repository when you commit/push in this nested nvim config repository.

## Setup

After cloning this repository on a new machine, run:

```bash
./setup-hooks.sh
```

Or manually:

```bash
chmod +x .githooks/*
git config core.hooksPath .githooks
```

## Hooks

- **post-commit**: Automatically commits changes to the parent `dev-env` repo after each commit here
- **pre-push**: Automatically pushes the parent `dev-env` repo before pushing this repo

## How it works

The hooks detect the parent repository by navigating up the directory tree from `.config/nvim` to find the root `dev-env` directory.

If the parent repo doesn't exist or isn't a git repo, the hooks will gracefully skip without breaking your workflow.

