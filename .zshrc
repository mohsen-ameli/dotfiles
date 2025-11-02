#
# ~/.zshrc
#

export CHARGE_LIMIT=80
export THEME="dark"

if pgrep -x i3 > /dev/null; then
  alias mpv="swallow mpv"
  alias steam="swallow steam"
  alias xdg-open="swallow xdg-open"
  alias wine="swallow wine"
  alias gedit="swallow gedit"
  alias copy="xclip"
elif [ "$XDG_SESSION_TYPE" = "wayland" ]; then
  export ELECTRON_OZONE_PLATFORM_HINT="wayland"
  alias copy="wl-copy"
fi

# Auto starting window managers
tty_session=$(echo "${$(tty)##*/}")
if [ "$tty_session" = "tty1" ]; then
  startx 
elif [ "$tty_session" = "tty2" ]; then
  Hyprland
fi

# If not running interactively, do not do anything
[[ $- != *i* ]] && return
# Otherwise start tmux
if [ -z "$TMUX" ] && [[ $- == *i* ]]; then
  tmux attach -d || tmux new
fi

####### EXPORTS #######
export QT_QPA_PLATFORM=xcb
export GTK_USE_PORTAL=1
export MANPAGER="nvim +Man!"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_STATE_HOME="$HOME/.local/state"
export VCPKG_ROOT="/opt/vcpkg"
export VCPKG_DOWNLOADS="/var/cache/vcpkg"
export EDITOR="/bin/nvim"
export PATH="$PATH:/home/moe/.local/bin:/usr/bin/pdflatex:/usr/bin/latex"
export WINEPREFIX="$XDG_DATA_HOME/wine"
export _Z_DATA="$XDG_DATA_HOME/z"
export MYPY_CACHE_DIR="$XDG_CACHE_HOME/mypy"
export NODE_REPL_HISTORY="$XDG_DATA_HOME/node_repl_history"
export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc"
export GOPATH="$XDG_DATA_HOME/go"
export CUDA_CACHE_PATH="$XDG_CACHE_HOME/nv"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export TEXMFVAR="$XDG_CACHE_HOME/texlive/texmf-var"
export RUSTUP_HOME="$XDG_DATA_HOME"/rustup
export XCURSOR_PATH="/usr/share/icons:$XDG_DATA_HOME/icons"
export NODE_REPL_HISTORY="$XDG_DATA_HOME/node_repl_history"
export PYTHON_HISTORY="$XDG_STATE_HOME/python/history"
export PYTHONPYCACHEPREFIX="$XDG_CACHE_HOME/python"
export PYTHONUSERBASE="$XDG_DATA_HOME/python"
export PYTHONSTARTUP="$XDG_DATA_HOME/python/pythonrc"
export GRIPHOME="$XDG_CONFIG_HOME/grip"

####### ALIASES #######
alias lsh="find -maxdepth 1 -exec du -sh "{}" 2> /dev/null \; | sort -h"
alias sm="sudo make clean install"
alias sudo="sudo -EH"
alias serve='sudo python -m http.server'
alias sv='sudo nvim'
alias p="sudo pacman"
alias sc="sudo systemctl"
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias lsbc='lsblk -o name,fstype,size,mountpoints,uuid -e 7 | bat -l conf -p'
alias grep='grep --color=auto'
alias fastfetch='fastfetch --config examples/17'
alias ex='chmod u+x'
alias ls='ls --color=auto --group-directories-first'
alias la='eza -la --color=always --group-directories-first'
alias ll='eza -a --color=always --group-directories-first'
#alias cp="cp -i"
alias cp="rsync -avh --partial --info=progress2"
alias mv="mv -i"
alias sr="sudo reboot now"
alias wget=wget --hsts-file="$XDG_DATA_HOME/wget-hsts"
alias feh="feh --no-fehbg"
alias ssh='TERM=xterm-256color ssh'

####### OH MY ZSH #######
export HISTFILE="$XDG_CACHE_HOME/zsh/history"
export ZSH="$XDG_DATA_HOME/oh-my-zsh"
export ZSH_COMPDUMP=$ZSH/cache/.zcompdump-$HOST
plugins=(git zsh-autosuggestions zsh-syntax-highlighting zsh-history-substring-search z)
# Themes that are good in oh-my-zsh, but I still prefer starship
# ZSH_THEME="af-magic", "afowler", "alanpeabody", "bira", "fishy", "gallifrey", "gallois", "jaischeema", "pygmalion"
source $ZSH/oh-my-zsh.sh

####### STARSHIP (TERMINAL LOOKS) #######
eval "$(starship init zsh)"
cowsay "Welcome Back $USER" | lolcat

####### FNM #######
fnm env > /tmp/fnm
. /tmp/fnm

####### BUN #######
[ -s "/home/moe/.bun/_bun" ] && source "/home/moe/.bun/_bun"
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

####### PYENV #######
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - zsh)"

####### KEYBINDS ########
bindkey '^H' backward-kill-word

####### CUSTOM FUNCTIONS #######
function copyfile {
  [[ "$#" != 1 ]] && return 1
  local file_to_copy=$1
  wl-copy < $file_to_copy
}

function copydir {
  pwd | tr -d "\r\n" | wl-copy
}

function genpass() {
  pass=$(tr -dc 'a-zA-Z0-9_#@.-' < /dev/random | head -c ${1:-16})
  echo -n "$pass"
  if [ $($HOME/.local/bin/is-wayland) -eq 0 ]; then
    echo -n "$pass" | xclip -sel clip
  else
    echo -n "$pass" | wl-copy
  fi
}

function extract {
 if [ -z "$1" ]; then
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


####### OVERRIDE #######
export HISTSIZE=999999999
export SAVEHIST=$HISTSIZE
