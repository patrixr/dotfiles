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

# pnpm
export PNPM_HOME="/Users/patrickrabier/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# auto pnpm
NPM_PATH=$(which npm)
NPX_PATH=$(which npx)
npm () {
  # Note:
  # We default to pnpm, but still check for its lockfile
  # because package-lock.json often sneaks into projects unintentionally
  if [ -e PNPM-lock.yaml ]
  then
    echo "pnpm project detected, using pnpm"
    pnpm $@
  elif [ -e package-lock.json ]
  then
    echo "npm project detect, using original npm"
    $NPM_PATH "$@"
  else
    echo "using pnpm"
    pnpm "$@"
  fi
}

npx () {
  if [ -e PNPM-lock.yaml ]
  then
    echo "pnpm project detected, using pnpx instead"
    pnpx $@
  else
    $NPX_PATH "$@"
  fi
}
# auto pnpm end

# doom emacs
export PATH="$HOME/.config/emacs/bin:$PATH"
# doom emacs end

# brew grep
if [ -d "$(brew --prefix)/opt/grep/libexec/gnubin" ]; then
    PATH="$(brew --prefix)/opt/grep/libexec/gnubin:$PATH"
fi
# brew grep end