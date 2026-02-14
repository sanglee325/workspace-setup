# workspace-setup

Personal environment setup files for Vim and Markdown preview styling.

## Contents

- `vimrc/.vimrc`: Vim settings and plugin declarations (Vundle-based).
- `vimrc/colors/`: Vim color schemes copied to `~/.vim/colors`.
- `vimrc/setup.sh`: Installs Vundle, copies vim config/colors, and installs plugins.
- `markdown-css/`: CSS files for Markdown preview themes (GitHub/GitLab style).

## Quick Start

Run the setup script:

```bash
./vimrc/setup.sh
```

Optional: also add a tmux TERM alias to `~/.bashrc`:

```bash
./vimrc/setup.sh --with-tmux-alias
```

## What `setup.sh` Does

1. Creates `~/.vim/bundle` and `~/.vim/colors` if missing.
2. Clones Vundle to `~/.vim/bundle/Vundle.vim` (if not already installed).
3. Copies all files from `vimrc/colors/` to `~/.vim/colors/`.
4. Copies `vimrc/.vimrc` to `~/.vimrc`.
5. Runs `vim +PluginInstall +qall` when `vim` is available.
6. Optionally appends:

```bash
alias tmux="TERM=screen-256color-bce tmux"
```

to `~/.bashrc` when `--with-tmux-alias` is used.

## Notes

- If plugin installation fails, open Vim and run `:PluginInstall` manually.
- The current default colorscheme in `vimrc/.vimrc` is `diablo3`.
- Markdown CSS files can be used in editors/extensions that support custom Markdown stylesheets.
