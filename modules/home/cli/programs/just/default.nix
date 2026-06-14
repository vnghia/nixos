{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config._.cli.programs.just;
in
{
  options = with lib; {
    _ = {
      cli.programs.just = {
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
      desktop.programs.vscodium.base = {
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
