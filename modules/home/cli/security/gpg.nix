{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config._.cli.security.gpg;
  xdgCfg = config.xdg;
  homeCfg = config.home;
  homePrefix = "${homeCfg.homeDirectory}/";
in
{
  options = with lib; {
    _ = {
      cli.security.gpg = {
        enable = mkEnableOption "GnuPG";
      };
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        services.gpg-agent = {
          enable = true;
          pinentry = {
            package = pkgs.pinentry-gnome3;
          };
        };

        programs.gpg = {
          enable = true;
          package = pkgs.sequoia-chameleon-gnupg;
        };

        home.packages = with pkgs; [
          sequoia-sq
        ];

        _ = {
          nixos.impermanence = {
            directories = {
              "${homePrefix}.gnupg" = {
                mode = "0700";
              };
              "${xdgCfg.dataHome}/pgp.cert.d" = {
                mode = "0700";
              };
              "${xdgCfg.dataHome}/sequoia" = {
                mode = "0700";
              };
            };
          };
        };
      }
    ]
  );
}
