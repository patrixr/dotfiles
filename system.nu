use glue *


def conf-src [name: string] {
    $env.FILE_PWD | path join ("configs/" + $name)
}

group "📦 System Packages" {
    linux {
        install hyprland --sudo
        install hypridle --sudo
        install hyprlock --sudo
        install hyprpaper --sudo
        install hyprshot --sudo
        install network-manager-applet --sudo
        install volumeicon --sudo
        install waybar --sudo
        install fuzzel --sudo
        install thunar --sudo
        install keyd --sudo {
            sudo usermod -aG keyd $env.USERq
            sudo systemctl -f enable keyd.service
            sudo systemctl -f start keyd.service
        }
        install greetd --sudo {
            sudo systemctl -f enable greetd.service
        }
        install greetd-tuigreet --sudo
        install ttf-jetbrains-mono --sudo
        install ttf-nerd-fonts-symbols --sudo
        install ttf-ubuntu-font-family --sudo
        install wayland-protocols --sudo
        install wl-clipboard
        install blueman --sudo {
            sudo systemctl -f enable bluetooth.service
            sudo systemctl -f start bluetooth.service
        }
    }

    install sshpass --sudo
}

group "📦 User Packages" {
    install zed --aur --cask
    install starship --sudo
    install steam --sudo --cask
    install beekeeper-studio --sudo --cask

    linux {
      install slack-desktop --aur
    }
}

group "💻 Development tools" {
    cli-installer "volta" {
        bash -c "curl https://get.volta.sh | bash"
    }

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
        install vulkan-icd-loader --sudo
        install vulkan-intel --sudo
        install pulumi --sudo
    }

    macos {
        install zen --cask
        install emacs
    }
}

group "🎹 Keybinds" {
    linux {
        sudo mkdir -p /etc/keyd
        sudo cp (conf-src "keyd/default.conf") /etc/keyd/default.conf
        sudo keyd reload
    }
}

group "📁 Dot configs" {
    def dotconf [name: string] {
        let folder = conf-src $name
        cp -r $folder ~/.config
        print $":: ✔️ .configs/($name)"
    }

    linux {
        dotconf hypr
        dotconf waybar
        dotconf fuzzel
    }
    dotconf emacs
    dotconf ghostty
    dotconf "starship.toml"

    rm -rf ~/.emacs.d
}

group "🐧 System setup" {
    linux { glob (conf-src "greetd/*") | each { sudo cp $in /etc/greetd } }
}

group "🐚 Nushell config" {
    touch $nu.config-path
    cat ($env.FILE_PWD | path join "nushell.nu") | inject into $nu.config-path

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

group "🎨 Assets" {
    linux {
        let ultrawide = hyprctl monitors | str contains "3440x"
        let selected_bg = if $ultrawide { "bg-wide-1.jpg" } else { "bg-3.jpg" }

        mkdir ~/Pictures/system
        glob ($env.FILE_PWD | path join "images/*") | each { cp $in ~/Pictures/system }
        sudo cp ($env.FILE_PWD | path join "images" | path join $selected_bg) /etc/greetd/bg.jpg
        cp ($env.FILE_PWD | path join "images" | path join $selected_bg) ~/Pictures/system/active-bg.jpg
    }
}

group "Homelab" {
  return # disabled

  let ip = "192.168.1.103"
  let user = "pi"

  if (sshable $ip) {
    let pw = input ":: Pi password: " --suppress-output
    let remote_file = "/tmp/homelab.yml"
    let host = $"($user)@($ip)"

    sshpass -p $pw ssh $host  'command -v docker >/dev/null 2>&1 || curl -fsSL https://get.docker.com | bash'
    sshpass -p $pw scp $"($env.FILE_PWD)/homelab.env" $"($host):/home/pi/homelab.env"
    sshpass -p $pw scp $"($env.FILE_PWD)/homelab.yml" $"($host):/home/pi/homelab.yml"
    sshpass -p $pw ssh $host "mkdir -p /home/pi/n8n"
    sshpass -p $pw ssh $host "mkdir -p /home/pi/n8n-files"
    sshpass -p $pw ssh $host "sudo chown -R 1000:1000 /home/pi/n8n"
    sshpass -p $pw ssh $host "sudo chown -R 1000:1000 /home/pi/n8n-files"
    sshpass -p $pw ssh $host  $"sudo docker compose --env-file homelab.env --file /home/pi/homelab.yml up --force-recreate -d"
  }
}

group "♻️ Reload" {
    linux { hyprctl reload }
}
