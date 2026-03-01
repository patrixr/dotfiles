use ../glue *

def conf-src [name: string] {
    $env.FILE_PWD | path join ("../configs/" + $name)
}

group "📦 System Packages" {
  install niri --aur
  install noctalia-shell --aur
  install ghostty --sudo
  install fuzzel --sudo
  install swaybg --sudo
  install ttf-jetbrains-mono-nerd --sudo
  install xwayland-satellite --sudo
  install xclip --sudo
  install adw-gtk-theme --aur
  install nwg-look --aur {
    gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3-dark'
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
  }
  install keyd --sudo {
    sudo usermod -aG keyd $env.USER
    sudo systemctl -f enable keyd.service
    sudo systemctl -f start keyd.service
  }
}

group "📁 System dot configs" {
  def dotconf [name: string] {
      let folder = conf-src $name
      cp -r $folder ~/.config
      print $":: ✔️ .configs/($name)"
  }

  dotconf niri
}

group "🖼️ Wallpapers" {
  mkdir ~/Pictures/Wallpapers
  let images_folder = $env.FILE_PWD | path join "../images"
  for file in (ls $images_folder | where type == file) {
    cp $file.name ~/Pictures/Wallpapers/
  }
  print ":: ✔️ Wallpapers copied to ~/Pictures/Wallpapers"
}

group "🎹 Keybinds" {
  linux {
    sudo mkdir -p /etc/keyd
    sudo cp (conf-src "keyd/default.conf") /etc/keyd/default.conf
    sudo keyd reload
  }
}

group "💾 Install glue.nu" {
    cp -r ($env.FILE_PWD | path join "../glue") $nu.default-config-dir
}

group "🐚 Nushell config" {
  touch $nu.config-path
  cat (conf-src "nushell.nu") | inject into $nu.config-path

  install starship --sudo

  nu-autoload-script "starship.nu" {
    starship init nu
  }
}
