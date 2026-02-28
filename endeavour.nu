use glue *


def conf-src [name: string] {
    $env.FILE_PWD | path join ("configs/" + $name)
}

group "📦 System Packages" {
  install niri --aur
  install noctalia-shell --aur
  install ghostty --sudo
  install fuzzel --sudo
  install swaybg --sudo
  install ttf-jetbrains-mono-nerd --sudo
  install xwayland-satellite --sudo
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
  let images_folder = $env.FILE_PWD | path join "images"
  cp -r ($images_folder | path join "*") ~/Pictures/Wallpapers/
  print ":: ✔️ Wallpapers copied to ~/Pictures/Wallpapers"
}
