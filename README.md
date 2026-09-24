# Device Tree Compiler (dtc) for Windows&reg; and Linux&reg;

Build Windows and Linux compatible Device Tree Compiler (`dtc.exe` / `dtc`) binaries to compile, decompile, and validate device tree source files (`.dts`) and device tree blobs (`.dtb`).

# What is dtc?

The Device Tree Compiler (`dtc`) is the standard tool for working with device trees in embedded Linux systems. It enables:

- **Compiling** device tree source (`.dts`) to binary blobs (`.dtb`)
- **Decompiling** binary blobs (`.dtb`) back to readable source (`.dts`)
- **Building overlays** (`.dtbo`) for runtime device tree modifications
- **Validating** device tree syntax and structure

This repository provides the source code and automated build scripts to build `dtc` natively for Linux and cross-compile `dtc.exe` for Windows from a Linux&reg; host.

# Requirements

A Linux&reg; host (Ubuntu 22.04 or later recommended) with `apt` package manager. Install all required packages by running the below command in your Linux terminal.

For **Linux-only** builds:

```
sudo apt-get update
sudo apt-get install meson ninja-build pkg-config flex bison
```

For **Windows cross-compilation** (additional package):

```
sudo apt-get update
sudo apt-get install gcc-mingw-w64-x86-64 meson ninja-build pkg-config flex bison
```

# Build dtc Using MathWorks Build Script

This section explains how to build `dtc` using the provided build script. The script supports building for Linux, Windows, or both platforms.

1. Clone the MathWorks&reg; device tree compiler repository.

	```
	git clone https://insidelabs-git.mathworks.com/EmbeddedLinux/device-tree-compiler.git
	```

2. Navigate to the `mw-dtc` directory.

	```
	cd device-tree-compiler/mw-dtc
	```

3. Run the build script.

	```
	chmod +x build_dtc.sh
	./build_dtc.sh              # Build for both platforms (default)
	./build_dtc.sh Windows      # Build Windows dtc.exe only
	./build_dtc.sh Linux        # Build Linux dtc only
	```

	The argument is case-insensitive (`Windows`, `WINDOWS`, `windows` are all valid).

4. The built binaries will be available at:

	```
	mw-dtc/output/build-win/dtc.exe    # Windows binary
	mw-dtc/output/build-lin/dtc        # Linux binary
	```

# Build the dtc Manually

If you wish to build `dtc` manually, follow the steps mentioned in this section.

1. Clone the MathWorks device tree compiler repository.

	```
	git clone https://insidelabs-git.mathworks.com/EmbeddedLinux/device-tree-compiler.git
	```

2. Navigate to the dtc source directory.

	```
	cd device-tree-compiler/mw-dtc/dtc-1.7.2
	```

3. Configure and build.

### For Linux (native build)

```
meson setup \
    -Dtests=false \
    -Dtools=true \
    -Dyaml=disabled \
    -Dpython=disabled \
    build-lin
meson compile -C build-lin
```

The built `dtc` will be available at `mw-dtc/dtc-1.7.2/build-lin/dtc`.

### For Windows (cross-compile)

```
meson setup --cross-file ../mingw-w64-cross.txt \
    -Dtests=false \
    -Dtools=true \
    -Dyaml=disabled \
    -Dpython=disabled \
    build-win
meson compile -C build-win
```

The built `dtc.exe` will be available at `mw-dtc/dtc-1.7.2/build-win/dtc.exe`.

# Usage

After building, you can use `dtc` (Linux) or `dtc.exe` (Windows) for device tree compilation and decompilation.

```
dtc -I dts -O dtb -o output.dtb input.dts
dtc -I dtb -O dts -o output.dts input.dtb
dtc -@ -I dts -O dtb -o overlay.dtbo overlay.dts
```

### Usage from MATLAB&reg;

```matlab
setenv('PATH', ['<path-to-dtc-exe-directory>;' getenv('PATH')]);
!dtc -I dts -O dtb -o output.dtb input.dts
```

Or call directly with the full path:

```matlab
[status, result] = system('"<path-to-dtc-exe>" -I dts -O dtb -o output.dtbo input.dts')
```

# Repository Structure

```
.
├── README.md                   # This file
├── SECURITY.md
├── LICENSE
└── mw-dtc/
    ├── build_dtc.sh            # Automated build script (supports Windows/Linux)
    ├── mingw-w64-cross.txt     # Meson cross-compilation configuration
    ├── PKGBUILD                # MSYS2 package recipe (reference)
    ├── 0001-remove-setup-py-install.patch
    ├── output/                 # Build output directory (created by build script)
    │   ├── build-win/          # Windows binaries
    │   │   └── dtc.exe
    │   └── build-lin/          # Linux binaries
    │       └── dtc
    └── dtc-1.7.2/              # DTC source code
        ├── meson.build         # Build configuration
        ├── dtc.c, checks.c ... # Compiler source files
        ├── libfdt/             # libfdt headers (used by dtc)
        ├── GPL                 # License (dtc)
        ├── BSD-2-Clause        # License (libfdt)
        └── README.license      # License explanation
```

Copyright 2026 The MathWorks, Inc.
