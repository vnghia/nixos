{
  lib,
  config,
  customLib,
  ...
}:
let
  cfg = config._.desktop.programs.keepassxc;
  homeCfg = config.home;
  passwordDirectory = "${homeCfg.homeDirectory}/Documents/Passwords";
in
{
  options = with lib; {
    _ = {
      desktop.programs.keepassxc = {
        enable = mkEnableOption "KeepassXC";
        autostart = mkEnableOption "Autostart";
        defaultDatabase = mkOption {
          type = types.nullOr types.str;
          default = null;
        };
      }
      // customLib.home.desktop.programs.favorite.mkOption;
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        programs.keepassxc = {
          enable = true;
          autostart = cfg.autostart;
          settings = lib.mkMerge [
            {
              General = lib.mkMerge [
                {
                  MinimizeAfterUnlock = true;
                }
                (lib.mkIf (cfg.defaultDatabase != null) {
                  LastActiveDatabase = "${passwordDirectory}/${cfg.defaultDatabase}";
                })
              ];
              Browser = {
                Enabled = true;
                UpdateBinaryPath = false;
              };
              GUI = {
                MinimizeOnClose = true;
                MinimizeToTray = false;
                ShowTrayIcon = true;
                TrayIconAppearance = "monochrome-light";
              };
              PasswordGenerator = {
                AdvancedMode = true;
                Braces = true;
                Dashes = true;
                EASCII = true;
                Length = 64;
                Logograms = true;
                Math = true;
                Punctuation = true;
                Quotes = true;
              };
              Security = {
                EnableCopyOnDoubleClick = true;
                LockDatabaseIdleSeconds = 3600;
                LockDatabaseScreenLock = true;
              };
            }
          ];
        };

        xdg.autostart = lib.mkIf cfg.autostart {
          enable = true;
        };

        _ = {
          system.nixos.impermanence.directories = [
            passwordDirectory
          ];
        };
      }
      (customLib.home.desktop.programs.favorite.mkConfig "org.keepassxc.KeePassXC.desktop" cfg)
    ]
  );
}
