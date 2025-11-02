#!/usr/bin/env bash
set -euo pipefail

echo "🚀 Bootstrapping macOS dev environment..."

# --- Helper ---
command_exists() { command -v "$1" >/dev/null 2>&1; }

# --- Step 1: Xcode Command Line Tools ---
if ! xcode-select -p &>/dev/null; then
  echo "🧰 Installing Xcode Command Line Tools..."
  xcode-select --install
  echo "➡️ Re-run this script after installation completes."
  exit 1
else
  echo "✅ Xcode Command Line Tools already installed."
fi

# --- Step 2: Homebrew ---
if ! command_exists brew; then
  echo "🍺 Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "✅ Homebrew already installed."
fi

# Ensure brew path (important for new Apple Silicon Macs)
eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null || /usr/local/bin/brew shellenv)"

# --- Step 3: Install packages from Brewfile ---
echo "📦 Installing packages from Brewfile..."
brew bundle --file="$(dirname "$0")/Brewfile"

# --- Step 4: Setup asdf ---
echo "⚙️ Setting up asdf..."
source "$(brew --prefix asdf)/libexec/asdf.sh"

plugins=(nodejs python ruby golang java)

for plugin in "${plugins[@]}"; do
  asdf plugin add "$plugin" || echo "Plugin $plugin already exists."
done

if [ -f "$HOME/Developer/mac-bootstrap/dotfiles/.tool-versions" ]; then
  echo "📄 Installing asdf language versions from ~/.tool-versions..."
  asdf install
else
  echo "⚠️ No ~/.tool-versions found. You can copy from this repo and run 'asdf install'."
fi

# --- Step 5: Setup dotfiles ---
# --- Link dotfiles ---
DOTFILES_DIR="$HOME/Developer/mac-bootstrap/dotfiles"

if [ -d "$DOTFILES_DIR" ]; then
  echo "🔗 Linking flat dotfiles from $DOTFILES_DIR..."
  stow -d "$DOTFILES_DIR" -t "$HOME" .
else
  echo "⚠️ No dotfiles folder found at $DOTFILES_DIR"
fi


# --- Step 6: Cleanup ---
brew cleanup
echo "✅ Bootstrap complete! 🎉"

