use glue *


def conf-src [name: string] {
    $env.FILE_PWD | path join ("configs/" + $name)
}

group "📦 System Packages" {
  install niri --aur
  install noctalia-shell --aur
  install ghostty --sudo
  install fuzzel --sudo
  install ttf-jetbrains-mono-nerd --sudo
  install xwayland-satelite --sudo

  # install hyprland --sudo
  # install hypridle --sudo
  # install hyprlock --sudo
  # install hyprpaper --sudo
  # install hyprshot --sudo
  # install network-manager-applet --sudo
  # install volumeicon --sudo
  # install waybar --sudo
  # install fuzzel --sudo
  # install thunar --sudo
  # install keyd --sudo {
  #     sudo usermod -aG keyd $env.USER
  #     sudo systemctl -f enable keyd.service
  #     sudo systemctl -f start keyd.service
  # }
  # install greetd --sudo {
  #     sudo systemctl -f enable greetd.service
  # }
  # install greetd-tuigreet --sudo
  # install ttf-jetbrains-mono --sudo
  # install ttf-nerd-fonts-symbols --sudo
  # install ttf-ubuntu-font-family --sudo
  # install wayland-protocols --sudo
  # install wl-clipboard
  # install blueman --sudo {
  #     sudo systemctl -f enable bluetooth.service
  #     sudo systemctl -f start bluetooth.service
  # }
}
