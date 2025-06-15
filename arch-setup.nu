use glue.nu *

group "📦 Packages" {
    install i3-wm --sudo
    install i3blocks --sudo
    install i3lock --sudo
    install i3status --sudo
    install nitrogen --sudo
    install lxappearance --sudo
    install polybar --sudo
    install zed --aur
    install network-manager-applet --sudo
    install volumeicon --sudo
    install rofi --sudo
    install starship --sudo
    # install cerebro-bin --aur`
    #
    # pacman -S bc paru nerd-fonts
}

group "📁 Copy configurations" {
    def conf-src [name: string] {
        $env.FILE_PWD | path join ("configs/" + $name)
    }

    def dotconf [name: string] {
        let folder = conf-src $name
        cp -r $folder ~/.config
        print $"✅ ($name)"
    }

    dotconf i3
    dotconf polybar
    dotconf zed
    dotconf "starship.toml"

    touch ~/.config/nushell/config.nu
    cat (conf-src "nushell/config.nu") | inject $"($env.HOME)/.config/nushell/config.nu"
}
