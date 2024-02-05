# Setup development environment

## I. Setup cross-compilation

In order to cross-compile, you need to:

1. [install sshpass (root access required)](#1-install-sshpass)
2. [setup environment variables](#2-setup-environment-variables)
3. [load the environment variables](#3-load-environment-variables-required-to-install-cross-compiler-toolchain-and-to-cross-compile)
4. [install cross-compiler toolchain](#4-install-cross-compiler-toolchain)
5. [cross-compile](#5-cross-compile)

### 1. Install sshpass

```bash
sudo apt install sshpass
```

### 2. Setup environment variables

In [env_vars_cross_compilation.sh](env_vars_cross_compilation.sh), adapt the following variables to your needs:

```bash
export CROSS_TOOLS_INSTALLATION_PATH=~/tools # Directory in which the cross-tools will be installed (ADAPT THIS PATH TO YOUR NEEDS)
export ROOTFS_DIR=rootfs_pizero # Contains the /user and /lib of the target (ADAPT THIS PATH TO YOUR NEEDS)
export TARGET_LOGIN=XXXXXX # Used to SSH (ADAPT THIS PATH TO YOUR NEEDS)
export TARGET_ADDRESS=X.X.X.X # Used to SSH (ADAPT THIS PATH TO YOUR NEEDS)
# Used in Makefile and by `go build`
export CROSS_TRIPLET_PREFIX=$CROSS_TOOLS_INSTALLATION_PATH/x-tools/armv6-rpi-linux-gnueabihf/bin/armv6-rpi-linux-gnueabihf- # Cross prefix tools path (gcc, ar, nm...)
export CROSS_GCC=${CROSS_TRIPLET_PREFIX}gcc # Cross compiler path
export CROSS_AR=${CROSS_TRIPLET_PREFIX}ar # Cross compiler path
export CROSS_SYSROOT=$CROSS_TOOLS_INSTALLATION_PATH/$ROOTFS_DIR/ # Cross sysroot path
```

### 3. Load environment variables (required to install cross-compiler toolchain and to <u>cross-compile</u>)

After setting up the environment variables, you need to load them in the current shell:

```bash
source /PATH/TO/env_vars_cross_compilation.sh
```

**Tip**: you can add this command to your `~/.bashrc` file to load the environment variables automatically at startup. Otherwise, you will need to run this command every time you open a new shell.

### 4. Install cross-compiler toolchain

To install the cross-compiler toolchain and synchronize the /usr and /lib target folders, run the following command:

```bash
./setup_cross_tools.sh
```

You will be asked to enter the password of the target.

### 5. Cross-compile

This step supposes that :

- You have already installed the cross-compiler toolchain and synchronized the /usr and /lib target folders
- Your Makefile uses the `$CROSS_COMPILE` variable to cross-compile
- Your Makefile uses `$CROSS_GCC` if `$CROSS_COMPILE` is set to true
- Your Makefile uses `$CROSS_SYSROOT` if `$CROSS_COMPILE` is set to true
- Your Makefile uses `CCFLAGS += --sysroot=$CROSS_SYSROOT` if `$CROSS_COMPILE` is set to true

```bash
cd /PAH/TO/YOUR/Makefile
make CROSS_COMPILE=true ... (specify your targets if needed)
```

### WARNING ABOUT CROSS-COMPILING, FLAGS AND LIBRARIES

- in order to debug, add debug symbols to your executable and libraries (add `-g` to your `CCFLAGS`)
- don't forget to add the `-L PATH/TO/SOLIB_FOLDER -llibname` flag to your `LDFLAGS` to find the `.so` files **at link time**
- add the `-Wl,-rpath=PATH/TO/SOLIB_FOLDER/AT/EXECUTION` flag to your `LDFLAGS` when linking your executable with dynamic libraries (.so) so that the executable can find the `.so` files **at runtime** (*not needed for static libraries (.a)*)

## II. About remote debugging

### Setup remote debugging in CLI

- Install gdb-multiarch on your **host machine**: `sudo apt install gdb-multiarch`
- Build your executable on your **host machine** (with debug symbols): for instance, to build YOUR_PROJECT lowlevel static library, run the following command:

    ```bash
    make CROSS_COMPILE=true liba
    ```

- Connect to the **remote target** and start gdbserver:

    ```bash
    sudo gdbserver --multi :PORT `executable_file` # Run as root if bcm2835 library is used...
    ```

- On your **host machine**, start gdb-multiarch and connect to the target:

    ```bash
    /bin/gdb-multiarch `executable_file`
    (gdb) target remote IP:PORT
    ```

- You should now be able to debug your executable on your **host machine**, but some settings might help (see next sections!)

### Some settings for remote debugging

- To avoid downloading target libraries every time you debug, you can use the `set sysroot` command where `PATH/TO/CROSS_SYSROOT` should be the same folder as `$CROSS_SYSROOT`:

```bash
(gdb) set sysroot /PATH/TO/CROSS_SYSROOT
```

- To debug .so files that are not in standard search path, you can use the `set solib-search-path` command where `PATH/TO/SOLIB_FOLDER` is the path to the folder containing the .so files you want to debug:

```bash
set solib-search-path PATH/TO/SOLIB_FOLDER
```

#### Setup GDB init file (recap of previous tips)

- Add these commands to your `~/.config/gdb/gdbinit` file to avoid typing them every time you start gdb-multiarch:

```bash
set sysroot /PATH/TO/CROSS_SYSROOT
set solib-search-path PATH/TO/SOLIB_FOLDER
set non-stop on
```

- [About non-stop mode and async mode](https://sourceware.org/gdb/current/onlinedocs/gdb.html/Asynchronous-and-non_002dstop-modes.html) (**async mode is automatically set** by Native Debug in VSCode but non-stop mode is not and it is very usefull with multi-threaded programs) 

#### Setup remote debugging with VSCode (it supposes that previous steps have been done and works)

- Install the [Native Debug](https://marketplace.visualstudio.com/items?itemName=webfreak.debug) extension
- Create a `launch.json` file in your `.vscode` folder
- Add the following configuration to your `launch.json` file:

```json
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Attach to remote gdbserver",
            "type": "gdb",
            "request": "attach",
            "target": "IP:PORT", // IP and PORT of the target
            "cwd": "${workspaceRoot}",
            "executable": "PATH/TO/EXECUTABLE_FILE", // Path to the executable after setting cwd
            "remote": true,
            "gdbpath": "/bin/gdb-multiarch", // Path to your gdb-multiarch
        }
    ]
}
```
