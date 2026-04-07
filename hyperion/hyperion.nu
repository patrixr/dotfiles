use glue *

group "📦 System Packages" {

    install nushell {
        let nu_path = (which nu | first | get path)
        let shells = (open /etc/shells)
        if not ($shells | str contains $nu_path) {
            run-external "tee" "-a" "/etc/shells" | $nu_path
        }
        run-external "chsh" "-s" $nu_path $env.USER
        print $":: ✔️ Default shell set to ($nu_path)"
    }

    install sddm {
        run-external "systemctl" "enable" "sddm"
        print ":: ✔️ SDDM enabled"
    }

    install niri --aur
}
