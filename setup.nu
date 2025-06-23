use glue.nu *

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
            sudo usermod -aG keyd $env.USER
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
}

group "📦 User Packages" {
    install zed --aur --cask
    install starship --sudo
    install steam --sudo --cask
}

group "💻 Development tools" {
    cli-installer "volta" {
        bash -c "curl https://get.volta.sh | bash"
    }

    install go --sudo
    install docker-desktop --aur

    linux {
        install zen-browser-bin --aur

        # For zed
        install vulkan-icd-loader --sudo
        install vulkan-intel --sudo
    }

    macos {
        install zen --cask
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
        print $"✅ ($name)"
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
    cat (conf-src "nushell/config.nu") | inject $nu.config-path
}

group "📓 Zed configuration" {
    let current_config = open ~/.config/zed/settings.json
    let saved_config = open (conf-src "zed/settings.json")

    $current_config | merge $saved_config | save -f  ~/.config/zed/settings.json
    cp (conf-src "zed/keymap.json") ~/.config/zed/
}

group "💾 Install glue.nu" {
    cp  ($env.FILE_PWD | path join "glue.nu") $nu.default-config-dir
}

group "🎨 Assets" {
    linux {
        let selected_bg = "bg-3.jpg"

        mkdir ~/Pictures/system
        glob ($env.FILE_PWD | path join "images/*") | each { cp $in ~/Pictures/system }
        sudo cp ($env.FILE_PWD | path join "images" | path join $selected_bg) /etc/greetd/bg.jpg
        cp ($env.FILE_PWD | path join "images" | path join $selected_bg) ~/Pictures/system/active-bg.jpg
    }
}

group "♻️ Reload" {
    linux { hyprctl reload }
}
