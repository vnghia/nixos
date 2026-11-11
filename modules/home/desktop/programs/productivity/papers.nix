{
  lib,
  config,
  customLib,
  pkgs,
  ...
}:
let
  cfg = config._.desktop.programs.productivity.papers;
  desktop = "org.gnome.Papers.desktop";
in
{
  options = with lib; {
    _ = {
      desktop.programs.productivity.papers = {
        enable = mkEnableOption "Papers";
        default = mkEnableOption "Default";
      }
      // customLib.home.desktop.programs.favorite.mkOption;
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        home.packages = with pkgs; [
          papers
        ];
      }
      (customLib.home.desktop.programs.favorite.mkConfig desktop cfg)
      (lib.mkIf cfg.default (
        let
          mimeApps =
            lib.genAttrs
              [
                "application/pdf"
                "application/x-bzpdf"
                "application/x-ext-pdf"
                "application/x-gzpdf"
                "application/x-xzpdf"
              ]
              (scheme: [
                (lib.mkForce desktop)
              ]);
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
    ]
  );
}
