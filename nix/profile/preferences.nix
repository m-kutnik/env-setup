{
  flake.modules.generic.profile =
    {
      lib,
      pkgs,
      ...
    }:
    {
      options.profile = lib.mkOption {
        readOnly = true;
        type = lib.types.submodule {
          options = {
            email = lib.mkOption { type = lib.types.str; };
            fullName = lib.mkOption { type = lib.types.str; };
            gitKey = lib.mkOption { type = lib.types.str; };
            avatar = lib.mkOption { type = lib.types.path; };
            wallpaper = lib.mkOption { type = lib.types.path; };

            appearance = lib.mkOption {
              type = lib.types.submodule {
                options = {
                  fonts = lib.mkOption {
                    type = lib.types.submodule {
                      options = {
                        ui = lib.mkOption {
                          type = lib.types.submodule {
                            options = {
                              family = lib.mkOption { type = lib.types.str; };
                              size = lib.mkOption { type = lib.types.int; };
                              package = lib.mkOption { type = lib.types.package; };
                            };
                          };
                        };

                        monospace = lib.mkOption {
                          type = lib.types.submodule {
                            options = {
                              family = lib.mkOption { type = lib.types.str; };
                              package = lib.mkOption { type = lib.types.package; };
                              size = lib.mkOption { type = lib.types.int; };
                            };
                          };
                        };

                        terminalSize = lib.mkOption {
                          type = lib.types.submodule {
                            options = {
                              linux = lib.mkOption { type = lib.types.int; };
                              darwin = lib.mkOption { type = lib.types.int; };
                            };
                          };
                        };
                      };
                    };
                  };
                };
              };
            };

            locale = lib.mkOption {
              type = lib.types.submodule {
                options = {
                  timezone = lib.mkOption { type = lib.types.str; };
                  default = lib.mkOption { type = lib.types.str; };
                  extra = lib.mkOption { type = lib.types.attrsOf lib.types.str; };
                };
              };
            };
          };
        };
      };

      config.profile = {
        email = "gimp2312@gmail.com";
        fullName = "Mike Kutnik";

        appearance = {
          fonts = {
            ui = {
              family = "Inter";
              size = 11;
              package = pkgs.inter;
            };

            monospace = {
              family = "JetBrains Mono Nerd Font Mono";
              package = pkgs.nerd-fonts.jetbrains-mono;
              size = 11;
            };

            terminalSize = {
              linux = 12;
              darwin = 15;
            };
          };
        };

        locale = {
          timezone = "Europe/Warsaw";
          default = "en_US.UTF-8";
          extra = {
            LC_ADDRESS = "en_IE.UTF-8";
            LC_IDENTIFICATION = "en_IE.UTF-8";
            LC_MEASUREMENT = "en_IE.UTF-8";
            LC_MONETARY = "en_IE.UTF-8";
            LC_NAME = "en_IE.UTF-8";
            LC_NUMERIC = "en_IE.UTF-8";
            LC_PAPER = "en_IE.UTF-8";
            LC_TELEPHONE = "en_IE.UTF-8";
            LC_TIME = "en_IE.UTF-8";
          };
        };
      };
    };
}
