# Nix-darwin Configurations

The nix configuration is based on [AlexNabokikh/nix-config](https://github.com/AlexNabokikh/nix-config) and follows the [dendritic pattern](https://github.com/mightyiam/dendritic).

## Layout

```text
.
├── flake.nix         # Inputs; imports everything in nix/
└── nix/
    ├── base.nix      # Composes features into darwin.base, homeManager.base
    ├── profile/      # Identity and shared appearance settings
    ├── hosts/        # Hosts definitions
    ├── darwin/       # macOS-only system features
    ├── desktop/      # Shared compositor config (gtk, qt, cursor, idle, …)
    │   └── wm/       # Window manager choices (hyprland, niri, aerospace)
    ├── programs/     # Home-Manager program modules (alacritty, git, tmux, zsh, …)
    └── *.nix         # Cross-class features (fonts, users, …)
```

## Conventions

- Files under `nix/darwin/`, or `nix/programs/` declare modules of a single class (`darwin.*`, `homeManager.*`).
- Files at the root of `nix/`, and files under `nix/desktop/`, declare composites for more than one class. For example, `fonts.nix` declares both `darwin.fonts` and `homeManager.fonts`.
- `nix/base.nix` collects every feature composite into `darwin.base`, and `homeManager.base`. New features are registered there.
- Hosts are defined in `nix/hosts/`.
- Files and directories prefixed with `_` (for example `_hardware.nix`) are skipped by `import-tree` and imported explicitly where needed.

## Personal settings

[`nix/profile/preferences.nix`](nix/profile/preferences.nix) declares the personal settings shared across all hosts: name, email, fonts, locale, timezone, etc..

Replace the asset files with your own:

- `nix/profile/avatar`
- `nix/profile/wallpaper.jpg`

The remaining files in `nix/profile/` wire the `primaryUser` option into Darwin and Home Manager.


## Adding a host

New host files are picked up by `import-tree` from `nix/hosts/` without further registration (but don't forget `git add .` new files).

### 5. Build

```sh
make nixos-rebuild     # NixOS
make darwin-rebuild    # macOS
make flake-check       # validate the flake
make bootstrap-mac     # install Nix and nix-darwin on a fresh Mac
```

`make help` lists all targets. The `Makefile` defaults to `.#$(hostname)`, so flake outputs named after the machine's hostname are selected automatically.

## Adding modules

- A new Home-Manager program lives in `nix/programs/<name>.nix` and declares `flake.modules.homeManager.<name>`. Register `homeManager.<name>` in `homeManager.base.imports` inside `nix/base.nix`.
- A new Darwin-only system feature lives in `nix/darwin/<name>.nix`, declares `flake.modules.darwin.<name>`, and is registered in the matching `*.base.imports` list.
- A feature spanning more than one class lives at the root of `nix/`. `fonts.nix` declares both `darwin.fonts` and `homeManager.fonts`, each registered in its own `base.imports`.
