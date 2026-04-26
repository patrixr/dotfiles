use std/util "path add"
use glue *

$env.config.buffer_editor = "emacs"
$env.EDITOR = "emacs"
$env.AWS_PROFILE = "DevOps"
$env.AWS_SDK_LOAD_CONFIG = "true"
$env.GOPATH = $"($env.HOME)/go"
$env.GEM_HOME = $"($env.HOME)/.gem"
$env.GEM_PATH = $"($env.HOME)/.gem"

path add ($env.HOME | path join ".npm/bin")
path add ($env.HOME | path join ".volta/bin")
path add ($env.HOME | path join ".rvm/bin")
path add ($env.HOME | path join ".deno/bin")
path add ($env.GOPATH | path join "bin")
path add "/usr/local/bin"
path add ($env.HOME | path join ".local/bin")

if (macos?) {
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

alias killemacs = emacsclient -e '(kill-emacs)'
alias l = ls
alias ll = ls -l
alias fg = job unfreeze
alias zed = zeditor
alias pbcopy = wl-copy
alias pbpaste = wl-paste

git config --global alias.poc '!git push origin $(git rev-parse --abbrev-ref HEAD)'
git config --global alias.up '!git push origin $(git rev-parse --abbrev-ref HEAD)'
git config --global alias.down '!git pull origin $(git rev-parse --abbrev-ref HEAD)'
git config --global alias.co checkout
git config --global alias.s '!git status -sb'

# ---
# --- Containers
# ---

def sandbox [image: string] {
  docker run --rm -w /workspace -it -v ./:/workspace $image /bin/bash
}

def dev-containers [] {
  let containers = [
    {name: "redis", port: "6379:6379", image: "redis", env: []},
    {name: "pgvector17", port: "5432:5432", image: "pgvector/pgvector:pg17", env: ["-e", "POSTGRES_USER=postgres", "-e", "POSTGRES_PASSWORD=postgres"]}
  ]
  for container in $containers {
    let running = (docker ps --filter $"name=($container.name)" --format "{{.Names}}" | lines | where $it == $container.name | length)
    if $running == 0 {
      let exists = (docker ps -a --filter $"name=($container.name)" --format "{{.Names}}" | lines | where $it == $container.name | length)
      if $exists > 0 {
        print $"Starting stopped container: ($container.name)"
        docker start $container.name
      } else {
        print $"Creating new container: ($container.name)"
        docker run -d --name $container.name -p $container.port ...$container.env $container.image
      }
    } else {
      print $"Container already running: ($container.name)"
    }
  }
}
