{
  lib,
  ...
}:
let
  systemdService = "sops-nix.service";
in
{
  sops = {
    mkRequiresOption = with lib; {
      requiresSops = mkEnableOption "Sops requirement";
    };

    mkSystemdServiceRequirements =
      cfg:
      lib.mkIf cfg.requiresSops {
        Unit = {
          Requires = [ systemdService ];
          After = [ systemdService ];
        };
      };
  };
}
