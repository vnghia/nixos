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
      };
    };
  };

  config = lib.mkIf cfg.enable {
    security.tpm2 = {
      enable = true;
    };

    environment.systemPackages = with pkgs; [
      tpm2-tools
      tpm2-tss
    ];
  };
}
