## stashing and using stashes

`get stash -u -m 'stashing files'` - stash files that are not tracked and changes

`git stash list`

`git stash show -u stash@{0}` - view untracked
`git stash show -p -u stash@{0}` - view untracked and code changes

`git stash apply stash@{0}` - apply changes and keep stash
`git stash pop stash@{0}` - apply changes and delete stash

`git checkout stash@{0} -- /pat/to/file.py` - checkout a file from the stash
