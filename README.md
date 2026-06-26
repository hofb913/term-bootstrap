# macOS Terminal Bootstrap
## Release
- { 2026-06-24 } Initial Release
## About
The ‘bootstrap.sh’ script is used to initiate a full installation (or re-installation) of my macOS terminal and development environment.  
The bootstrap performs the following:
1. Installs the Xcode command-line tools
2. Installs & Updates Homebrew (macOS package manager)
3. Verifies SSH authentication to GitHub
4. Clones my .dotfiles from GitHub
5. Run the install.sh script to complete the installation.
## Prerequisites
- SSH authentication to GitHub
## To Run
```
/bin/zsh -c "$(curl -fsSL https://raw.githubusercontent.com/hofb913/term-bootstrap/main/bootstrap.sh)"
```
## Notes
- Xcode command-line tools and/or Homebrew will not be installed if already present on the target machine. Homebrew will be updated.
- If .dotfiles is already present, a `git pull` will be perforned instead of a `git clone`