{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config._.cli.packages.nixd;
in
{
  options = with lib; {
    _ = {
      cli.packages.nixd = {
        enable = mkEnableOption "Nixd";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.nixd ];

    _ = {
      cli.packages.nixfmt.enable = true;

      desktop.packages.vscodium.base = {
        extensions = [ pkgs.nix-vscode-extensions.open-vsx.jnoortheen.nix-ide ];
        userSettings = {
          "nix.enableLanguageServer" = true;
          "nix.serverPath" = "nixd";
          "nix.serverSettings" = {
            nixd = {
              formatting = {
                command = [ "nixfmt" ];
              };
            };
          };
        };
      };
    };
  };
}
