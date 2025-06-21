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

export def macos [fn: closure] {
  if $nu.os-info.name == "macos" {
    do $fn
  }
}

export def linux [fn: closure] {
  if $nu.os-info.name == "linux" {
    do $fn
  }
}

# -----------------------------------------------------
# --- System tooling
# -----------------------------------------------------

export def install [name: string, postinstall?: closure, --aur, --sudo] {
    let cmd = if $aur { "yay" } else { "pacman" }
    let search_result = run-external $cmd "-Qi" $name | complete
    if $search_result.exit_code == 0 {
      print $"✅ ($name)"
      return
    }
    if $sudo {
      run-external "sudo" $cmd "-S" $name "--noconfirm"
    } else {
      run-external $cmd "-S" $name "--noconfirm"
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
