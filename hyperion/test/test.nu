#!/usr/bin/env nu

const IMAGE_NAME    = "hyperion-eos-test"
const TIMEOUT_SECS  = 300

print "🧪 Hyperion CE — Test Runner"
print "================================"

let test_dir    = $env.FILE_PWD
let repo_root   = $test_dir | path join "../.."
let dockerfile  = $test_dir | path join "Dockerfile"

# ---------------------------------------------------------------------------
# Build
# ---------------------------------------------------------------------------
print "\n:: Building test Docker image..."

let build = (run-external "docker" "build"
    "-t" $IMAGE_NAME
    "-f" $dockerfile
    $repo_root
    | complete)

if $build.exit_code != 0 {
    print "❌ Docker build failed:"
    print $build.stderr
    exit 1
}

print "✅ Image built"

# ---------------------------------------------------------------------------
# Run hyperion.nu + inline assertions in a single container pass
# ---------------------------------------------------------------------------
print $"\n:: Running hyperion.nu inside container \(timeout: ($TIMEOUT_SECS)s\)..."

let script = $"
    timeout ($TIMEOUT_SECS) nu /dotfiles/hyperion/hyperion.nu
    echo '---ASSERTIONS---'
    pacman -Qi nushell  > /dev/null 2>&1 && echo 'PASS: nushell installed'  || echo 'FAIL: nushell not installed'
    pacman -Qi sddm     > /dev/null 2>&1 && echo 'PASS: sddm installed'     || echo 'FAIL: sddm not installed'
    command -v nu       > /dev/null 2>&1 && echo 'PASS: nu in PATH'         || echo 'FAIL: nu not in PATH'
"

let run = (run-external "docker" "run"
    "--rm"
    "--name" "hyperion-test-run"
    "--volume" $"($repo_root):/dotfiles"
    "--env" "USER=root"
    $IMAGE_NAME
    "bash" "-c" $script
    | complete)

# Check timeout
if $run.exit_code == 124 {
    print $"❌ Timed out after ($TIMEOUT_SECS)s"
    exit 1
}

# Split output into install log and assertions
let lines = $run.stdout | lines

let assert_start = $lines | enumerate | where { |l| $l.item == "---ASSERTIONS---" } | first

# If we never reached the assertions marker the script itself failed
if $assert_start == null {
    print "❌ hyperion.nu did not complete — output:"
    print $run.stdout
    print $run.stderr
    exit 1
}

let install_log  = $lines | first $assert_start.index
let assert_lines = $lines | skip ($assert_start.index + 1)

print "\n:: Install log:"
for l in $install_log { print $l }

# ---------------------------------------------------------------------------
# Results
# ---------------------------------------------------------------------------
print "\n:: Assertions:"

let passed = $assert_lines | where { |l| $l | str starts-with "PASS" }
let failed = $assert_lines | where { |l| $l | str starts-with "FAIL" }

for a in $assert_lines { print $a }

print ""
print $"Results: ($passed | length) passed, ($failed | length) failed"

if ($failed | length) > 0 {
    print "❌ Some assertions failed"
    exit 1
}

print "✅ All assertions passed"
