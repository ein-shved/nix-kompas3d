# ASCON Kompas3D Home integration script for NixOS

# Installation

## NixOS flake

Say you connected this flake with name `kompas3d`. Append `kompas3d.modules`
list to your system modules and add `pkgs.kompas3d` package to
`environment.systemPackages`.

## Generic nix

You may want to run `nix build` inside this cloned repo.

# Usage

## Product access

You may want to buy or download a trial for
[Ascon Kompas3D Home](https://kompas.ru/kompas-3d-home/about/) product.

## First run

First time - run `kompas3d` with `-i` option, passing downloaded iso image to
it.

## Other options

Usage: `kompas3d [-i KOMPAS_3D_ISO] [-w WINEPREFIX] [-cnh]`

Calling without any flags will run previously installed instance.

Calling with -i will run an installation first

- `-i`  `KOMPAS_3D_ISO`   run installation with specified iso image
- `-w`  `WINEPREFIX`      change default wineprefix
- `-c`                    clear prefix before installation
- `-n`                    do not remove unpacked image files after installation
- `-h`                    show this and exit
