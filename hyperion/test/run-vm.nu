#!/usr/bin/env nu
# EndeavourOS QEMU VM with Wayland/GPU acceleration
# Usage: nu run-vm.nu [--reset]  (use --reset to delete existing VM disk)

def main [--reset] {
    let DISK = $"($env.HOME)/endeavour-vm.qcow2"
    let MEMORY = "4G"
    let CPUS = "4"
    let DISK_SIZE = "32G"

    # Delete existing disk if --reset flag is used
    if $reset and ($DISK | path exists) {
        print "🗑️  Resetting VM (deleting existing disk)..."
        rm $DISK
        print $"✅ Deleted ($DISK)\n"
    }

    # Find ISO files in Downloads
    let downloads_dir = $env.HOME | path join "Downloads"
    let isos = try {
        ls $downloads_dir 
        | where type == file 
        | where name =~ '\.iso$'
        | where name =~ '(?i)endeavour'
    } catch {
        []
    }

    if ($isos | length) == 0 {
        print "❌ No EndeavourOS ISO files found in ~/Downloads"
        exit 1
    }

    # Select ISO
    let iso = if ($isos | length) == 1 {
        $isos | first | get name
    } else {
        print "Multiple ISOs found:"
        $isos | enumerate | each { |it| print $"  ($it.index + 1). ($it.item.name | path basename)" }
        print ""
        let choice = (input "Select ISO number: " | into int)
        $isos | get ($choice - 1) | get name
    }

    print $"Using ISO: ($iso | path basename)"

    # Create disk image if it doesn't exist
    if not ($DISK | path exists) {
        print "Creating virtual disk..."
        run-external "qemu-img" "create" "-f" "qcow2" $DISK $DISK_SIZE
    }

    # Check if booting from install or installed system
    let boot_mode = if ($DISK | path exists) {
        let disk_size = (ls $DISK | first | get size)
        if $disk_size < 1mb {
            "d"  # Empty disk, boot from CD
        } else {
            let response = (input "Boot from [i]nstalled system or [c]drom? (i/c): ")
            if $response == "c" { "d" } else { "c" }
        }
    } else {
        "d"  # Boot from CD for first install
    }

    print $"Boot mode: (if $boot_mode == 'd' { 'CDROM (install)' } else { 'Disk (installed system)' })"

    # Build QEMU command
    let qemu_args = [
        "-enable-kvm"
        "-m" $MEMORY
        "-smp" $CPUS
        "-cpu" "host"
        "-device" "virtio-vga-gl"
        "-display" "gtk,gl=on,grab-on-hover=on"
        "-device" "qemu-xhci"
        "-device" "usb-tablet"
        "-device" "virtio-serial-pci"
        "-chardev" "spicevmc,id=vdagent,name=vdagent"
        "-device" "virtserialport,chardev=vdagent,name=com.redhat.spice.0"
        "-drive" $"file=($DISK),if=virtio,format=qcow2"
        "-boot" $boot_mode
        "-audio" "pa,model=hda"
        "-net" "nic,model=virtio"
        "-net" "user"
    ]

    # Add CDROM only if booting from it or user wants it
    let qemu_args = if $boot_mode == "d" {
        $qemu_args | append ["-cdrom" $iso]
    } else {
        $qemu_args
    }

    # Run QEMU
    print "\n🚀 Starting VM...\n"
    run-external "qemu-system-x86_64" ...$qemu_args
}
