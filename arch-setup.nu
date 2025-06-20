use glue.nu *

def conf-src [name: string] {
    $env.FILE_PWD | path join ("configs/" + $name)
}

group "📦 Packages" {
    install hyprland --sudo
    install hypridle --sudo
    install hyprlock --sudo
    install hyprpaper --sudo
    install hyprshot --sudo
    install zed --aur
    install network-manager-applet --sudo
    install volumeicon --sudo
    install waybar --sudo
    install starship --sudo
    install fuzzel --sudo
    install thunar --sudo
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

group "📁 Copy configurations" {

    def dotconf [name: string] {
        let folder = conf-src $name
        cp -r $folder ~/.config
        print $"✅ ($name)"
    }

    dotconf hypr
    dotconf waybar
    dotconf ghostty
    dotconf "starship.toml"

    touch ~/.config/nushell/config.nu
    cat (conf-src "nushell/config.nu") | inject $"($env.HOME)/.config/nushell/config.nu"

    glob (conf-src "greetd/*") | each { sudo cp $in /etc/greetd }
}

group "📓 Zed configuration" {
    let current_config = open ~/.config/zed/settings.json
    let saved_config = open (conf-src "zed/settings.json")

    $current_config | merge $saved_config | save -f  ~/.config/zed/settings.json
    cp (conf-src "zed/keymap.json") ~/.config/zed/
}

group "💾 Install glue.nu" {
    cp  ($env.FILE_PWD | path join "glue.nu")  ~/.config/nushell
}

group "🎨 Assets" {
  let greetd_bg = "bg-1.jpg"

  mkdir ~/Pictures/system
  glob ($env.FILE_PWD | path join "images/*") | each { cp $in ~/Pictures/system }
  sudo cp ($env.FILE_PWD | path join "images" | path join $greetd_bg) /etc/greetd/bg.jpg
}

group "Reload" {
  hyprctl reload
}
