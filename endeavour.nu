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
  install adw-gtk-theme --aur
  install nwg-look --aur
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
  for file in (ls $images_folder | where type == file) {
    cp $file.name ~/Pictures/Wallpapers/
  }
  print ":: ✔️ Wallpapers copied to ~/Pictures/Wallpapers"
}
