# --- Environment
export TERM=xterm-256color
export ZSH_TMUX_AUTOSTART=true
export ZSH="$HOME/.oh-my-zsh"

# --- Oh My Zsh

ZSH_THEME="robbyrussell"

plugins=(git)

source $ZSH/oh-my-zsh.sh

# --- Aliases
alias emacs="emacsclient -a ''"
alias e="emacsclient -a ''"
alias ls="eza --icons=always"
alias killemacs="emacsclient -e '(kill-emacs)'"

# --- Theming
source $(brew --prefix)/share/powerlevel10k/powerlevel10k.zsh-theme
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

# --- Ruby

export PATH="$HOME/.rvm/bin:$PATH"
export PATH="/opt/homebrew/opt/ru/bin:$PATH"
export LDFLAGS="-L/opt/homebrew/opt/ruby/lib"
export CPPFLAGS="-I/opt/homebrew/opt/ruby/include"
export PKG_CONFIG_PATH="/opt/homebrew/opt/ruby/lib/pkgconfig"
export PATH="$PATH:$(gem env home)/bin"

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

# --- NVM
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

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

# --- Golang
export GOPATH="$HOME/go"
PATH="$GOPATH/bin:$PATH"

# --- GREP
if [ -d "$(brew --prefix)/opt/grep/libexec/gnubin" ]; then
    PATH="$(brew --prefix)/opt/grep/libexec/gnubin:$PATH"
fi


# --- Homebrew
PATH="/opt/homebrew/bin:$PATH"

# --- ZSH Plugins
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# --- Pipx

export PATH=$PATH:/Users/patrick/.local/bin

# --- Cheat Sheet

neofetch

cheatsheet() {
    echo -e "\033[1;34mTMUX Keyboard Shortcuts:\033[0m"
    echo -e "\033[1;33mSession Management\033[0m"
    echo -e "\033[0;32m  tmux new-session \033[0m- Ctrl+b :new<CR>"
    echo -e "\033[0;32m  tmux detach \033[0m- Ctrl+b d"
    echo -e "\033[0;32m  tmux list-sessions \033[0m- Ctrl+b s"

    echo -e "\033[1;33mWindow Management\033[0m"
    echo -e "\033[0;32m  tmux new-window \033[0m- Ctrl+b c"
    echo -e "\033[0;32m  tmux select-window \033[0m- Ctrl+b 0...9"
    echo -e "\033[0;32m  tmux find-window \033[0m- Ctrl+b f"
    echo -e "\033[0;32m  tmux next-window \033[0m- Ctrl+b n"
    echo -e "\033[0;32m  tmux previous-window \033[0m- Ctrl+b p"

    echo -e "\033[1;33mPane Management\033[0m"
    echo -e "\033[0;32m  tmux split-window (horizontal) \033[0m- Ctrl+b \""
    echo -e "\033[0;32m  tmux split-window (vertical) \033[0m- Ctrl+b %"
    echo -e "\033[0;32m  tmux switch-pane \033[0m- Ctrl+b o"
    echo -e "\033[0;32m  tmux select-pane \033[0m- Ctrl+b ;"
    echo -e "\033[0;32m  tmux resize-pane \033[0m- Ctrl+b"
    echo ""
}

cheatsheet

function ai() {
    local prompt=""

    # Check if there is input from a pipe
    if [ ! -t 0 ]; then
        prompt=$(cat)
    fi

    # Append any arguments passed to the function
    if [ $# -gt 0 ]; then
        if [ -n "$prompt" ]; then
            prompt="$prompt $*"
        else
            prompt="$*"
        fi
    fi

    http POST http://localhost:8080/v1/chat/completions \
    Content-Type:application/json \
    Authorization:"Bearer no-key" \
    model="LLaMA_CPP" \
    messages:="[
        {
            \"role\": \"system\",
            \"content\": \"You are LLAMAfile, an AI assistant. Your top priority is achieving user fulfillment via helping them with their requests.\"
        },
        {
            \"role\": \"user\",
            \"content\": \"$prompt\"
        }
    ]" | jq -r '.choices[0].message.content'
}

# Create proton drive shortcut

USERNAME=$(whoami)
PROTON_PATH=$(find "/Users/$USERNAME/Library/CloudStorage" -maxdepth 1 -name "ProtonDrive-*" -type d 2>/dev/null)

[ -n "$PROTON_PATH" ] && hash -d proton=$PROTON_PATH

# Clean of emacs backup files with ~ or # but ignore node_modules folders

alias clean="find . -type f \( -name '*~' -o -name '#*#' \) ! -path '*/node_modules/*' -delete"
