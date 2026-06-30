{
  inputs,
  ...
}:
{
  flake.modules.darwin.homebrew = {
    imports = [
      inputs.nix-homebrew.darwinModules.nix-homebrew
    ];
    users.knownUsers = [ "brew" ];
    users.knownGroups = [ "brew" ];

    users.groups.brew = {
      name = "brew";
      gid = 2137;
    };

    users.users.brew = {
      name = "brew";
      description = "Homebrew";
      uid = 2137;
      gid = 2137;
      shell = "/bin/bash";
      createHome = true;
      home = "/Users/brew";
      isHidden = true;
    };

    nix-homebrew = {
      enable = true;
      enableRosetta = true;
      user = "brew";

      # Note: The trust entries are _not_ removed if you remove them from those lists!
      # Use the `brew untrust` command to remove a trust entry.
      trust = {
        formulae = [
          "michaelroosz/ssh/libsk-libfido2"
          "theseal/ssh-askpass/ssh-askpass"
        ];
      };
    };

    homebrew = {
      enable = true;

      casks = [
        "android-platform-tools"
        "jordanbaird-ice"
      ];
    };
  };
}
