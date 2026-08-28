#!/usr/bin/env bash
# Python setup for a fresh machine. Idempotent; safe to re-run.
#
# uv owns the interpreters. Its managed builds are marked externally managed, so
# `pip install` into them fails by design. The writable global environment is a
# separate seeded venv, which `.zshrc` puts ahead of the uv shims on PATH.
set -euo pipefail

PYTHON_VERSION="3.13"
GLOBAL_VENV="${XDG_DATA_HOME:-$HOME/.local/share}/venvs/global"
# Tools the configs shell out to: nvim's conform.nvim runs `ruff` from PATH.
UV_TOOLS=(ruff)

if [[ -t 1 ]]; then
    bold=$'\e[1m' dim=$'\e[2m' green=$'\e[32m' yellow=$'\e[33m' reset=$'\e[0m'
else
    bold="" dim="" green="" yellow="" reset=""
fi

step() { printf '%s==>%s %s%s%s\n' "$green" "$reset" "$bold" "$1" "$reset"; }
info() { printf '    %s%s%s\n' "$dim" "$1" "$reset"; }
warn() { printf '%swarning:%s %s\n' "$yellow" "$reset" "$1" >&2; }

step "uv"
if command -v uv >/dev/null 2>&1; then
    info "present: $(uv --version)"
else
    curl -fsSL https://astral.sh/uv/install.sh | sh
    export PATH="$HOME/.local/bin:$PATH"
    hash -r
    if ! command -v uv >/dev/null 2>&1; then
        echo "uv install completed but uv is not on PATH" >&2
        exit 1
    fi
    info "installed: $(uv --version)"
fi

step "CPython $PYTHON_VERSION as the default interpreter"
# --default also writes the unversioned `python` and `python3` shims. It is still
# gated behind a preview feature, which uv warns about unless opted in by name.
uv python install "$PYTHON_VERSION" --default \
    --preview-features python-install-default
info "$(uv python find "$PYTHON_VERSION")"

step "writable global environment"
if [[ -x "$GLOBAL_VENV/bin/python" ]]; then
    info "present: $GLOBAL_VENV ($("$GLOBAL_VENV/bin/python" -V))"
else
    uv venv --seed --python "$PYTHON_VERSION" "$GLOBAL_VENV"
fi

step "tools"
for tool in "${UV_TOOLS[@]}"; do
    uv tool install "$tool"
done

step "verify"
resolved="$(command -v python || true)"
if [[ "$resolved" == "$GLOBAL_VENV/bin/python" ]]; then
    info "python -> $resolved ($(python -V 2>&1))"
    info "pip    -> $(command -v pip)"
else
    warn "\`python\` resolves to ${resolved:-nothing}, not $GLOBAL_VENV/bin/python.
    Run ./install.py to link .zshrc, then start a new shell (exec zsh).
    If it still differs, something later in PATH is shadowing it."
fi
