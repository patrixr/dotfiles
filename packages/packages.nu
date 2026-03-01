use ../glue *

def conf-src [name: string] {
    $env.FILE_PWD | path join ("../configs/" + $name)
}

group "📦 User Packages" {
  install zed --aur --cask
  install steam --sudo --cask
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

  git config --global user.name "Patrick"
  git config --global user.email "1822532+patrixr@users.noreply.github.com"

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

group "📓 Zed configuration" {
  for file in ["settings", "keymap"] {
    let target_path = ($env.HOME | path join $".config/zed/($file).json")
    let source_path = (conf-src $"zed/($file).json")

    let last_update_of_target = (ls $target_path | get 0 | get modified)
    let last_update_of_source = (ls $source_path | get 0 | get modified)

    if $last_update_of_target > $last_update_of_source {
      print $"⚠️  Zed ($file).json target file is newer than source. Copy it over as the new standard file? \(y/n\)"
      let response = (input)
      if $response == "y" {
        cp $target_path $source_path
        print $":: ✔️ Copied ($file) target to source"
      }
    } else if $last_update_of_source > $last_update_of_target {
      # Only merge and update target when source has changes
      let current_config = open $target_path
      let saved_config = open $source_path

      $current_config | merge $saved_config | save -f $target_path
      print $":: ✔️ Updated ($file).json from source"
    }
  }
}
