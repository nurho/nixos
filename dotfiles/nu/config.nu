$env.config = {
  edit_mode: vi
  show_banner: false # true or false to enable or disable the welcome banner at startup
  rm: {
    always_trash: true # always act as if -t was given. Can be overridden with -p
  }
}

################################
### Aliases and functions    ###
################################

# Neovim
alias v  = nvim

# Helix
alias h = hx

# File browser
alias y = yazi

# NixOS
alias nixup = sudo nixos-rebuild switch --flake "/home/willow/nixos/#nixos"
#alias nixup = sudo nixos-rebuild switch
alias nixedit = sudo nvim /etc/nixos/configuration.nix

# List
alias ls = eza
alias l = eza -F
alias la = eza -A
alias ll = eza -alF

# Quit terminal
alias q = exit

# Zathura
alias zdv = zathura
def zdvd [doc] {
  zathura $doc & disown
}
def zdve [doc] {
  zathura $doc & disown and exit
}
