#!/usr/bin/env bash
set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

if ! command -v brew >/dev/null 2>&1; then
    echo "Homebrew not found. Installing..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "Homebrew already installed"
fi

eval "$(/opt/homebrew/bin/brew shellenv)"

if ! command -v zsh >/dev/null 2>&1; then
    echo "zsh not found. Installing via Homebrew..."
    brew install zsh
else
    echo "zsh is already installed"
fi

if ! grep -q "$(which zsh)" /etc/shells; then
    echo "Adding zsh to /etc/shells"
    echo "$(which zsh)" | sudo tee -a /etc/shells
fi

chsh -s "$(which zsh)"

echo "Installing packages from Brewfile"
brew bundle --file="$DOTFILES_DIR/Brewfile"


echo "Linking fish configs"
mkdir -p "$HOME/.config/fish"
ln -sf "$DOTFILES_DIR/fish/config.fish" "$HOME/.config/fish/config.fish"
ln -sf "$DOTFILES_DIR/fish/fish_variables" "$HOME/.config/fish/fish_variables"

if [ -d "$DOTFILES_DIR/fish/functions" ]; then
    ln -sf "$DOTFILES_DIR/fish/functions" "$HOME/.config/fish/functions"
fi


echo "Linking zsh configs"
if [ -f "$DOTFILES_DIR/zsh/.zshrc" ]; then
    ln -sf "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"
fi

echo "Dotfiles installation complete!"

echo "Installing pokego"

if ! command -v pokego >/dev/null 2>&1; then
    echo "pokego not found. Cloning and building..."
    
    POKEGO_DIR="$DOTFILES_DIR/external/pokego"
    mkdir -p "$DOTFILES_DIR/external"

    if [ ! -d "$POKEGO_DIR" ]; then
        git clone https://github.com/rubiin/pokego.git "$POKEGO_DIR"
    else
        echo "pokego repository already exists. Pulling latest changes..."
        cd "$POKEGO_DIR" && git pull
    fi

    cd "$POKEGO_DIR"
    just build

    POKEGO_BIN="$POKEGO_DIR/bin"
    mkdir -p "$HOME/.local/bin"
    cp "$POKEGO_BIN/pokego" "$HOME/.local/bin/pokego"
    export PATH="$HOME/.local/bin:$PATH"

    echo "pokego installed"
else
    echo "pokego already installed"
fi

