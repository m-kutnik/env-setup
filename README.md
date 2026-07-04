# dotfiles

This repo contains my env config scripts and dotfiles - most of the config was made by my lovely clanker Pi so it may be messy, broken, or incomplete - but i don't care

## Installation

First, clone the repository:

```bash
git clone https://github.com/m-kutnik/env-setup.git && cd env-setup
```

and, if you are brave (or stupid) enough to run the full setup, run:

```bash
./scripts/bash/install.sh --no-bitwarden
```

This will basically run ~all~ most of the setup scripts in the `scripts/bash` directory, so if you are not me, i recommend checking the source code first. You can find more info about each script in the [Bash Scripts](#bash-scripts) section.

The basic setup is done, now just run:

```bash
mise run sync
```

To install pi extensions deps, run:

```bash
mise run pi-install-extension-deps
```

## Mise

Most of the stuff is directly configured by mise or by it calling the other scripts - check the `mise.toml` file for more info.

## Scripts

### Bash Scripts

Path: `./scripts/bash`

| Script                              | Description                                        |
| ----------------------------------- | -------------------------------------------------- |
| `install.sh`                        | Full setup, calls other scripts                    |
| `xcode-install.sh`                  | Installs Xcode                                     |
| `homebrew-setup.sh`                 | Sets up multi-user homebrew                        |
| `homebrew-install-base.sh`          | Installs baseline homebrew packages                |
| `homebrew-install-extras.sh`        | Installs homebrew extras                           |
| `add-current-user-to-brew-group.sh` | Adds current user to brew group                    |
| `repo-deps.sh`                      | Installs repository dependencies                   |
| `uninstall.sh`                      | Uninstalls homebrew, removes brew user/group, etc. |

#### `install.sh` flags

| Flag             | Description                                       |
| ---------------- | ------------------------------------------------- |
| `-f` / `--force` | Force overwrite existing defaults                 |
| `--no-bitwarden` | Skip Bitwarden vault unlock (e.g. license import) |

### Bun Scripts

Path: `./scripts/bun`

| Script           | Description                                                                  |
| ---------------- | ---------------------------------------------------------------------------- |
| `sync-ignore.ts` | Adds things `.gitignore` and `.gitmodules` to formatters/IDE's ignore config |
