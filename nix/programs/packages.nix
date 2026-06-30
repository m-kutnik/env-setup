{
  flake.modules.generic.packages =
    {
      lib,
      pkgs,
      ...
    }:
    {
      environment.systemPackages =
        with pkgs;
        [
          eza # modern replacement for ls https://github.com/eza-community/eza
          zoxide # modern replacement for cd https://github.com/ajeetdsouza/zoxide
          chafa # images in the terminal https://github.com/hpjansson/chafa
          treefmt # for formatting files https://github.com/numtide/treefmt
          wget
          mise # development multi-tool https://github.com/jdx/mise
          nil # nix language server https://github.com/oxalica/nil
          nixd # yet another nix language server https://github.com/nix-community/nixd
          nixfmt # nix formatter https://github.com/NixOS/nixfmt
          mcp-nixos # https://github.com/utensils/mcp-nixos
        ]
        ++ lib.optionals pkgs.stdenv.hostPlatform.isDarwin []
        ++ lib.optionals (!pkgs.stdenv.hostPlatform.isDarwin) [];
    };
}
