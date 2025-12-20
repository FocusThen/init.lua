# Git Hooks for Auto-Commit

This directory contains git hooks that automatically commit and push changes to the parent `dev-env` repository when you commit/push in this nvim config **submodule**.

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

- **post-commit**: Automatically commits the submodule reference update to the parent `dev-env` repo after each commit here
- **pre-push**: Automatically pushes the parent `dev-env` repo before pushing this submodule

## How it works

Since this is a **submodule**, the parent repo tracks this submodule by its commit hash reference, not the actual files. When you commit in this submodule:

1. The `post-commit` hook detects the new commit
2. It navigates to the parent `dev-env` repository
3. It stages the submodule reference update (`git add .config/nvim`)
4. It commits the submodule reference change with a message referencing your commit

If the parent repo doesn't exist or isn't a git repo, the hooks will gracefully skip without breaking your workflow.

