{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config._.system.security.tpm2;
in
{
  options = with lib; {
    _ = {
      system.security.tpm2 = {
        enable = mkEnableOption "TPM2";
        abrmd = mkEnableOption "user-space resource manager";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    security.tpm2 = {
      enable = true;
      abrmd.enable = cfg.abrmd;
    };

    environment.systemPackages = with pkgs; [
      tpm2-tools
      tpm2-tss
      keyutils
    ];
  };
}
