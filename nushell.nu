use std/util "path add"
use glue *

$env.config.buffer_editor = "emacs"
$env.EDITOR = "emacs"
$env.AWS_PROFILE = "DevOps"
$env.AWS_SDK_LOAD_CONFIG = "true"
$env.GOPATH = $"($env.HOME)/go"
# --- Ruby

$env.GEM_HOME = $"($env.HOME)/.gem"
$env.GEM_PATH = $"($env.HOME)/.gem"

path add ($env.HOME | path join ".volta/bin")
path add "/Users/prabier/Code/glue/.out"
path add ($env.HOME | path join ".rvm/bin")
path add "/opt/homebrew/opt/ru/bin"
path add ($env.GOPATH | path join "bin")
path add "/Users/patrick/.local/bin"
path add "/usr/local/bin"

macos {
  path add "/opt/homebrew/bin"
  $env.LDFLAGS = "-L/opt/homebrew/opt/ruby/lib"
  $env.CPPFLAGS = "-I/opt/homebrew/opt/ruby/include"
  $env.PKG_CONFIG_PATH = "/opt/homebrew/opt/ruby/lib/pkgconfig"
  $env.JAVA_HOME = "/opt/homebrew/opt/openjdk@17"
  $env.ANDROID_HOME = $"($env.HOME)/Library/Android/sdk"
  path add ($env.ANDROID_HOME | path join "platform-tools")
  path add ($env.ANDROID_HOME | path join "tools")
}

try {
    let gem_home = (do -i { gem env home } | str trim)
    if $gem_home != "" {
        path add ($gem_home | path join "bin")
    }
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

# ---
# --- Containers
# ---

def sandbox [image: string] {
  docker run --rm -w /workspace -it -v ./:/workspace $image /bin/bash
}

# ---
# --- Addons
# ---

autoload-script "starship.nu" {
  starship init nu
}

vendor-install "github.com/fj0r/ai.nu" { |location|
  let import_path = $location | path join "ai"

  autoload-script "ai.nu" {
    $"use \"($import_path)\" *"
  }
}
