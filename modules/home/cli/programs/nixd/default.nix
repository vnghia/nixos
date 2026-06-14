{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config._.cli.programs.nixd;
in
{
  options = with lib; {
    _ = {
      cli.programs.nixd = {
        enable = mkEnableOption "Nixd";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.nixd ];

    _ = {
      cli.programs.nixfmt.enable = true;

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
