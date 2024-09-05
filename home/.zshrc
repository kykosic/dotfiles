# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Fix colors
export TERM=alacritty

# oh-my-zsh / p10k
export ZSH="$HOME/.oh-my-zsh"
ZSH_DISABLE_COMPFIX=true
CASE_SENSITIVE="true"
HIST_STAMPS="yyyy-mm-dd"
ZSH_THEME="powerlevel10k/powerlevel10k"
source $ZSH/oh-my-zsh.sh

# ECR Login
alias ecr-login='eval $\(aws ecr get-login --no-include-email --region us-east-1 \)'

# Brew
export HOMEBREW_NO_AUTO_UPDATE=1
if [[ `uname -m` = "arm64" ]]; then
    export PATH="/opt/homebrew/bin:$PATH"
elif [[ `uname -m` = "x86_64" ]]; then
    export PATH="/usr/local/Homebrew/bin:$PATH"
fi
eval $(brew shellenv)

# Misc
alias pypath='export PYTHONPATH=$(pwd):$PYTHONPATH'
alias kill-tmux='tmux kill-session -a'
alias source-tmux='tmux source-file ~/.tmux.conf'
alias colima-start='colima start --cpu 4 --memory 8 --arch x86_64'
alias flush-dns='sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder'

# git
alias gc='f() { git checkout "$@" }; f'
alias gbd='f() { git branch -D "$@" }; f'
alias gitsub="git submodule update --init --recursive"

# cargo
alias ck='clear; cargo check --all-features --all-targets'
alias clippy='clear; cargo clippy --all-features --all-targets'

# Docker
export DOCKER_BUILDKIT=1

# Kubernetes
alias k=kubectl
alias kc="kubectl config current-context"
alias kctx="kubectl config use-context"
alias kns='f() { kubectl config set-context --current --namespace="$1" }; f'
export KUBE_EDITOR=nvim
# source <(kubectl completion zsh)

# Terraform
alias tf=terraform

# Pulumi
alias p=pulumi

# Rust
export PATH="$HOME/.cargo/bin:$PATH"

# Python
export PYTHONUNBUFFERED=1

# Keep separate shell histories for each terminal
unsetopt inc_append_history
unsetopt share_history
unsetopt autocd

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# vim
export EDITOR="nvim"
alias vi='PYTHONPATH=$(pwd):$PYTHONPATH nvim'

# Fix screen orientation
# alias fixscreen='displayplacer ls'

# Private configs
source $HOME/.private.zsh

# Swap architectures
function swap {
  if [[ `uname -m` == 'arm64' ]]; then
    arch -x86_64 zsh
  elif [[ `uname -m` == 'x86_64' ]]; then
    # We always start in arm64
    exit
  fi
}

if [ -e "$HOME/.config/PERSONAL" ]; then
    # >>> conda initialize >>>
    # !! Contents within this block are managed by 'conda init' !!
    __conda_setup="$("$HOME/miniconda3/bin/conda" 'shell.zsh' 'hook' 2> /dev/null)"
    if [ $? -eq 0 ]; then
        eval "$__conda_setup"
    else
        if [ -f "$HOME/miniconda3/etc/profile.d/conda.sh" ]; then
            . "$HOME/miniconda3/etc/profile.d/conda.sh"
        else
            export PATH="$HOME/miniconda3/bin:$PATH"
        fi
    fi
    unset __conda_setup
    # <<< conda initialize <<<
    conda activate dev
fi 

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
