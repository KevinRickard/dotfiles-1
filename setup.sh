###############################################################################
echo "Dotfiles and Linking"
###############################################################################

# Stop last login message upon terminal open
touch ~/.hushlogin

# Create symlinks
files=".bash_profile .bashrc .gitconfig"
for file in $files; do
  ln -s ~/dotfiles/$file ~/$file
done

# vim symlinks
ln -s ~/dotfiles/vim/.vimrc ~/.vimrc
ln -s ~/dotfiles/vim ~/.vim

echo "Initialize bashrc"
source ~/.bashrc

###############################################################################
echo "Homebrew Config"
###############################################################################

brew analytics off
brew tap caskroom/cask

echo "Install GNU core utilities" # (those that come with macOS are outdated).
# Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
brew install coreutils
export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"

echo "Install some other useful utilities like sponge"
brew install moreutils

echo "Install GNU find, locate, updatedb, and xargs, g-prefixed."
brew install findutils

echo "Install Bash 4"
brew install bash
# Switch to using brew-installed bash as default shell
# TODO: fix password prompt
if ! fgrep -q '/usr/local/bin/bash' /etc/shells; then
  echo '/usr/local/bin/bash' | sudo tee -a /etc/shells;
  chsh -s /usr/local/bin/bash;
fi;

echo "Install lots of stuff"
brew install ssh-copy-id
brew install tree
brew install webkit2png
brew install vim --with-override-system-vi
brew install wget --with-iri
brew install gnu-sed --with-default-names
brew install openssh
brew install the_silver_searcher
brew install grep
brew install xpdf
brew install nmap
brew install ack
brew install p7zip
brew install rename
#?? brew install gdb
#?? brew install rsync

# TODO: fix password prompt for first cask
brew cask install keepassxc
brew cask install sublime-text

echo "Install languages and build tools"
brew cask install homebrew/cask-versions/java8
brew install scala
brew install maven
brew install gradle

echo "Install android stuff"
brew cask install android-sdk
sdkmanager --update
brew cask install android-studio

echo "Install pycharm"
brew cask install pycharm

# TODO: set intellij scala home to /usr/local/opt/scala/idea?
brew cask install intellij-idea-ce

###############################################################################
echo "Install Google Fonts"
###############################################################################

# Install Google Fonts
GOOGLE_FONTS_DIR='/Library/Fonts/Google Fonts'
mkdir -p "$GOOGLE_FONTS_DIR"
if [ ! -d "$GOOGLE_FONTS_DIR"/.git ]; then
  git clone --depth 1 https://github.com/google/fonts.git "$GOOGLE_FONTS_DIR"
fi

# Schedule Google Fonts Updates; Once a month
read -d '' cron_entry <<-EOF
0 0 1 * * sh -c 'cd "${GOOGLE_FONTS_DIR}" && git fetch -fp --depth 1 && \
git reset --hard @{upstream} && git clean -dfx' &>/dev/null
EOF
if ! crontab -l | fgrep "$cron_entry" >/dev/null; then
  (crontab -l 2>/dev/null; echo "$cron_entry") | \
    crontab -
fi

###############################################################################
echo "Configure Defaults"
###############################################################################

osascript -e 'tell application "System Preferences" to quit'

# TODO: Increase sound quality for Bluetooth headphones/headsets
# Reference: https://www.reddit.com/r/apple/comments/5rfdj6/pro_tip_significantly_improve_bluetooth_audio/
# defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40

# Enable subpixel font rendering on non-Apple LCDs
# Reference: https://github.com/kevinSuttle/macOS-Defaults/issues/17#issuecomment-266633501
defaults write NSGlobalDomain AppleFontSmoothing -int 1

# Enable HiDPI display modes (requires restart)
sudo defaults write /Library/Preferences/com.apple.windowserver DisplayResolutionEnabled -bool true

# Animations:
# Don’t animate opening applications from the Dock
defaults write com.apple.dock launchanim -bool false

# Disable the over-the-top focus ring animation
defaults write NSGlobalDomain NSUseAnimatedFocusRing -bool false

# TODO: Speed up Mission Control animations (interaction with totalspaces2?)
# defaults write com.apple.dock expose-animation-duration -float 0.1

# Stop expose grouping by app
defaults write com.apple.dock expose-group-apps -bool false

# Finder: disable window animations and Get Info animations
# defaults write com.apple.finder DisableAllAnimations -bool true

#"Preventing Time Machine from prompting to use new hard drives as backup volume"
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

#"Setting screenshots location"
defaults write com.apple.screencapture location -string "$HOME/Screenshots"

# TODO: Disable the Desktop
defaults write com.apple.finder CreateDesktop -bool false

# Avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Hide icons for hard drives, servers, and removable media on the desktop
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowMountedServersOnDesktop -bool false
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool false

# Disk image verification
defaults write com.apple.frameworks.diskimages skip-verify        -bool true
defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true

# TODO: finish mouse stuff? Related to totalspaces2
# Trackpad: enable tap to click for this user and for the login screen
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Trackpad three finger drag
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool true
defaults write com.apple.AppleMultitouchTrackpad Dragging -bool false
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Dragging -bool false

# TODO: Make Dock icons of hidden applications translucent
defaults write com.apple.dock showhidden -bool true

defaults write com.apple.dock tilesize -int 40
defaults write com.apple.dock mineffect -string "scale"
defaults write com.apple.dock show-process-indicators -bool true

# Don’t automatically rearrange Spaces based on most recent use
defaults write com.apple.dock mru-spaces -bool false

# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# Expand print panel by default
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# Automatically quit printer app once the print jobs complete
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

# Disable the “Are you sure you want to open this application?” dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false

# Keyboard speed
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 25

# TODO: Disable press-and-hold for keys in favor of key repeat
# defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Finder: show hidden files by default
defaults write com.apple.finder AppleShowAllFiles -bool true

# Finder > Preferences > Show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true



# Set Help Viewer windows to non-floating mode
defaults write com.apple.helpviewer DevMode -bool true

# Finder: allow quitting via ⌘ + Q; doing so will also hide desktop icons
defaults write com.apple.finder QuitMenuItem -bool true

# New window target
# Computer     : `PfCm`
# Volume       : `PfVo`
# $HOME        : `PfHm`
# Desktop      : `PfDe`
# Documents    : `PfDo`
# All My Files : `PfAF`
# Other…       : `PfLo`
defaults write com.apple.finder NewWindowTarget -string 'PfHm'

# Arrange by
# Kind, Name, Application, Date Last Opened,
# Date Added, Date Modified, Date Created, Size, Tags, None
defaults write com.apple.finder FXPreferredGroupBy -string "Name"

# Finder > Preferences > Don't show warning before changing an extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Finder > View > As List
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Finder: Show Bottom Path Bar
defaults write com.apple.finder ShowPathbar -bool true

# Search scope
# This Mac       : `SCev`
# Current Folder : `SCcf`
# Previous Scope : `SCsp`
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Automatically open a new Finder window when a volume is mounted
defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true
defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true

# Expand the following File Info panes:
# “General”, “Open with”, and “Sharing & Permissions”
defaults write com.apple.finder FXInfoPanesExpanded -dict \
	General -bool true \
	OpenWith -bool true \
	Privileges -bool true

# Prevent Photos from opening automatically when devices are plugged in
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true

# Disable shadow in screenshots
defaults write com.apple.screencapture disable-shadow -bool true

# Completely Disable Dashboard
defaults write com.apple.dashboard mcx-disabled -bool true

# Don’t show Dashboard as a Space
defaults write com.apple.dock dashboard-in-overlay -bool true

# Text selection in Quick Look
defaults write com.apple.finder QLEnableTextSelection -bool true

#"Adding a context menu item for showing the Web Inspector in web views"
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

# Show the /Volumes folder
sudo chflags nohidden /Volumes

defaults write net.sourceforge.skim-app.skim SKDisableTableToolTips 1

echo "Defaults done. Note that some of these changes require a logout/restart to take effect."

###############################################################################
echo "Install terminal theme"
###############################################################################

# Will open a new terminal window when this part is executed; Just ignore it.
open MyPro.terminal
defaults write com.apple.terminal "Default Window Settings" "MyPro"
