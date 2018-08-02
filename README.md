# dotfiles

Make sure to edit personalinfo and look at all the scripts beforehand if you'd like to use this on your own machine.

Open a terminal and type `sudo -v` to get the password prompt out of the way, and then copy and paste the following into the terminal:
```sh
# Keep-alive: update existing `sudo` time stamp until finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Make sure we're home
cd ~

# Install homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" </dev/null

# get git
brew install git

# get dotfiles
git clone https://github.com/KevinRickard/dotfiles.git
cd dotfiles
source setup.sh

```
