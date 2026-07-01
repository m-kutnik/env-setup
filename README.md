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

This will basically run ~all~ most of the setup scripts in the `scripts/bash` directory, so if you are not me, i recommend checking the source code first. You can find more info about each script in the [Bash Scripts](#bash-scripts) section.

Most of the env setup is done, it's time to sync the dotfiles - run:

```bash
mise dotfiles status # shows the status of the dotfiles
mise dotfiles apply  # applies the dotfiles
```

Once this is done, you can install the rest of the dependencies by running:

```bash
mise run brew-extras
```

We install the extras after the dotfiles are synced to avoid conflicts and hopefully make the process smoother.

## Scripts

### Bash Scripts

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
