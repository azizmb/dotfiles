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
export ZSH=$HOME/.oh-my-zsh

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
HIST_STAMPS="dd.mm.yyyy"
export ZSH_CUSTOM=$HOME/dotfiles/zsh


# User configuration

export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:$HOME/bin:$HOME/.local/bin"

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
pipenv
python
git
virtualenvwrapper
docker
docker-compose
aws
extract
gitignore

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

alias apt-get='apt-fast'

NPM_PACKAGES="${HOME}/.npm-packages"

PATH="$NPM_PACKAGES/bin:$PATH"

# Unset manpath so we can inherit from /etc/manpath via the `manpath` command
unset MANPATH # delete if you already modified MANPATH elsewhere in your config
export MANPATH="$NPM_PACKAGES/share/man:$(manpath)"

# Cask
export PATH="${HOME}/.cask/bin:$PATH"


export WORK_DIR="${HOME}/work"


export PATH="${HOME}/work/git-utils:$PATH"


[[ -s "$HOME/.gvm/scripts/gvm" ]] && source "$HOME/.gvm/scripts/gvm"


export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

export EMACS='emacs-snapshot'


function rmhis() {
    LC_ALL=C sed -i '/$1/d' $HISTFILE
}

# tabtab source for serverless package
# uninstall by removing these lines or running `tabtab uninstall serverless`
[[ -f /home/azizbookwala/work/syncer/node_modules/tabtab/.completions/serverless.zsh ]] && . /home/azizbookwala/work/syncer/node_modules/tabtab/.completions/serverless.zsh
# tabtab source for sls package
# uninstall by removing these lines or running `tabtab uninstall sls`
[[ -f /home/azizbookwala/work/syncer/node_modules/tabtab/.completions/sls.zsh ]] && . /home/azizbookwala/work/syncer/node_modules/tabtab/.completions/sls.zsh
# tabtab source for slss package
# uninstall by removing these lines or running `tabtab uninstall slss`
[[ -f /home/azizbookwala/work/syncer/node_modules/tabtab/.completions/slss.zsh ]] && . /home/azizbookwala/work/syncer/node_modules/tabtab/.completions/slss.zsh

alias aws-okta=". ~/.aws_okta/aws-okta"

# tabtab source for packages
# uninstall by removing these lines
[[ -f ~/.config/tabtab/__tabtab.zsh ]] && . ~/.config/tabtab/__tabtab.zsh || true

export PATH="/home/azizbookwala/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"


export PATH="$PATH:/usr/lib/dart/bin:$HOME/.pub-cache/bin"
