use glue *

group "📦 System Packages" {

    install nushell {
        let nu_path = (which nu | first | get path)
        let shells = (open /etc/shells)
        if not ($shells | str contains $nu_path) {
            run-external "tee" "-a" "/etc/shells" | $nu_path
        }
        let target_user = ($env | get -i HYPERION_USER | default $env.USER)
        run-external "chsh" "-s" $nu_path $target_user
        print $":: ✔️ Default shell set to ($nu_path)"
    }

    install sddm {
        run-external "systemctl" "enable" "sddm"
        print ":: ✔️ SDDM enabled"
    }

    install niri --aur
}
