{
  flake.modules.darwin.users =
    { config, ... }:
    {
      users.users.${config.primaryUser} = {
        name = config.primaryUser;
        home = "/Users/${config.primaryUser}";
      };

      system.primaryUser = config.primaryUser;
    };
}
