#!/bin/bash

log() {
  printf '\n%s - %s\n\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$*"
}

log "$0"

# Disable prompting to use new exteral drives as Time Machine volume
# defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

# Hide external hard drives on desktop
# defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false

# Hide hard drives on desktop
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false

# Hide removable media hard drives on desktop
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool false

# Hide mounted servers on desktop
defaults write com.apple.finder ShowMountedServersOnDesktop -bool false

# Hide icons on desktop
# defaults write com.apple.finder CreateDesktop -bool false

# Avoid creating .DS_Store files on network volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# Group windows by application in Mission Control
defaults write com.apple.dock expose-group-apps -bool true

# Show path bar
defaults write com.apple.finder ShowPathbar -bool true

# Show hidden files inside the finder
defaults write com.apple.finder "AppleShowAllFiles" -bool true

# Show Status Bar
defaults write com.apple.finder "ShowStatusBar" -bool true

# Do not show warning when changing the file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Set search scope to current folder
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
defaults write com.apple.screencapture type -string "png"

# Set fast key repeat rate (smaller number = faster repeat)
defaults write -g KeyRepeat -int 1
#
## Set short delay until key repeat (smaller number = shorter delay)
defaults write -g InitialKeyRepeat -int 10

# Disable Finder animations
# defaults write com.apple.finder DisableAllAnimations -bool true
killall Finder

# Disable Dock autohide delay and animation
# defaults write com.apple.Dock autohide-delay -float 0
# defaults write com.apple.dock autohide-time-modifier -int 0

# Disable Slow Keys accessibility feature (can cause delay)
defaults write com.apple.universalaccess slowKeys -bool false

# Set weekly software update checks
# defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 7

# Set Desktop as the default location for new Finder windows
# For other paths, use `PfLo` and `file:///full/path/here/`
defaults write com.apple.finder NewWindowTarget -string "PfHm"
defaults write com.apple.finder NewWindowTargetPath -string "file:///${HOME}/"

# Enable the Develop menu and the Web Inspector in Safari
# defaults write com.apple.Safari IncludeDevelopMenu -bool true
# defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
# defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true

# Add a context menu item for showing the Web Inspector in web views
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

# Have the Dock show only active apps
# defaults write com.apple.dock static-only -bool true
# defaults write com.apple.dock static-only -bool false

# Set Dock autohide
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock largesize -float 74
defaults write com.apple.dock "minimize-to-application" -int 1
defaults write com.apple.dock tilesize -float 54

# finder, default to list view
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# save screenshots to desktop
mkdir -p ~/Desktop/screenshots
defaults write com.apple.screencapture location ~/Desktop/screenshots

# Secondary click in external mouse
# defaults write com.apple.AppleMultitouchMouse MouseButtonMode -string "TwoButton"

# trackpad tap-to-click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true

# safari full url
defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true

# Disable startup sound
sudo nvram SystemAudioVolume=%01

killall Dock
