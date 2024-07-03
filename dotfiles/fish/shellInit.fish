### Aliases
# Neovim
alias vi="nvim"

# NixOS
alias nixup="sudo nixos-rebuild switch --flake \"/home/willow/nixos/#nixos\""
alias nixedit="nvim ~/nixos/configuration.nix"

# VM
alias arch="distrobox enter arch"
function resetarch
  distrobox stop arch
  distrobox rm arch
  distrobox create -i docker.io/archlinux:latest -n arch
  arch
end

# List
alias la="ls -a"
alias ll="ls -l"

# Clear screen
alias cls="clear"

# Quit terminal
alias q="exit"

# Git
alias ga="git add -A"
function gc
  git commit -m $argv
end

# Backups
alias mlocal="mount /dev/sda1 /run/media/willow/"
alias umlocal="umount /dev/sda1"
alias localbu="sudo rclone sync ~ /run/media/willow/Data-Backup --include-from ~/nixos/dotfiles/rclone/includefile.txt -vvP --stats=1s"

# Zathura
alias zdv="zathura"
function zdvd
  zathura $argv &
end
function zdve
  zathura $argv & ; disown ; exit
end
