## INSTALLING EMACS

```sh

# documentation here
# https://github.com/d12frosted/homebrew-emacs-plus?tab=readme-ov-file

brew tap d12frosted/emacs-plus
brew install emacs-plus@31 --with-xwidgets --with-savchenkovaleriy-big-sur-3d-icon

```

alternative way of compiling straight from emacs on apple silicon

```


git clone https://git.savannah.gnu.org/git/emacs.git
cd emacs
make clean
make cleandist
./autogen.sh

./configure \
  --with-native-compilation \
  --with-tree-sitter \
  --with-json \
  --with-gnutls \
  --with-rsvg \
  --with-modules \
  --with-imagemagick=no \
  --with-pgtk \
  --enable-mac-app

make -j$(sysctl -n hw.logicalcpu)
make install
```

## message from build

```
Emacs.app and Emacs Client.app were installed to:
  /opt/homebrew/opt/emacs-plus@31

To link the application to default Homebrew App location:
  osascript -e 'tell application "Finder" to make alias file to posix file "/opt/homebrew/opt/emacs-plus@31/Emacs.app" at posix file "/Applications" with properties {name:"Emacs.app"}'
  osascript -e 'tell application "Finder" to make alias file to posix file "/opt/homebrew/opt/emacs-plus@31/Emacs Client.app" at posix file "/Applications" with properties {name:"Emacs Client.app"}'

Your PATH value was injected into Emacs.app via a wrapper script.
This solves the issue with macOS Sequoia ignoring LSEnvironment in Info.plist.

To disable PATH injection, set EMACS_PLUS_NO_PATH_INJECTION before running Emacs:
  export EMACS_PLUS_NO_PATH_INJECTION=1

Report any issues to https://github.com/d12frosted/homebrew-emacs-plus

To start d12frosted/emacs-plus/emacs-plus@31 now and restart at login:
  brew services start d12frosted/emacs-plus/emacs-plus@31
Or, if you don't want/need a background service you can just run:
  /opt/homebrew/opt/emacs-plus@31/bin/emacs --fg-daemon
󰀵   󰋜 ~/.emacs.d/themes on main✘1 !4 ?16  15m4s
╰─❯

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
