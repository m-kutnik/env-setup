# dotfiles

This repo contains my env config scripts and dotfiles - most of the config was made by my lovely clanker Pi so it may be messy, broken, or incomplete - but i don't care

## Installation

First, clone the repository:

```bash
git clone https://github.com/m-kutnik/env-setup.git && cd env-setup
```

and, if you are brave (or stupid) enough to run the full setup, run:

```bash
./scripts/bash/install.sh
```

This will basically run all the setup scripts in the `scripts/bash` directory, so if you are not me, i recommend checking the source code first.

The scripts include:

| Script                              | Description                                        |
| ----------------------------------- | -------------------------------------------------- |
| `install.sh`                        | Full setup, calls other scripts                    |
| `xcode-install.sh`                  | Installs Xcode                                     |
| `homebrew-setup.sh`                 | Sets up multi-user homebrew                        |
| `homebrew-install-brewfile.sh`      | Installs brews/casks from Brewfile                 |
| `add-current-user-to-brew-group.sh` | Adds current user to brew group                    |
| `repo-deps.sh`                      | Installs repository dependencies                   |
| `uninstall.sh`                      | Uninstalls homebrew, removes brew user/group, etc. |

## Mise Setup
