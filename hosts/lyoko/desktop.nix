{
  config = {
    _ = {
      desktop = {
        fonts = {
          jetbrainsMono = {
            enable = true;
          };
        };
        managers = {
          gnome = {
            enable = true;
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
