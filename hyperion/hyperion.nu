use glue *

group "📦 System Packages" {
    install nushell --sudo {
        let nu_path = (which nu | first | get path)
        let shells = (open /etc/shells)
        if not ($shells | str contains $nu_path) {
            run-external "sudo" "tee" "-a" "/etc/shells" | $nu_path
        }
        run-external "sudo" "chsh" "-s" $nu_path $env.USER
        print $":: ✔️ Default shell set to ($nu_path)"
    }
    install sddm --sudo {
        run-external "sudo" "systemctl" "enable" "sddm"
        print ":: ✔️ SDDM enabled"
    }
    install niri --aur
}
