# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt autocd extendedglob notify
# End of lines configured by zsh-newuser-install

DISABLE_AUTO_UPDATE="true"
eval "$(zoxide init zsh)"

################################
### Aliases                  ###
################################

# NixOS
alias nixup='sudo nixos-rebuild switch --flake "/home/willow/nixos/#nixos"'
#alias nixup='sudo nixos-rebuild switch'
alias nixedit='sudo nvim /etc/nixos/configuration.nix'

# List
alias ls='eza'
alias l='eza -F'
alias la='eza -A'
alias ll='eza -alF'

# Quit terminal
alias q='exit'

# Neovim
alias v='nvim'

# Zathura
alias zdv='zathura'
function zdvd() { zathura $1 & disown }
function zdve() { zathura $1 & disown && exit }
