#
# ~/.zshrc
#

# Ctrl + Backspace kill a word
bindkey '^H' backward-kill-word

# Enabling syntax highliting for nano
# ls -1 /usr/share/nano/*.nanorc | sed 's/^\//include \//' > ~/.nanorc

# Running electron apps in wayland needs this
export ELECTRON_OZONE_PLATFORM_HINT="wayland"
export VCPKG_ROOT="/opt/vcpkg"
export VCPKG_DOWNLOADS="/var/cache/vcpkg"
export EDITOR="/bin/nvim"
export PATH="$PATH:/home/moe/.local/bin:/usr/bin/pdflatex:/usr/bin/latex"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_STATE_HOME="$HOME/.local/state"
export GNUPGHOME="$XDG_DATA_HOME/gnupg"
export GNUBGHOME="$XDG_DATA_HOME/gnubg"
export WINEPREFIX="$XDG_DATA_HOME/wine"
export HISTFILE="$XDG_CACHE_HOME/zsh/history"
export ZSH="$XDG_DATA_HOME/oh-my-zsh"
export MYPY_CACHE_DIR="$XDG_CACHE_HOME/mypy"
export NODE_REPL_HISTORY="$XDG_DATA_HOME/node_repl_history"
export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc"
export GOPATH="$XDG_DATA_HOME/go"
export CUDA_CACHE_PATH="$XDG_CACHE_HOME/nv"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
alias wget='wget --hsts-file="$XDG_DATA_HOME/wget-hsts"'
alias nvidia-settings=nvidia-settings --config="$XDG_CONFIG_HOME/nvidia/settings"
alias feh="feh --no-fehbg"
export TEXMFVAR="$XDG_CACHE_HOME/texlive/texmf-var"
export RUSTUP_HOME="$XDG_DATA_HOME"/rustup
export XCURSOR_PATH="/usr/share/icons:$XDG_DATA_HOME/icons"
export NODE_REPL_HISTORY="$XDG_DATA_HOME/node_repl_history"
export PYTHON_HISTORY="$XDG_STATE_HOME/python/history"
export PYTHONPYCACHEPREFIX="$XDG_CACHE_HOME/python"
export PYTHONUSERBASE="$XDG_DATA_HOME/python"
export PYTHONSTARTUP="$XDG_DATA_HOME/python/pythonrc"

# oh-my-zsh
export ZSH_COMPDUMP=$ZSH/cache/.zcompdump-$HOST
plugins=(git zsh-autosuggestions zsh-syntax-highlighting zsh-history-substring-search)
# ZSH_THEME="af-magic"
# ZSH_THEME="afowler"
# ZSH_THEME="alanpeabody"
# ZSH_THEME="bira"
# ZSH_THEME="fishy"
# ZSH_THEME="gallifrey"
# ZSH_THEME="gallois"
# ZSH_THEME="jaischeema"
# ZSH_THEME="pygmalion"
source $ZSH/oh-my-zsh.sh

# Environment variables for development
source $HOME/.env_vars

if which vscodium > /dev/null; then
  alias code="vscodium"
fi
alias sudo="sudo -EH"
alias serve='sudo python -m http.server'
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias ssh='TERM=xterm-256color ssh'
alias lsblock='lsblk -o name,fstype,size,mountpoints -e 7'
alias grep='grep --color=auto'
alias ex='chmod u+x'
alias ls='ls --color=auto'
#alias ls='eza -l --color=always --group-directories-first'
alias la='eza -la --color=always --group-directories-first'  # all files and dirs
alias ll='eza -a --color=always --group-directories-first'  # long format
alias cp="cp -i"
alias mv="mv -i"
alias sr="sudo reboot now"

function copyfile {
  [[ "$#" != 1 ]] && return 1
  local file_to_copy=$1
  cat $file_to_copy | wl-copy
}

function copydir {
  pwd | tr -d "\r\n" | wl-copy
}

# function exp {
#   [[ "$#" != 1 ]] && local path_to_open="." || local path_to_open=$1
#   nohup thunar $path_to_open > /dev/null &
# }

# ARCHIVE EXTRACTION usage: extract <file>
function extract {
 if [ -z "$1" ]; then
    # display usage if no parameters given
    echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
    echo "       extract <path/file_name_1.ext> [path/file_name_2.ext] [path/file_name_3.ext]"
 else
    for n in "$@"
    do
      if [ -f "$n" ] ; then
          case "${n%,}" in
            *.cbt|*.tar.bz2|*.tar.gz|*.tar.xz|*.tbz2|*.tgz|*.txz|*.tar)
                         tar xvf "$n"       ;;
            *.lzma)      unlzma ./"$n"      ;;
            *.bz2)       bunzip2 ./"$n"     ;;
            *.cbr|*.rar)       unrar x -ad ./"$n" ;;
            *.gz)        gunzip ./"$n"      ;;
            *.cbz|*.epub|*.zip)       unzip ./"$n"       ;;
            *.z)         uncompress ./"$n"  ;;
            *.7z|*.arj|*.cab|*.cb7|*.chm|*.deb|*.dmg|*.iso|*.lzh|*.msi|*.pkg|*.rpm|*.udf|*.wim|*.xar)
                         7z x ./"$n"        ;;
            *.xz)        unxz ./"$n"        ;;
            *.exe)       cabextract ./"$n"  ;;
            *.cpio)      cpio -id < ./"$n"  ;;
            *.cba|*.ace)      unace x ./"$n"      ;;
            *)
                         echo "ex: '$n' - unknown archive method"
                         return 1
                         ;;
          esac
      else
          echo "'$n' - file does not exist"
          return 1
      fi
    done
  fi
}

# Starship
eval "$(starship init zsh)"

# idk man
cowsay -f sodomized "Welcome Back Soldier" | lolcat

# pnpm
export PNPM_HOME="/home/moe/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# fnm
fnm env > /tmp/fnm
. /tmp/fnm

