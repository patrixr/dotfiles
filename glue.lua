--
-- Copies a .config/x folder into the home
--
local function dotconfig(name)
    note(capitalize(name))
    Copy({
        source = "./configs/" .. name,
        dest = "~/.config/" .. name,
        strategy = "merge"
    })
end

--
-- Configuration files
--
group("configs", function ()
    note("Zshrc")

    dotconfig("alacritty")
    dotconfig("emacs")
    dotconfig("tmux")

    Blockinfile({
        state = true,
        block = read("./configs/zshrc.sh"),
        path = "~/.zshrc"
    })
end)

--
-- Homebrew packages
--
group("homebrew", function ()
    HomebrewInstall()

    Homebrew({
        taps =  {
            "oven-sh/bun",
            "homebrew/cask-fonts",
            "tronica/tap",
        },
        casks = {
           "zen-browser",
            "steam",
            "emacs",
            "love",
            "redisinsight",
            "docker",
            "obsidian",
            "ghostty",
            "raycast",
            "intellij-idea-ce",
            "zoom",
            "microsoft-teams",
            "google-chrome",
            "discord",
            "godot",
            "authy",
            "protonvpn",
            "font-roboto-mono-nerd-font",
            "font-meslo-lg-nerd-font",
            "android-commandlinetools",
            "alacritty",
            "android-studio",
            "proton-drive",
        },
        packages = {
           "auteur",
            "gnupg",
            "typst",
            "gleam",
            "openssl@3",
            "gnu-tar",
            "cmake",
            "zsh",
            "wget",
            "pandoc",
            "imagemagick",
            "tmux",
            "ripgrep",
            "coreutils",
            "fd",
            "ffmpeg",
            "watch",
            "httpie",
            "ruby",
            "bun",
            "deno",
            "nvm",
            "go",
            "gopls",
            "clojure/tools/clojure",
            "clojure-lsp/brew/clojure-lsp-native",
            "leiningen",
            "gh",
            "neofetch",
            "terraform",
            "ansible",
            "powerlevel10k",
            "zsh-autosuggestions",
            "zsh-syntax-highlighting",
            "eza",
            "lua",
        }
    })
end)
