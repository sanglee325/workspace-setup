#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VUNDLE_DIR="${HOME}/.vim/bundle/Vundle.vim"
COLORS_SRC="${SCRIPT_DIR}/colors"
COLORS_DST="${HOME}/.vim/colors"
VIMRC_SRC="${SCRIPT_DIR}/.vimrc"
VIMRC_DST="${HOME}/.vimrc"
BASHRC="${HOME}/.bashrc"
TMUX_ALIAS='alias tmux="TERM=screen-256color-bce tmux"'
ADD_TMUX_ALIAS=false

usage() {
  cat <<USAGE
Usage: $(basename "$0") [--with-tmux-alias]

Options:
  --with-tmux-alias   Add tmux TERM alias to ~/.bashrc if missing.
  -h, --help          Show this help message.
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --with-tmux-alias)
      ADD_TMUX_ALIAS=true
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      usage
      exit 1
      ;;
  esac
done

mkdir -p "${HOME}/.vim/bundle"
mkdir -p "${COLORS_DST}"

if [[ -d "${VUNDLE_DIR}" ]]; then
  echo "Vundle already exists at ${VUNDLE_DIR}; skipping clone."
else
  echo "Cloning Vundle into ${VUNDLE_DIR}..."
  git clone https://github.com/VundleVim/Vundle.vim.git "${VUNDLE_DIR}"
fi

if [[ -d "${COLORS_SRC}" ]]; then
  echo "Copying colors to ${COLORS_DST}..."
  cp -R "${COLORS_SRC}/." "${COLORS_DST}/"
else
  echo "No colors directory found at ${COLORS_SRC}; skipping colors install."
fi

echo "Copying ${VIMRC_SRC} to ${VIMRC_DST}..."
cp "${VIMRC_SRC}" "${VIMRC_DST}"

if command -v vim >/dev/null 2>&1; then
  echo "Installing Vim plugins via Vundle..."
  if vim +PluginInstall +qall >/dev/null 2>&1; then
    echo "Vim plugins installed."
  else
    echo "Automatic plugin install failed; open ~/.vimrc in Vim and run :PluginInstall manually." >&2
  fi
else
  echo "vim not found; skip plugin installation. Run :PluginInstall later from Vim." >&2
fi

if [[ "${ADD_TMUX_ALIAS}" == true ]]; then
  touch "${BASHRC}"
  if grep -Fq "${TMUX_ALIAS}" "${BASHRC}"; then
    echo "tmux alias already present in ${BASHRC}; skipping."
  else
    echo "Adding tmux alias to ${BASHRC}..."
    printf '\n%s\n' "${TMUX_ALIAS}" >> "${BASHRC}"
    echo "Added tmux alias. Run: source ${BASHRC}"
  fi
fi

echo "Setup complete."
