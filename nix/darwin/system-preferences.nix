{
  flake.modules.darwin.systemPreferences =
    { ... }:
    {
      system.defaults = {
        controlcenter = {
          BatteryShowPercentage = false;
          NowPlaying = false;
        };

        NSGlobalDomain = {
          "com.apple.keyboard.fnState" = true;
          "com.apple.sound.beep.feedback" = 1;
          AppleInterfaceStyle = "Dark";
          NSAutomaticCapitalizationEnabled = false;
          NSAutomaticDashSubstitutionEnabled = false;
          NSAutomaticPeriodSubstitutionEnabled = false;
          NSAutomaticQuoteSubstitutionEnabled = false;
          NSDocumentSaveNewDocumentsToCloud = false;
        };

        LaunchServices.LSQuarantine = false;

        trackpad = {
          TrackpadRotate = true;
        };

        finder = {
          AppleShowAllExtensions = true;
          AppleShowAllFiles = true;
          CreateDesktop = false;
          FXDefaultSearchScope = "SCcf";
          FXEnableExtensionChangeWarning = false;
          NewWindowTarget = "Home";
          ShowExternalHardDrivesOnDesktop = false;
          ShowHardDrivesOnDesktop = false;
          ShowMountedServersOnDesktop = false;
          ShowRemovableMediaOnDesktop = false;
          ShowStatusBar = false;
          _FXShowPosixPathInTitle = true;
          _FXSortFoldersFirst = true;
        };

        dock = {
          autohide = true;
          show-process-indicators = true;
          show-recents = false;
          static-only = true;
          launchanim = false;
          tilesize = 40;
          largesize = null;
          mru-spaces = false;
          # disable hot corners
          wvous-br-corner = 1;
          wvous-tl-corner = 1;
          wvous-tr-corner = 1;
          wvous-bl-corner = 1;
        };

        loginwindow = {
          GuestEnabled = false;
          DisableConsoleAccess = true;
        };

        hitoolbox = {
          AppleFnUsageType = "Do Nothing";
        };

        screencapture = {
          include-date = false;
          save-selections = false;
          target = "clipboard";
        };

        CustomUserPreferences = {
          NSGlobalDomain."com.apple.mouse.linear" = true;
        };
      };

      system.startup.chime = false;
    };
}
