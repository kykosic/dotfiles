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


The setup uses alacritty + tmux to manage terminal windows/panes, and there is seamless navigation between neovim panes and tmux panes using `ctrl+[hjkl]` ([base on vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator)). The remaining tmux hotkeys are setup to mimic the defaults of iTerm2 for window/pane/tab control, as that is what I had used previously.  
