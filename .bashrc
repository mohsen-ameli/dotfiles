#
# ~/.bashrc
#

# Running electron apps in wayland needs this
export ELECTRON_OZONE_PLATFORM_HINT="wayland"
export PATH="$PATH:/usr/bin/latex:/usr/bin/pdflatex"
[ $($HOME/.local/bin/is-wayland) -eq 1 ] && alias rofi="rofi \"$@\"" || alias rofi="rofi -dpi 120 \"$@\""

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

bind '"\C-h": backward-kill-word'

function copyfile {
  [[ "$#" != 1 ]] && return 1
  local file_to_copy=$1
  cat $file_to_copy | wl-copy
}

function copydir {
  pwd | tr -d "\r\n" | wl-copy
}

function exp {
  [[ "$#" != 1 ]] && local path_to_open="." || local path_to_open=$1
  nohup thunar $path_to_open > /dev/null &
}

export XCURSOR_PATH=/usr/share/icons:$XDG_DATA_HOME/icons
export GTK2_RC_FILES="$XDG_CONFIG_HOME"/gtk-2.0/gtkrc
alias wget=wget --hsts-file="$XDG_DATA_HOME/wget-hsts"
alias nvidia-settings=nvidia-settings --config="$XDG_CONFIG_HOME/nvidia/settings"
alias feh="feh --no-fehbg"
export CUDA_CACHE_PATH="$XDG_CACHE_HOME/nv"
export PASSWORD_STORE_DIR="$XDG_DATA_HOME"/pass

alias sudo="sudo -EH"
alias wget='wget --hsts-file="$HOME/.local/share/wget-hsts"'
alias serve='sudo python -m http.server'
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias ssh='TERM=xterm-256color ssh'
alias copydir='copydir'
alias copyfile='copyfile'
alias exp='exp'
alias lsblock='lsblk -o name,fstype,size,mountpoints -e 7'
#alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias ex='chmod u+x'
alias ls='eza -l --color=always --group-directories-first' # my preferred listing
alias la='eza -la --color=always --group-directories-first'  # all files and dirs
alias ll='eza -a --color=always --group-directories-first'  # long format
alias cp="cp -i"
alias mv="mv -i"

### ARCHIVE EXTRACTION
# usage: extract <file>
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
PS1='[\u@\h \W]\$ '
eval "$(starship init bash)"
