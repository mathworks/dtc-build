# Device Tree Compiler (dtc) for Windows&reg;

Build a Windows-compatible Device Tree Compiler (`dtc.exe`) to compile, decompile, and validate device tree source files (`.dts`) and device tree blobs (`.dtb`) directly on Windows.

## What is dtc?

The Device Tree Compiler (`dtc`) is the standard tool for working with device trees in embedded Linux systems. It enables:

- **Compiling** device tree source (`.dts`) to binary blobs (`.dtb`)
- **Decompiling** binary blobs (`.dtb`) back to readable source (`.dts`)
- **Building overlays** (`.dtbo`) for runtime device tree modifications
- **Validating** device tree syntax and structure

This repository provides the source code and automated build scripts to cross-compile `dtc.exe` for Windows from a Linux&reg; host.

## Getting Started

### Required Products

A Linux&reg; host with `apt` package manager. Install all required packages by running the below command in your Linux terminal.

```
sudo apt-get update
sudo apt-get install gcc-mingw-w64-x86-64 meson ninja-build pkg-config flex bison
```

| Package | Purpose |
|---------|---------|
| `gcc-mingw-w64-x86-64` | Cross-compiler that produces Windows x86_64 executables |
| `meson` | Build system used by dtc |
| `ninja-build` | Backend build tool used by Meson |
| `pkg-config` | Dependency resolution during build configuration |
| `flex` | Lexer generator (for DTS parser) |
| `bison` | Parser generator (for DTS parser) |


## Build the dtc.exe Using Build Script

This section explains how to build the Windows-compatible `dtc.exe` using the provided build script.

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
	./build_dtc.sh
	```

4. The built `dtc.exe` will be available at:

	```
	mw-dtc/dtc-1.7.2/build-win/dtc.exe
	```

## Build the dtc.exe Manually

If you wish to build the `dtc.exe` manually, follow the steps mentioned in this section.

1. Clone the MathWorks device tree compiler repository.

	```
	git clone https://insidelabs-git.mathworks.com/EmbeddedLinux/device-tree-compiler.git
	```

2. Navigate to the dtc source directory.

	```
	cd device-tree-compiler/mw-dtc/dtc-1.7.2
	```

3. Configure the build with Meson using the cross-compilation file.

	```
	meson setup --cross-file ../mingw-w64-cross.txt \
	    -Dtests=false \
	    -Dtools=true \
	    -Dyaml=disabled \
	    -Dpython=disabled \
	    build-win
	```

4. Compile.

	```
	meson compile -C build-win
	```

5. The built `dtc.exe` will be available at:

	```
	mw-dtc/dtc-1.7.2/build-win/dtc.exe
	```

## Usage

After building, you can use `dtc.exe` on Windows for device tree compilation and decompilation.

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

## Repository Structure

```
.
├── README.md                   # This file
├── SECURITY.md
├── LICENSE
└── mw-dtc/
    ├── build_dtc.sh            # Automated build script
    ├── mingw-w64-cross.txt     # Meson cross-compilation configuration
    ├── PKGBUILD                # MSYS2 package recipe (reference)
    ├── 0001-remove-setup-py-install.patch
    └── dtc-1.7.2/              # DTC source code
        ├── meson.build         # Build configuration
        ├── dtc.c, checks.c ... # Compiler source files
        ├── libfdt/             # libfdt headers (used by dtc)
        ├── GPL                 # License (dtc)
        ├── BSD-2-Clause        # License (libfdt)
        └── README.license      # License explanation
```

Copyright 2026 The MathWorks, Inc.
