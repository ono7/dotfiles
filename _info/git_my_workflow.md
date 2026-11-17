# Git Feature Branch Workflow

combine commits

```bash
# if the changes have been commited but not pushed upstream
# list all safe unpushe commits, no files
git log @{u}..HEAD --oneline

# compare origin @{u} with HEAD shows the commits waiting to be pushed w/files
git log @{u}..HEAD --stat

# combine the last 2
git reset --soft HEAD~2
git commit -m "feat(gitcommit): add conventional commit snippets and scope helper"

# resets all commits without needing to count
git reset --soft @{u}
```

## 1. Starting a New Feature Branch

Cut branches directly from `origin/develop` so you never need to maintain or
switch to local `develop` or `main` branches.

```bash
# first make sure this is set if running on an unmanaged system
# this will automatically create remote branches when doing git push
# simple will make sure we dont accidentally push or pull from/to the wrong repo
git config --global push.autoSetupRemote true
git config --global branch.autoSetupMerge simple

# Download latest remote develop commits without touching working files
git fetch origin develop

# Create and switch to a new branch starting at origin/develop
git switch -c feat/<name> origin/develop

# Safely delete redundant local develop and main pointers
git branch -d develop main

# create new feature branch to work off from origin/develop (or any other branch)
git fetch origin develop
git switch -c feat/<name> origin/develop

# Publish & sync your feature branch
git push   # creates origin/feat/<name> & sets upstream automatically
git pull   # pulls from origin/feat/<name>

# Pull updates from develop into your feature branch (if needed mid-work):
git fetch origin develop
git rebase origin/develop   # or: git merge origin/develop

# lean up after PR merge:
git fetch origin develop
git switch -c develop origin/develop   # or: git switch develop && git pull
git branch -d feat/<name>
```

---

## 2. Syncing Upstream Changes into Your Branch

Pull new commits from `origin/develop` into your active feature branch without switching branches.

```bash
# Update your local origin/develop tracking pointer
git fetch origin develop

# Merge upstream develop (matches team convention, opens nvim for message)
git merge origin/develop

# Merge upstream develop using the default commit message (skips nvim)
git merge --no-edit origin/develop

# Replay local commits on top of origin/develop (linear history, best before pushing)
git rebase --autostash origin/develop

# Re-anchor your last <N> unpushed commits onto origin/develop
git rebase --onto origin/develop HEAD~<N>

```

---

## 3. Inspecting & Verifying State

Verify incoming merge changes, preview your PR diff, or check where a branch originated.

```bash
# Show current branch, tracking status, and modified/untracked files
git status -sb

# List files pulled in by the merge you just ran
git diff --stat ORIG_HEAD..HEAD

# List individual commits brought in from origin/develop
git log --no-merges ORIG_HEAD..HEAD

# Preview the exact net file diff your PR will show against origin/develop
git diff --stat origin/develop...HEAD

# Check the exact commit or ref a branch was originally created from
git reflog show --date=iso <branch> | tail -n 1 # tail -n 1 shows the last @{0}
# with the commit hash from @{0} we can find out what branches have this commit
# in them to narrow the branch this originated from
git branch -a --contains ea6f3d1

# Check recent branch switches if a branch was created from HEAD
git reflog show --date=iso HEAD -n 5

# if this new branch was created from HEAD meaning we did not specify whichbranch to track from
# git checkout -b feat/testing origin/develop (correct) git checkout -b feat/testing (bad) tracks whatever HEAD was at the time
git reflog | grep -B 2 -A 2 "feat/testing" # this will show what branch this was created from

```

---

## 4. Resolving Merge Conflicts in Neovim

When `git merge` or `git rebase` stops on a conflict, open `diffview.nvim` to
resolve hunks without creating temporary files on disk.

```bash
# Open Neovim with DiffviewOpen (groups conflicted files at the top)
git dv

```

Keybindings inside Diffview:

- `]x` / `[x` — Jump to next / previous conflict block
- `<leader>co` — Keep OURS (your current branch / `HEAD`)
- `<leader>ct` — Keep THEIRS (incoming branch / `origin/develop`)
- `<leader>cb` — Keep BASE (common ancestor)
- `<leader>ca` — Keep ALL (stack both versions to combine manually)
- `s` — Stage resolved file in the file panel after `:w`

```bash
# Finalize conflict resolution after git merge
git commit --no-edit

# Finalize conflict resolution after git rebase
git rebase --continue

```

---

## 5. Cleaning Up & Pushing

Collapse unpushed commits, push to `origin` (`push.autoSetupRemote = true` sets tracking automatically), and remove merged branches.

```bash
# Collapse last <N> unpushed commits into staging to combine into one commit
git reset --soft HEAD~<N>

# Update the message or staged contents of your last unpushed commit
git commit --amend -m "<msg>"

# Push branch to origin/<branch> and set upstream tracking
git push

# Safely update remote branch after a local rebase
git push --force-with-lease

# Delete local feature branch after PR merges into develop
git branch -d <branch>

```
