# random zsh variablan
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -e
zstyle :compinstall filename '/home/jan-patrick/.zshrc'
autoload -Uz compinit
compinit

# shell variablan
export PATH=".:/usr/lib/cw:/usr/local/bin:$PATH"
export BROWSER='firefox'
export PAGER='less'
export EDITOR='vim'

# man coloran
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[0;32m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[1;32m'

# random aliasan
alias ls='/bin/ls --color=auto'
alias cp='pycp'
alias ..='cd ..'
alias ...='cd ../../'
alias c='clear'
alias home='cd ~ && clear'
alias zshrc='vim ~/.zshrc && source ~/.zshrc'
alias gay='toilet -tf smmono12.tlf --gay $1'

# package managan
alias pacman='sudo pacman'
alias clyde='sudo clyde'
alias packup='sudo pacsnap -p "`date +%d.%m.%Y`"'

# executable executan
alias -s exe='wine'
alias -s sh='sh'
alias -s pl='perl'
alias -s py='python'

# image viewan
alias -s jpg='gpicview'
alias -s png='gpicview'
alias -s gif='gpicview'
alias -s xcf='gimp'

# text editan
alias -s h=$EDITOR
alias -s c=$EDITOR
alias -s mk=$EDITOR
alias -s cfg=$EDITOR
alias -s txt=$EDITOR

# browsan
alias -s fi=$BROWSER
alias -s com=$BROWSER
alias -s net=$BROWSER
alias -s org=$BROWSER

# prompt rican
#PS1=$'%{\e[1;31m%}%n%{\e[0;31m%}@%{\e[1;31m%}%M %{\e[1;35m%}%~ %{\e[0;35m%}$ %{\e[0m%}' #red user/host, magenta directory
#PS1=$'%{\e[1;34m%}%n%{\e[0;34m%}@%{\e[1;34m%}%M %{\e[1;33m%}%~ %{\e[0;33m%}$ %{\e[0m%}' #blue user/host, red directory
PS1=$'%{\e[1;34m%}%n%{\e[0;34m%}@%{\e[1;34m%}%M %{\e[1;31m%}%~ %{\e[0;31m%}$ %{\e[0m%}' #blue user/host, red directory
#export PS1="$(print '%{\e[0;31m%}:%{\e[1;31m%}:%{\e[0;33m%}:%{\e[1;33m%}:%{\e[0m%} ')"
#export PS1="$(print '%{\e[0;31m%}>%{\e[1;31m%}>%{\e[0;33m%}>%{\e[1;33m%}>%{\e[0m%} ')"

# directory changan rican
cd() { builtin cd $@; ls }

# window title rican
case $TERM in
  *xterm*|rxvt|rxvt-unicode|rxvt-256color|(dt|k|E)term)
    precmd () { print -Pn "\e]0;$TERM - [%n@%M]%# [%~]\a" }
    preexec () { print -Pn "\e]0;$TERM - [%n@%M]%# [%~] ($1)\a" }
;;
  screen)
    precmd () {
      print -Pn "\e]83;title \"$1\"\a"
      print -Pn "\e]0;$TERM - [%n@%M]%# [%~]\a" }
    preexec () {
      print -Pn "\e]83;title \"$1\"\a"
      print -Pn "\e]0;$TERM - [%n@%M]%# [%~] ($1)\a" }
;;
esac
