{ config, ... }:
let
  inherit (config.flake.modules)
    generic
    darwin
    homeManager
    ;
  commonImports = [
    generic.profile
    generic.primaryUser
    generic.primaryUserHome
    generic.nixSettings
    generic.packages
  ];
in
{
  flake.modules.darwin.base = {
    imports = commonImports ++ [
      darwin.fonts
      darwin.keyboard
      darwin.sudo
      darwin.systemPreferences
      darwin.users
      darwin.homebrew
    ];
    home-manager.sharedModules = [ homeManager.base ];
  };

  flake.modules.homeManager.base = {
    imports = [
      generic.profile
      homeManager.mcpNix
    ];
  };
}
