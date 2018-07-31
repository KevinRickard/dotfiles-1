# dotfiles

Make sure to edit personalinfo if you'd like to use this on your own machine.

Copy/paste the following into a text file named start.sh:
```sh
cd ~

# Ask for the administrator password upfront
sudo -v
# Keep-alive: update existing `sudo` time stamp until finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Install Xcode Command Line Tools
if ! $(xcode-select -p &>/dev/null); then
  xcode-select --install &>/dev/null
  # Wait until the Xcode Command Line Tools are installed
  until $(xcode-select -p &>/dev/null); do
    sleep 5
  done
fi
# Accept the Xcode/iOS license agreement
if ! $(sudo xcodebuild -license status); then
  sudo xcodebuild -license accept
fi

# Install homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" </dev/null

# get git
brew install git

# git dotfiles
git clone https://github.com/KevinRickard/dotfiles.git
cd dotfiles
source setup.sh

```

Then run:
```sh
chmod +x start.sh
source start.sh
```