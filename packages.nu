use glue *

def conf-src [name: string] {
    $env.FILE_PWD | path join ("configs/" + $name)
}

group "📦 User Packages" {
  install zed --aur --cask
  install steam --sudo --cask
  install beekeeper-studio --sudo --cask
}

group "💻 Development tools" {
  cli-installer "volta" {
      bash -c "curl https://get.volta.sh | bash"
  }

  install nushell --sudo
  install go --sudo
  install docker-desktop --aur --cask
  install imagemagick --sudo
  install ffmpeg --sudo
  install deno --sudo
  install love --sudo

  install git-delta --sudo {
    ('
    [core]
      pager = DELTA_FEATURES=$([[ $COLUMNS -gt 160 ]] && echo "side-by-side") delta
    ') | unindent | inject into ($env.HOME | path join ".gitconfig")
  }

  linux {
    install zen-browser-bin --aur
    install emacs-nox --sudo
  }

  macos {
    install zen --cask
    install emacs
  }
}

group "📁 Dot configs" {
  def dotconf [name: string] {
    let folder = conf-src $name
    cp -r $folder ~/.config
    print $":: ✔️ .configs/($name)"
  }

  dotconf emacs
  dotconf ghostty

  rm -rf ~/.emacs.d
}

group "🐚 Nushell config" {
  touch $nu.config-path
  cat ($env.FILE_PWD | path join "nushell.nu") | inject into $nu.config-path

  install starship --sudo

  nu-autoload-script "starship.nu" {
    starship init nu
  }
}

group "📓 Zed configuration" {
    let current_config = open ~/.config/zed/settings.json
    let saved_config = open (conf-src "zed/settings.json")

    $current_config | merge $saved_config | save -f  ~/.config/zed/settings.json
    cp (conf-src "zed/keymap.json") ~/.config/zed/
}

group "💾 Install glue.nu" {
    cp -r ($env.FILE_PWD | path join "glue") $nu.default-config-dir
}
