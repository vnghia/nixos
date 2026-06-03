{
  imports = [
    ../configuration.nix

    ./hardware-configuration.nix
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
    };
  };
}
