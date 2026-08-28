# dotfiles

My configuration files for my MacBooks.


Dependencies:
- zsh
- ohmyzsh / p10k
- alacritty
- neovim
- tmux
- python3

running `./install.py` will symlink config files into their correct places. 

On a new machine, follow it with `./setup-python.sh`, which installs uv, a default CPython 3.13 providing `python` and `python3`, and `ruff` (nvim's format-on-save shells out to it). uv's managed interpreters reject `pip install`, so the writable global environment is a seeded venv at `~/.local/share/venvs/global` that `.zshrc` puts first on PATH — `pip install` lands there, with no activation needed. The script is idempotent. Per-project work should still use `uv sync` / `uv run` rather than that environment.

Global coding-agent guidelines live in `home/.cursor/rules/global.mdc` (the canonical file). `home/.claude/CLAUDE.md` and `home/.codex/AGENTS.md` are relative symlinks to it, so after `./install.py` the same principles are always in context for Cursor, Claude Code, and Codex.

Global agent skills follow the same pattern: canonical `SKILL.md` files live under `home/.cursor/skills/<name>/`, with relative symlinks under `home/.claude/skills/` (Claude Code) and `home/.agents/skills/` (Codex) so each tool discovers them.


The setup uses alacritty + tmux to manage terminal windows/panes, and there is seamless navigation between neovim panes and tmux panes using `ctrl+[hjkl]` ([base on vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator)). The remaining tmux hotkeys are setup to mimic the defaults of iTerm2 for window/pane/tab control, as that is what I had used previously.  
