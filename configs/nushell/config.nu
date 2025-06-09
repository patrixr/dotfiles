use std/util "path add"

$env.config.buffer_editor = "emacs"

$env.JAVA_HOME = "/opt/homebrew/opt/openjdk@17"
$env.ANDROID_HOME = $"($env.HOME)/Library/Android/sdk"
$env.AWS_PROFILE = "DevOps"
$env.AWS_SDK_LOAD_CONFIG = "true"
$env.NVM_DIR = $"($env.HOME)/.nvm"
$env.GOPATH = $"($env.HOME)/go"
# --- Ruby
$env.LDFLAGS = "-L/opt/homebrew/opt/ruby/lib"
$env.CPPFLAGS = "-I/opt/homebrew/opt/ruby/include"
$env.PKG_CONFIG_PATH = "/opt/homebrew/opt/ruby/lib/pkgconfig"

path add ($env.HOME | path join ".volta/bin")
path add ($env.ANDROID_HOME | path join "platform-tools")
path add ($env.ANDROID_HOME | path join "tools")
path add "/Users/prabier/Code/glue/.out"
path add ($env.HOME | path join ".rvm/bin")
path add "/opt/homebrew/opt/ru/bin"
path add ($env.GOPATH | path join "bin")
path add "/opt/homebrew/bin"
path add "/Users/patrick/.local/bin"

let gem_home = (do -i { gem env home } | str trim)
if $gem_home != "" {
  path add ($gem_home | path join "bin")
}

# --- Aliases

alias emacs = emacsclient -a ''
alias e = emacsclient -a ''
alias killemacs = emacsclient -e '(kill-emacs)'
alias l = ls
alias ll = ls -l
alias fg = job unfreeze

git config --global alias.poc '!git push origin $(git rev-parse --abbrev-ref HEAD)'
git config --global alias.sync '!git pull origin $(git rev-parse --abbrev-ref HEAD)'
git config --global alias.s '!git status -sb'
