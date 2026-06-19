{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config._.cli.programs.development.just;
in
{
  options = with lib; {
    _ = {
      cli.programs.development.just = {
        enable = mkEnableOption "Just";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.just
      pkgs.just-lsp
    ];

    _ = {
      desktop.programs.development.vscodium.base = {
        extensions = [ pkgs.nix-vscode-extensions.open-vsx.nefrob.vscode-just-syntax ];
        userSettings = {
          "[just]" = {
            "editor.defaultFormatter" = "nefrob.vscode-just-syntax";
          };
        };
      };
    };
  };
}
