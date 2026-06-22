{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config._.system.virtualization.qemu;
  tpmCfg = config._.system.security.tpm2;
in
{
  options = with lib; {
    _ = {
      system.virtualization.qemu = {
        enable = mkEnableOption "QEMU";
        onBoot = mkOption {
          type = types.enum [
            "start"
            "ignore"
          ];
          default = "start";
        };
        onShutdown = mkOption {
          type = types.enum [
            "shutdown"
            "suspend"
          ];
          default = "suspend";
        };
      };
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        virtualisation.libvirtd = {
          enable = true;
          onBoot = cfg.onBoot;
          onShutdown = cfg.onShutdown;
        };

        environment.systemPackages = with pkgs; [
          dnsmasq
        ];

        networking.firewall.trustedInterfaces = [
          "virbr0"
        ];

        _ = {
          system.nixos.impermanence = {
            directories = [
              "/var/lib/libvirt"
            ];
            # TODO: Remove this after https://github.com/NixOS/nixpkgs/issues/501336
            files = [
              "/var/lib/systemd/credential.secret"
            ];
          };
        };
      }
      (lib.mkIf tpmCfg.enable {
        virtualisation.libvirtd.qemu = {
          swtpm.enable = true;
        };

        _ = {
          system.nixos.impermanence.directories = [
            {
              directory = "/var/lib/swtpm-localca";
              user = "tss";
            }
          ];
        };
      })
    ]
  );
}
