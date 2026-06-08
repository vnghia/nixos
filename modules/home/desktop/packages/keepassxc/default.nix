{
  lib,
  config,
  customLib,
  ...
}:
let
  cfg = config._.desktop.packages.keepassxc;
  homeCfg = config.home;
  passwordDirectory = "${homeCfg.homeDirectory}/Documents/Passwords";
  passwordFile = "${passwordDirectory}/passwords.kdbx";
in
{
  options = with lib; {
    _ = {
      desktop.packages.keepassxc = {
        enable = mkEnableOption "KeepassXC";
        autostart = mkEnableOption "Autostart";
      }
      // customLib.home.desktop.packages.favorite.mkOption;
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
              General = {
                LastActiveDatabase = passwordFile;
                MinimizeAfterUnlock = true;
              };
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
      (customLib.home.desktop.packages.favorite.mkConfig "org.keepassxc.KeePassXC.desktop" cfg)
    ]
  );
}
