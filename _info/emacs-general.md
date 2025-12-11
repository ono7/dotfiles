## INSTALLING EMACS

```sh

# documentation here
# https://github.com/d12frosted/homebrew-emacs-plus?tab=readme-ov-file

brew tap d12frosted/emacs-plus
brew install emacs-plus@31 --with-xwidgets --with-savchenkovaleriy-big-sur-3d-icon

```

## colors

green status bar color and high lights #B1D631

black status bar clor preffered $444444

## kill current buffer

`C-x k`

## help

search for function help

`C-h w`

# get current keybindings for current window

`C-h b`

## when things slow down, remove all packages and reinstall them

`cd ~/.emacs.d/elpa`
`rm -rf *`

this also helps is emacs gets hung up due to a bad or incompatible package
also good to remove all these from time to time as things slow down

## help

`C-h i`

## upgrade packages in packages buffer (package-list-packages)

    `update all installed packages with U x in the *Packages* buffer`
