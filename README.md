# The Simple OS

## Description

A Linux distro that's heavily modified to improve user experience.

Part of the project contains:
- A set of desktop utilities
- Custom package manager
- Non-standard file system to simplify experience

## Building

1. Install dependencies:
- 64-bit Linux Dev machine (Arch recommended as it's the easiest to get software for)
- Bash >= 3.2
- Binutils >= 2.13.1
- Bison >= 2.7
- Coreutiles >= 6.9
- Diffutils >= 2.8.1
- Findutils >= 4.2.31
- Gawk >= 4.0.1
- Gcc >= 4.8 (with c++)
- Grep >= 2.5.1a
- Gzip >= 1.3.12
- Linux Kernel >= 3.2
- M4 >= 1.4.10
- Make >= 4.0
- Patch >= 2.5.4
- Perl >= 5.8.8
- Python >= 3.4
- Sed >= 4.1.5
- Tar >= 1.22
- Texinfo >= 4.7
- Xz >= 5.0.0

2. Create a partition around 20-30GB. I recommend using an SD Card. Mine auto-mounts to `/run/media/$USER/SimpleOS/`, so that's what I'll use. If yours is different, replace it in the commands below. You can also just install directly to a hard drive

3. Mount the partition

4. Create a /run/media/\$USER/SimpleOS/sources folder as root with special permissions:
- `sudo mkdir /run/media/$USER/SimpleOS/sources`
- `sudo chmod a+wt /run/media/$USER/SimpleOS/sources`

5. As root, create folders /run/media/\$USER/SimpleOS/usr, /run/media/\$USER/SimpleOS/usr/bin, /run/media/\$USER/SimpleOS/usr/sbin, /run/media/\$USER/SimpleOS/usr/lib, /run/media/\$USER/SimpleOS/usr/lib64, /run/media/\$USER/SimpleOS/etc, /run/media/\$USER/SimpleOS/var, and /run/media/\$USER/SimpleOS/tools
- `sudo mkdir -p /run/media/$USER/SimpleOS/{usr{,/bin,/sbin,/lib,/lib64},etc,var,sources,tools}`

6. Allow your user to make changes
- `sudo chown $USER /run/media/$USER/SimpleOS/{usr{,/*},etc,var,sources,tools}`

7. Run `make PART=/run/media/$USER/SimpleOS`
