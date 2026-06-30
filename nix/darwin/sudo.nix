{
  flake.modules.darwin.sudo =
    { ... }:
    {
      # security.pam.services.sudo_local.touchIdAuth = true;
    };
}
