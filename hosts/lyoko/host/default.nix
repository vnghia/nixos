{
  inputs,
  ...
}:
{
  imports = [

    ../configuration.nix

    ./hardware-configuration.nix
    inputs.nixos-hardware.nixosModules.framework-13-7040-amd
  ];

  config = {
    _ = {
      desktop = {
        managers = {
          gnome = {
            extensions = {
              dash-to-dock = {
                config = {
                  preferred-monitor = -2;
                  preferred-monitor-by-connector = "eDP-1";
                };
              };
            };
          };
        };
      };

      system = {
        hardware = {
          network = {
            hardwares = [
              "mt7921"
            ];
          };
        };
      };
    };

    hardware.framework.laptop13.audioEnhancement = {
      enable = true;
    };
  };
}
