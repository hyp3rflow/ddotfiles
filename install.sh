#!/bin/bash

set -eufo pipefail

echo ""
echo "🤚  This script will setup .dotfiles for you."
read -n 1 -r -s -p $'    Press any key to continue or Ctrl+C to abort...\n\n'

# Install Homebrew
command -v brew >/dev/null 2>&1 || \
  (echo '🍺  Installing Homebrew' && git clone https://github.com/Homebrew/brew homebrew && eval "$(homebrew/bin/brew shellenv)" && brew update --force --quiet && chmod -R go-w "$(brew --prefix)/share/zsh")

# Install Oh My Zsh
if [ ! -f ~/.oh-my-zsh/oh-my-zsh.sh ]; then
  (echo '💰  Installing oh-my-zsh' && yes | sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)")
fi

# Install chezmoi
command -v chezmoi >/dev/null 2>&1 || \
  (echo '👊  Installing chezmoi' && brew install chezmoi)

if [ -d "$HOME/.local/share/chezmoi/.git" ]; then
  echo "🚸  chezmoi already initialized"
  echo "    Reinitialize with: 'chezmoi init https://github.com/hyp3rflow/ddotfiles.git'"
else
  echo "🚀  Initialize dotfiles with:"
  echo "    chezmoi init https://github.com/hyp3rflow/ddotfiles.git"
  chezmoi init https://github.com/hyp3rflow/ddotfiles.git
fi

echo ""
echo "🤚  This script will install dependencies from homebrew."
read -n 1 -r -s -p $'    Press any key to continue or Ctrl+C to abort...\n\n'

# Install asdf
command -v chezmoi >/dev/null 2>&1 || \
  (echo '👊  Installing chezmoi' && brew install asdf)

# Install asdf plugins
asdf plugin-add java https://github.com/halcyon/asdf-java.git
asdf plugin-add deno https://github.com/asdf-community/asdf-deno.git

# Install jdk
command -v java >/dev/null 2>&1 || \
  (echo '👊  Installing deno' && asdf install java graalvm-community-21.0.2 && asdf global java graalvm-community-21.0.2)

# Install deno
command -v deno >/dev/null 2>&1 || \
  (echo '👊  Installing deno' && asdf install deno latest && asdf global deno latest)

# Install coursier
command -v chezmoi >/dev/null 2>&1 || \
  (echo '👊  Installing coursier' && brew install couriser && cs setup)

echo ""
echo "Done."