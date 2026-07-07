{
  lib,
  config,
  pkgs,
  customLib,
  ...
}:
let
  cfg = config._.desktop.programs.communication.thunderbird;
  emailCfg = config._.user.email;
  homeCfg = config.home;
  desktop = "thunderbird.desktop";
in
{
  options = with lib; {
    _ = {
      desktop.programs.communication.thunderbird = {
        enable = mkEnableOption "Thunderbird";
        birdtray = mkEnableOption "Birdtray";
        default = mkEnableOption "Default";
        profiles = mkOption {
          type = types.attrsOf types.anything;
        };
      }
      // customLib.home.desktop.programs.favorite.mkOption;
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        programs.thunderbird = {
          enable = true;
          profiles = lib.mkMerge [
            cfg.profiles
            (lib.mapAttrs (profile: accounts: {
              accountsOrder = lib.forEach accounts (account: account.name);
            }) emailCfg.accounts.accounts)
          ];
          settings = {
            # Composition
            "mail.compose.default_to_paragraph" = false;
            "mail.compose.warned_about_customize_from" = true;

            # Privacy
            "datareporting.healthreport.uploadEnabled" = false;

            # Sort
            "mailnews.default_sort_order" = 1;
          };
        };

        _ = {
          nixos.impermanence.directories = [
            "${homeCfg.homeDirectory}/.thunderbird"
          ];

          user.email.accounts.config = lib.concatMapAttrs (
            profile: accounts:
            lib.listToAttrs (
              lib.forEach accounts (
                account:
                lib.nameValuePair account.name {
                  thunderbird = {
                    enable = true;
                    profiles = [ profile ];
                    settings = id: {
                      "mail.identity.id_${id}.catchAll" = true;
                      "mail.identity.id_${id}.catchAllHint" = lib.concatStringsSep ", " (
                        lib.forEach account.config.catchAllDomains (domain: "*@${domain}")
                      );
                    };
                  };
                }
              )
            )
          ) emailCfg.accounts.accounts;
        };
      }
      (customLib.home.desktop.programs.favorite.mkConfig desktop cfg)
      (lib.mkIf cfg.default (
        let
          mimeApps = {
            "x-scheme-handler/mailto" = [ (lib.mkForce desktop) ];
            "x-scheme-handler/mid" = [ (lib.mkForce desktop) ];
            "x-scheme-handler/net.thunderbird" = [ (lib.mkForce desktop) ];
            "message/rfc822" = [ (lib.mkForce desktop) ];
          };
        in
        {
          xdg.mimeApps = {
            enable = true;
            defaultApplications = mimeApps;
            associations = {
              added = mimeApps;
            };
          };
        }
      ))
      (lib.mkIf cfg.birdtray {
        home.packages = [
          pkgs.birdtray
        ];
      })
    ]
  );
}
