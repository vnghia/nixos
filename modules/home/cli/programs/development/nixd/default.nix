{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config._.cli.programs.development.nixd;
in
{
  options = with lib; {
    _ = {
      cli.programs.development.nixd = {
        enable = mkEnableOption "Nixd";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.nixd ];

    _ = {
      cli.programs.development.nixfmt.enable = true;

      desktop.programs.vscodium.base = {
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
