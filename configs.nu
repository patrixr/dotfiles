use glue *

def conf-src [name: string] {
    $env.FILE_PWD | path join ("configs/" + $name)
}

group "📁 Personal dot configs" {
  def dotconf [name: string] {
      let folder = conf-src $name
      cp -r $folder ~/.config
      print $":: ✔️ .configs/($name)"
  }

  def dotconf-backup [name: string] {
      let target_path = ($env.HOME | path join $".config/($name)")
      let source_path = (conf-src $name)
      rm -rf $source_path
      cp -r $target_path $source_path
      print $":: ✔️ Synced ($name) system → repo"
  }

  # Personal configs layered on top of Hyperion
  dotconf emacs
  dotconf ghostty
  dotconf keyd
  
  let noctalia_target = ($env.HOME | path join ".config/noctalia")
  let noctalia_source = (conf-src "noctalia")
  let newest_system = if ($noctalia_target | path exists) { (ls -al $noctalia_target | sort-by modified | last | get modified) } else { 1970-01-01 }
  let newest_repo = (ls -al $noctalia_source | sort-by modified | last | get modified)
  if ($noctalia_target | path exists) and ($newest_system > $newest_repo) {
    if (user-confirm "⚠️  noctalia system config is newer than repo. Sync system → repo?") {
      dotconf-backup noctalia
    } else {
      print ":: ⏭️  Skipped noctalia backup"
    }
  } else {
    dotconf noctalia
  }
}

group "🎹 Personal Keybinds" {
  linux {
    install keyd --sudo {
      sudo usermod -aG keyd $env.USER
      sudo systemctl -f enable keyd.service
      sudo systemctl -f start keyd.service
    }
    sudo mkdir -p /etc/keyd
    sudo cp (conf-src "keyd/default.conf") /etc/keyd/default.conf
    sudo keyd reload
  }
}

group "💾 Install glue.nu" {
    cp -r ($env.FILE_PWD | path join "glue") $nu.default-config-dir
}

group "🐚 Nushell config" {
  touch $nu.config-path
  cat (conf-src "nushell.nu") | inject into $nu.config-path

  install starship --sudo

  nu-autoload-script "starship.nu" {
    starship init nu
  }
}

group "🖼️ Personal Wallpapers" {
  mkdir ~/Pictures/Wallpapers
  let images_folder = $env.FILE_PWD | path join "images"
  for file in (ls $images_folder | where type == file) {
    cp $file.name ~/Pictures/Wallpapers/
  }
  print ":: ✔️ Wallpapers copied to ~/Pictures/Wallpapers"
}

group "📦 User Packages" {
  install zed --aur --cask
  install steam --sudo --cask
  install proton-vpn-gtk-app --sudo
}

group "💻 Development tools" {
  cli-installer "volta" {
    bash -c "curl https://get.volta.sh | bash"
  }

  cli-installer "configcat" {
    bash -c "curl -fsSL https://raw.githubusercontent.com/configcat/cli/main/scripts/install.sh | sudo bash"
  }

  install nushell --sudo
  install go --sudo
  install gnupg --sudo
  install pass --sudo
  install docker-desktop --aur --cask
  install imagemagick --sudo
  install ffmpeg --sudo
  install deno --sudo
  install love --sudo
  install beekeeper-studio-bin --aur
  install aws-cli --sudo
  install aws-session-manager-plugin --aur
  install vscodium-bin-marketplace --aur
  install onlyoffice-bin --aur
  install pulumi --sudo
  install github-cli --sudo

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

group "Set up PI Agent" {
  npm install -g @mariozechner/pi-coding-agent
  pi install npm:pi-psql
  pi install npm:@modemdev/glance-pi
}

group "📓 Zed configuration" {
  for file in ["settings", "keymap"] {
    let target_path = ($env.HOME | path join $".config/zed/($file).json")
    let source_path = (conf-src $"zed/($file).json")

    let last_update_of_target = (ls $target_path | get 0 | get modified)
    let last_update_of_source = (ls $source_path | get 0 | get modified)

    if $last_update_of_target > $last_update_of_source {
      if (user-confirm $"⚠️  Zed ($file).json target file is newer than source. Copy it over as the new standard file?") {
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
