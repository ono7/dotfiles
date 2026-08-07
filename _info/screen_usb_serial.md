---

## name: usb-serial-screen-troubleshooting-guide
description: A guide for diagnosing and fixing Prolific USB-to-Serial adapter permissions and GNU Screen access on Arch Linux.

# Prolific USB-to-Serial & GNU Screen Troubleshooting Guide (Arch Linux)

This guide documents the steps required to verify hardware detection, resolve kernel module and user permission issues, and successfully connect to a serial console using GNU Screen on Arch Linux.

---

## 1. Verify Hardware and Kernel Detection

install tools

sudo pacman -S screen usbutils picocom

### Check USB Bus Detection

Ensure the Prolific adapter is physically recognized by the system bus:

```bash
lsusb

```

_Look for:_ `Prolific Technology Inc. USB-Serial Controller D` (Vendor `067b`, Product `2303`).

### Check Kernel Module Loading Status

Verify if the `pl2303` serial driver is loaded in the kernel:

```bash
lsmod | grep pl2303

```

If no output appears, manually load the driver:

```bash
sudo modprobe pl2303

```

### Troubleshoot Kernel/Module Mismatch

If the module fails to load or path checks fail, verify that your modules match your running kernel version:

```bash
find /lib/modules/$(uname -r) -name "*pl2303*"

```

> **Note:** If this returns `No such file or directory`, your system likely underwent a kernel update without a subsequent reboot. A simple reboot (`sudo reboot`) will align your running kernel with its loaded modules.

---

## 2. Configure Device Permissions (`uucp` Group)

Arch Linux assigns serial device nodes (such as `/dev/ttyUSB0`) to the `uucp` group by default. Standard users cannot open these ports without root privileges unless added to this group.

### Check Device Ownership

```bash
ls -l /dev/ttyUSB0

```

_Expected output group:_ `uucp`

### Add Your User to the `uucp` Group

```bash

# for Arch
sudo usermod -aG uucp $USER
newgrp uucp

# for Ubuntu
sudo usermod -aG dialout $USER
newgrp dialout
```

### Apply Group Permissions to Current Shell

To apply group membership changes immediately without logging out and back in, run:

```bash

```

---

## 3. Connect Using GNU Screen

Once permissions and modules are verified, open the serial port with GNU Screen at your target baud rate (e.g., `115200`):

```bash
screen /dev/ttyUSB0 115200

```

### Troubleshooting "screen is terminating" Immediately

If `screen` exits instantly with `[screen is terminating]`, resolve it using the following checks:

1. **Verify Port Availability:** Ensure another process or session isn't already locking the serial port:

```bash
sudo fuser /dev/ttyUSB0

```

2. **Test with `picocom`:** If Screen continues to fail due to terminal lockups or configuration quirks, isolate the issue by using a lightweight alternative:

```bash
sudo pacman -S picocom
picocom -b 115200 /dev/ttyUSB0

```

_(To exit `picocom`, press `Ctrl + A` followed by `Ctrl + X`)._
