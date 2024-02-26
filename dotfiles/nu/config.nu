$env.config = {
  edit_mode: vi
  show_banner: false # true or false to enable or disable the welcome banner at startup
  rm: {
    always_trash: true # always act as if -t was given. Can be overridden with -p
  }
  completions: {
    case_sensitive: false
  }
}

################################
### Aliases and functions    ###
################################

# Neovim
alias v = nvim

# Helix
alias h = hx

# File browser
alias y = yazi

# NixOS
alias nixup = sudo nixos-rebuild switch --flake "/home/willow/nixos/#nixos"
#alias nixup = sudo nixos-rebuild switch
alias nixedit = nvim ~/nixos/configuration.nix
#alias nixedit = sudo nvim /etc/nixos/configuration.nix

# List
# alias ls = eza
alias l  = eza -F
alias la = eza -A
alias ll = eza -alF

# Clear screen
alias cls = clear

# Quit terminal
alias q = exit

# Git
alias ga = git add -A
def gc [msg] {
  git commit -m $msg
}

# Backups
alias mlocal  = mount /dev/sda1 /run/media/willow/
alias umlocal = umount /dev/sda1
alias localbu = sudo rclone sync ~ /run/media/willow/Data-Backup --include-from ~/nixos/dotfiles/rclone/includefile.txt -vvP --stats=1s

# Zathura
alias zdv = zathura
def zdvd [doc] {
  bash -c (['zathura ', $doc , ' & disown'] | str join)
}
def zdve [doc] {
  bash -c (['zathura ', $doc , ' & disown'] | str join); exit
}
