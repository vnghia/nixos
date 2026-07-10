{
  pkgs,
  secrets,
  ...
}:
{
  config = {
    _ = {
      desktop = {
        frameworks = {
          gtk = {
            stylix = true;
          };
          qt = {
            stylix = true;
          };
        };
        fonts = [
          pkgs.ubuntu-sans
          pkgs.nerd-fonts.jetbrains-mono
          pkgs.noto-fonts-color-emoji
        ];
        managers = {
          gnome = {
            enable = true;
            stylix = false;
          };
        };
        network = {
          captive = {
            interface = secrets.desktop.network.captive.interface;
          };
        };
        programs = {
          game = {
            steam = {
              enable = true;
              gamemode = true;
              extest = true;
            };
          };
        };
      };
    };
  };
}
