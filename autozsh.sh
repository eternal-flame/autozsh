#!/bin/bash

set -e

# Function: Check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Determine package manager
if command_exists apt; then
    PM_INSTALL="sudo apt install -y"
elif command_exists yum; then
    PM_INSTALL="sudo yum install -y"
elif command_exists pacman; then
    PM_INSTALL="sudo pacman -S --noconfirm"
else
    echo "❌ Unsupported package manager. Exiting."
    exit 1
fi

echo "✅ Package manager detected. Proceeding with installation..."

# Ensure required tools are available
for cmd in git zsh; do
    if ! command_exists "$cmd"; then
        echo "🔧 Installing missing dependency: $cmd"
        $PM_INSTALL "$cmd"
    fi
done

# Install Powerline fonts (package name varies)
echo "🔤 Installing Powerline fonts..."
if command_exists apt; then
    $PM_INSTALL powerline fonts-powerline
elif command_exists yum; then
    $PM_INSTALL powerline-fonts
elif command_exists pacman; then
    $PM_INSTALL powerline powerline-fonts
fi

# Install Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "🎉 Installing Oh My Zsh..."
    git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
else
    echo "📦 Oh My Zsh is already installed. Skipping..."
fi

# Copy .zshrc if present
if [ -f .zshrc ]; then
    cp .zshrc "$HOME/"
    echo "✅ .zshrc copied to home directory."
else
    echo "⚠️ .zshrc not found in current directory. Skipping..."
fi

# Install plugins
ZSH_CUSTOM=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}
echo "🔌 Installing Zsh plugins..."
git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"

# Change default shell to Zsh
if command_exists chsh; then
    CURRENT_SHELL=$(getent passwd "$USER" | cut -d: -f7)
    if [[ "$CURRENT_SHELL" != */zsh ]]; then
        echo "🛠 Changing default shell to Zsh..."
        chsh -s "$(command -v zsh)"
    else
        echo "✅ Zsh is already your default shell."
    fi
else
    echo "⚠️ 'chsh' not found. Cannot set default shell automatically."
fi

# Copy .tmux.conf if available
if [ -f .tmux.conf ]; then
    cp .tmux.conf "$HOME/"
    echo "✅ .tmux.conf copied to home directory."
else
    echo "⚠️ .tmux.conf not found. Skipping..."
fi

# Prompt re-login via su
echo -e "\n🔁 Re-logging into the user session to apply changes..."
exec su - "$USER"
