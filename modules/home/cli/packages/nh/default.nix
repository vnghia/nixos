{
  lib,
  config,
  ...
}:
let
  cfg = config._.cli.packages.nh;
in
{
  options = with lib; {
    _ = {
      cli.packages.nh = {
        enable = mkEnableOption "Nh";
        clean = {
          enable = mkEnableOption "Clean";
          keep = {
            keep = mkOption {
              type = types.nullOr types.int;
              default = 3;
            };
            since = mkOption {
              type = types.nullOr types.str;
              default = "3d";
            };
          };
        };
        flake = mkOption {
          type = types.nullOr types.path;
          default = null;
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.nh = {
      enable = true;
      clean = {
        enable = cfg.clean.enable;
        extraArgs =
          (lib.optionalString (cfg.clean.keep.keep != null) "--keep ${toString cfg.clean.keep.keep}")
          + (lib.optionalString (cfg.clean.keep.since != null) " --keep-since ${cfg.clean.keep.since}");
      };
      flake = cfg.flake;
    };
  };
}
