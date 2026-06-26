##!usr/bin/env zsh

# bootstrap.sh
#   Install / Re-install macOS Terminal and Dev environment

# Config

DOTFILES_REPO="git@github.com/hofb913/dotfiles.git"
DOTFILES_DIR="$HOME/.dotfiles"
BREW_PREFIX="/opt/homebrew"

# ---------------------------------
# Helpers
# ---------------------------------

log() {
    printf "\n\033[1;34m==> %s\033[0m\n" "$1"
}

error() {
    printf "\n\033[1;31m[ERROR] %s\033[0m\n" "$1"
}

exists() {
    command -v "$1" >/dev/null 2>&1
}

# ---------------------------------
# Intall Xcode Commnand Line Tools 
# ---------------------------------

install_xcode_cli() {
    if xcode-select -p &>/dev/null; then
        log "XCode Command Line Tools already installed"
    else 
        log "Installing Xcode Command Line Tools"
        xcode-select --install || install_homebrew
        
        log "Waiting for install..."
        until xcode-select -p &>/dev/null; do 
            sleep 5
        done 
    fi 
}

# ---------------------------------
# Install Homebrew 
# ---------------------------------

install_homebrew() {
  if exists brew; then
    log "Homebrew already installed"
  else
    log "Installing Homebrew"
    NONINTERACTIVE=1 /bin/bash -c \
      "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi

  # Ensure brew is usable immediately
  if [[ -d "/opt/homebrew" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi

  log "Updating Homebrew"
  brew update
}

# ---------------------------------
# Clone Dotfiles 
# ---------------------------------

check_ssh(){
    log "Checking SSH access to GitHub"

    if ! ssh -T git@github.com &>/dev/null; then
        log "SSH authentication OK"
    else 
       error "SSH to GitHub not configured.
        Please run:
            ssh-keygen
            and add your key to GitHub"
    fi 
}

# ---------------------------------
# Clone Dotfiles 
# ---------------------------------

clone_dotfiles() {
    if [[ -d "$DOTFILES_DIR/.git" ]]; then
        log "Dotfile already exist -> pulling latest"
        git -C "$DOTFILES_DIR" pull --rebase
    else 
        log "Cloning dotfiles repo"
        git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
    fi 
}

# ---------------------------------
# Run Install 
# ---------------------------------

run_install() {
    log "Running main installer"

    cd "$DOTFILES_DIR"

    if [[ -f "install.sh" ]]; then
        zsh install.sh 
    else
        error "install.sh not found in dotfiles repo"
    fi 
}

# ---------------------------------
# Main 
# ---------------------------------

main() {
    log "Starting bootstrap"

    install_xcode_cli
    install_homebrew
    check_ssh
    clone_dotfiles
    run_install

    log "✅ Bootstrap complete!"
}

main "$@"
