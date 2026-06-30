{ config, ... }:
let
  inherit (config.flake.modules) darwin;
in
{
  configurations.darwin."TARDIS".module = {
    imports = [
      darwin.base
    ];

    networking.hostName = "TARDIS";

    primaryUser = "gimp";
    system.stateVersion = 6;
  };
}
