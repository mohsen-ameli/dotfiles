# Ctrl + Backspace kill a word
bindkey '^H' backward-kill-word

# Enabling syntax highliting for nano
ls -1 /usr/share/nano/*.nanorc | sed 's/^\//include \//' >> ~/.nanorc

# oh-my-zsh
export ZSH="$HOME/.oh-my-zsh"
plugins=(git z zsh-autosuggestions zsh-syntax-highlighting zsh-history-substring-search)
source $ZSH/oh-my-zsh.sh

# Running electron apps in wayland needs this
export ELECTRON_OZONE_PLATFORM_HINT="wayland"
export VCPKG_ROOT="/opt/vcpkg"
export VCPKG_DOWNLOADS="/var/cache/vcpkg"
export PATH="$PATH:/home/moe/.local/bin:/usr/bin/pdflatex:/usr/bin/latex"

alias serve='sudo python -m http.server'
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias ssh='TERM=xterm-256color ssh'
#alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias ex='chmod u+x'
alias ls='eza -al --color=always --group-directories-first' # my preferred listing
alias la='eza -a --color=always --group-directories-first'  # all files and dirs
alias ll='eza -l --color=always --group-directories-first'  # long format

# Starship
eval "$(starship init zsh)"

# Pywal
# (cat ~/.cache/wal/sequences &)
# cat ~/.cache/wal/sequences
# source ~/.cache/wal/colors-tty.sh

# idk man
cowsay "Welcome Back Soldier"
