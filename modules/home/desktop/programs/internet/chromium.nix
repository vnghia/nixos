{
  lib,
  config,
  pkgs,
  customLib,
  jail,
  ...
}:
let
  cfg = config._.desktop.programs.internet.chromium;
  keepassxcCfg = config._.desktop.programs.productivity.keepassxc;
  xdgCfg = config.xdg;

  jailName = "chromium";
in
{
  options = with lib; {
    _ = {
      desktop.programs.internet.chromium = {
        enable = mkEnableOption "Chromium";
      }
      // customLib.home.desktop.programs.favorite.mkOption;
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        programs.chromium = {
          enable = true;
          package = jail jailName pkgs.ungoogled-chromium (
            with jail.combinators;
            [
              camera
              gpu
              gui
              network
              notifications
              (persist-home jailName)
              time-zone

              # https://github.com/flathub/org.chromium.Chromium/blob/master/org.chromium.Chromium.yaml
              (dbus {
                talk = [
                  "org.freedesktop.FileManager1"
                  "org.freedesktop.secrets"
                  "org.kde.kwalletd5"
                  "org.kde.kwalletd6"
                  "org.gnome.SessionManager"
                ];
                own = [
                  "org.mpris.MediaPlayer2.chromium.*"
                ];
              })
            ]
          );
          nativeMessagingHosts = (if keepassxcCfg.enable then [ pkgs.keepassxc ] else [ ]);
        };

        _ = {
          nixos.impermanence.directories = {
            "${(customLib.home.nixos.jail.mkHomePath xdgCfg jailName)}" = { };
          };
        };
      }
      (customLib.home.desktop.programs.favorite.mkConfig "chromium-browser.desktop" cfg)
    ]
  );
}
