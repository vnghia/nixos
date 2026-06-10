{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config._.cli.packages.just;
in
{
  options = with lib; {
    _ = {
      cli.packages.just = {
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
      desktop.packages.vscodium.base = {
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
