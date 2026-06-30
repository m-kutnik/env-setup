{
  flake.modules.darwin.keyboard = {
    system.keyboard = {
      enableKeyMapping = true;
      swapLeftCommandAndLeftAlt = true;
      swapRightCommandAndRightOption = true;
    };

    system.defaults.CustomUserPreferences = {
      "com.apple.symbolichotkeys" = {
        AppleSymbolicHotKeys = {
          # Show Spotlight search → disabled
          "64".enabled = false;

          # Show Spotlight file-search window → disabled
          "65".enabled = false;
        };
      };
    };
  };
}
