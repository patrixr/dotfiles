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
    # install cerebro-bin --aur`
    #
    # pacman -S bc paru nerd-fonts
}

group "📁 Copy configurations" {
    def dotconf [name: string] {
        let folder = $env.FILE_PWD | path join ("configs/" + $name)
        cp -r $folder ~/.config
        print $"✅ ($name)"
    }

    dotconf i3
    dotconf polybar
}
