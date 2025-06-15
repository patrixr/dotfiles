export def group [name: string block: closure] {
  print $"[--- ($name) ---]"
  do $block
}

export def super-trim [] {
  $in | lines | each { str trim } | str join "\n"
}

export def install [name: string, --aur, --sudo] {
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
    print $"🆕 ($name)"
}

export def inject [file_path] {
    print $file_path
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
