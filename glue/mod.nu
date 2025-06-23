# ---------------------------------------------------------
# --- Utils
# ---------------------------------------------------------

export def group [name: string block: closure] {
  print $":: ($name)"
  do $block
}

export def super-trim [] {
  $in | lines | each { str trim } | str join "\n"
}

export def macos? []: nothing -> bool {
  $nu.os-info.name == "macos"
}

export def linux? [] {
  $nu.os-info.name == "linux"
}

export def macos [fn: closure] {
  if (macos?) {
    do $fn
  }
}

export def linux [fn: closure] {
  if (linux?) {
    do $fn
  }
}

export def can-run [cmd: string] {
    (which $cmd | length) > 0
}

export def boom [msg: string] {
    error make { msg: $msg }
}

export def platorm-do [plan: record] {
    if (macos?) and ("macos" in $plan) {
        do $plan.macos
    } else if (linux?) and ("linux" in $plan) {
        do $plan.linux
    } else if ("default" in $plan) {
        do $plan.default
    } else {
        boom $"No implementation for the current platform: ($nu.os-info.name)"
    }
}

# Source: https://github.com/NotTheDr01ds/ntd-nushell_scripts
export def unindent []: string -> string {
  let text = $in
  let length = ($text | lines | length)

  let lines = $text | lines

  # Determine if first and/or last lines are empty and should be dropped
  let doNothing = {||}
  let ifSkipFirst = match ($lines | first | str trim) {
    "" => {{skip}}
    _ => {$doNothing}
  }
  let ifDropLast = match ($lines | last | str trim) {
    "" => {{drop}}
    _ => {$doNothing}
  }

  let lines = (
    $lines
    | do $ifSkipFirst
    | do $ifDropLast
  )
  | # Convert list to table
  | wrap text

  let minimumIndent = (
    # Add a column to each row with the number of leading spaces
    $lines | insert indent {|line|
      if ($line.text | str trim | is-empty) {
        # If the line contains only whitespace, don't consider it
        null
      } else {
        $line.text
        | parse -r '^(?<indent> +)'
        | get indent.0?
        | default ''
        | str length
      }
    }
    | # And return the minimum
    | get indent
    | math min
  )

  let spaces = ('' | fill -c ' ' -w $minimumIndent)

  $lines
  | update text {|line|
      $line.text
      | str replace -r $'^($spaces)' ''
    }
  | get text
  | to text

}

# -----------------------------------------------------
# --- System tooling
# -----------------------------------------------------

export def cli-installer [cmd: string, cl: closure] {
    if (can-run $cmd) == false {
        do $cl
    }
}

def is-installed [name: string] {
    platorm-do ({
        linux: {
            let search_result_1 = run-external "pacman" "-Qi" $name | complete
            let search_result_2 = run-external "yay" "-Qi" $name | complete
            return (($search_result_1.exit_code == 0) or ($search_result_2.exit_code == 0))
        },
        macos: {
            let search_result = run-external "brew" "list" $name | complete
            return ($search_result.exit_code == 0)
        }
    })
}

export def install [name: string, postinstall?: closure, --aur, --sudo, --cask] {
    if (is-installed $name) {
        print $"::✔️ ($name)"
        return
    }

    linux {
        let cmd = if $aur { "yay" } else { "pacman" }
        if $sudo {
            run-external "sudo" $cmd "-S" $name "--noconfirm"
        } else {
            run-external $cmd "-S" $name "--noconfirm"
        }
    }

    macos {
        if $cask {
            run-external "brew" "install" "--cask" $name
        } else {
            run-external "brew" "install" $name
        }
    }

    if $postinstall != null {
      do $postinstall
    }

    print $"🆕 ($name)"
}

export def inject [file_path] {
    let block_content = $in
    let start_marker_text = "# BEGIN MANAGED BLOCK"
    let end_marker_text = "# END MANAGED BLOCK"
    let existing_content = open $file_path
    let start_marker_search = ($existing_content | lines | enumerate | where $it.item == $start_marker_text)
    let end_marker_search = ($existing_content | lines | enumerate | where $it.item == $end_marker_text)

    if ($start_marker_search | length) > 0 and ($end_marker_search | length) > 0 {
        let start_marker_idx = $start_marker_search | first | get index
        let end_marker_idx = $end_marker_search | last | get index

        let content = $existing_content | lines | enumerate | where ($it.index < $start_marker_idx or $it.index > $end_marker_idx) | get item | str join "\n"
        $content | save -f $file_path
    }

    let managed_block = (
        "\n" + $start_marker_text + "\n" + $block_content + "\n" + $end_marker_text
    )
    $managed_block | save --append $file_path
}

# -----------------------------------------------------
# --- Addons tooling
# -----------------------------------------------------

const vendor_path = $nu.data-dir | path join "vendor"
const autoload_dir = $vendor_path | path join "autoload"

export def vendor-install [repo: string, fn: closure] {
    let name = $repo | path basename
    let location = ($vendor_path | path join $name)

    if ($location | path exists) == false {
        mkdir $vendor_path
        print $"::vendor-install ($name)"
        git clone --depth=1 $"https://($repo)" $location
        do $fn $location
    }
}

export def autoload-script [name: string, fn: closure] {
    let location = ($autoload_dir | path join $name)
    if ($location | path exists) == false {
        print $"::autoload-script ($name)"
        mkdir $autoload_dir
        do $fn | save -f $location
    }
}
