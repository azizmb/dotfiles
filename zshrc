# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/aziz/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

# Path to your oh-my-zsh installation.
export ZSH=/home/aziz/.oh-my-zsh

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
HIST_STAMPS="dd.mm.yyyy"
export ZSH_CUSTOM=$HOME/dotfiles/zsh


# User configuration

export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:$HOME/bin:$HOME/.local/bin/"

source $ZSH/oh-my-zsh.sh

eval "$(direnv hook zsh)"

# Antigen <3
[[ ! -d ~/src/antigen ]] &&
        mkdir -p ~/src && git clone https://github.com/zsh-users/antigen.git ~/src/antigen

. ~/src/antigen/antigen.zsh

antigen use oh-my-zsh

antigen theme robbyrussell

antigen bundles <<EOBUNDLES

arzzen/calc.plugin.zsh
djui/alias-tips

zsh-users/zsh-completions
tarruda/zsh-autosuggestions
jimmijj/zsh-syntax-highlighting

pip
python
git
virtualenvwrapper
docker
docker-compose
aws
extract

$HOME/.oh-my-zsh/custom/plugins/ebutils

EOBUNDLES

antigen apply


zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*' group-name ''
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path ~/.zsh/cache/$HOST

setopt correctall
