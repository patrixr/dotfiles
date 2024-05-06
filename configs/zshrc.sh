export TERM=xterm-256color

# emacs
alias emacs="emacsclient -a ''"
alias e="emacsclient -a ''"
# emacs end

# ZSH Theme
source $(brew --prefix)/share/powerlevel10k/powerlevel10k.zsh-theme
# ZSH Theme end

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
# nvm end

# auto nvm
autoload -U add-zsh-hook
load-nvmrc() {
  local node_version="$(nvm version)"
  local nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$node_version" ]; then
      nvm use
    fi
  elif [ "$node_version" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc
# auto nvm end

# doom emacs
export PATH="$HOME/.config/emacs/bin:$PATH"
# doom emacs end

# golang
export GOPATH="$HOME/go"
PATH="$GOPATH/bin:$PATH"
# golang end

# brew grep
if [ -d "$(brew --prefix)/opt/grep/libexec/gnubin" ]; then
    PATH="$(brew --prefix)/opt/grep/libexec/gnubin:$PATH"
fi
# brew grep end

# homebrew path
PATH="/opt/homebrew/bin:$PATH"
# homebrew path end
