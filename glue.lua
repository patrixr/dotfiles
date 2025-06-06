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
    dotconfig("zed")
    dotconfig("ghostty")

    Blockinfile({
        state = true,
        block = read("./configs/nushell/config.nu"),
        path = "~/Library/Application Support/nushell/config.nu"
    })

    Blockinfile({
        state = true,
        block = read("./configs/zshrc.sh"),
        path = "~/.zshrc"
    })

    Blockinfile({
        state = true,
        path = "~/.gitconfig",
        block = trim([=[
          [core]
            pager = DELTA_FEATURES=$([[ $COLUMNS -gt 160 ]] && echo "side-by-side") delta
        ]=])
    })
end)

--
-- Homebrew packages
--
group("homebrew", function ()
    HomebrewInstall()

    Homebrew({
        taps =  {
        packages = {
            "delta",
            "nushell",
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
