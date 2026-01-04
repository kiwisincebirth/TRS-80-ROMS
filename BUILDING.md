
# Software Build Guide

The software is built using the Z88DK Z80 assembler. 

* [Z88DK Wiki - An Introduction to Z88DK](https://github.com/z88dk/z88dk/wiki)
* [Z88DK Wiki - Z80ASM Tool](https://github.com/z88dk/z88dk/wiki/Tool---z80asm)

## Installation

Installation of the software 

[Z88DK Wiki - Installation](https://github.com/z88dk/z88dk/wiki/installation)

### Linux

Is available as a SNAP package

[Z88DK Wiki - Snap Usage](https://github.com/z88dk/z88dk/wiki/Snap-usage)

Contrary to the above WIKI I used the following commands, for GITHUB action

```shell
sudo snap install z88dk --beta
sudo snap alias z88dk.z88dk-z80asm z88dk-z80asm
```

### Docker

A Docker Image `z88dk/z88dk` is available. This appears o be maintained by the authors.

[Z88DK Wiki - Docker Usage](https://github.com/z88dk/z88dk/wiki/Docker-Usage)

```shell
# execute this line in the directory you want z88dk executables to be run
docker run  -v .:/src/ -it z88dk/z88dk {command}

# If no matching image found (e.g. Apple Silicon) this command
docker run --platform linux/amd64 -v .:/src/ -it z88dk/z88dk {command}
```

### Mac

Native Installation does NOT exist as a BREW package. It requires direct downloading of binary files.
You may want to consider running it in a Docker container

### Windows

Requires direct downloading of binary files.
You may want to consider running it in a Docker container

## Building

### Manually

Building is done via a command such as 

```shell
z88dk-z80asm -b -l MDL1REV4.Z80
```

This will generate a `*.bin` the rom image, and a `*.lis` file which contains a
listing of the assembled code. See the docs for more information

[Z88DK Wiki - z80asm Command Line](https://github.com/z88dk/z88dk/wiki/Tool---z80asm---command-line)

### Make Targets

Can be built by `make`

To make a specific target below are some high level targets. For specific targets see
the [List of ROM Targets](./About_Release.txt)

| Target     | What is built            |
|------------|--------------------------|
| all        | All ROM's (*default*)    |
| model1all  | All Model 1 ROM's        |
| eaca80all  | All EACA ROM's           |
| model14all | All Enhanced Rev4 ROM's  | 
| model3all  | All Model 3 ROM's        | 
| clean      | (*deletes built files*)  |



