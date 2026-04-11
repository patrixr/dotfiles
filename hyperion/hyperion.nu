use glue *

def conf-src [name: string] {
    $env.FILE_PWD | path join ("configs/" + $name)
}

def home-dir [] {
    let target_user = ($env | get --optional HYPERION_USER | default $env.USER)
    $"/home/($target_user)"
}

# Deploys a config folder to both the target user's ~/.config and /etc/skel/.config
def dotconf [name: string] {
    let folder = conf-src $name
    let destinations = [
        (home-dir | path join ".config")
        "/etc/skel/.config"
    ]
    for dest in $destinations {
        mkdir $dest
        cp -r $folder $dest
    }
    print $":: ✔️ .config/($name)"
}

group "📦 System Packages" {

    install nushell {
        let nu_path = (which nu | first | get path)
        let shells = (open /etc/shells)
        if not ($shells | str contains $nu_path) {
            run-external "tee" "-a" "/etc/shells" | $nu_path
        }
        let target_user = ($env | get --optional HYPERION_USER | default $env.USER)
        run-external "chsh" "-s" $nu_path $target_user
        print $":: ✔️ Default shell set to ($nu_path)"
    }

    install sddm {
        run-external "systemctl" "enable" "sddm"
        print ":: ✔️ SDDM enabled"
    }

    install niri
    install ghostty

    with-chaotic-aur {
        install noctalia-shell
    }
}

group "📁 Configs" {
    dotconf niri
    dotconf noctalia
}

group "🖼️ Wallpapers" {
    let images_folder = $env.FILE_PWD | path join "images"
    let destinations = [
        (home-dir | path join "Pictures/Wallpapers")
        "/etc/skel/Pictures/Wallpapers"
    ]
    for dest in $destinations {
        mkdir $dest
        for file in (ls $images_folder | where type == file) {
            cp $file.name $dest
        }
    }
    print ":: ✔️ Wallpapers copied to user home and /etc/skel"
}
