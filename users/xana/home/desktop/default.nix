{
  pkgs,
  ...
}:
{
  imports = [
    ../base
  ];

  config = {
    _ = {
      desktop = {
        managers = {
          gnome = {
            stylix = {
              enable = true;
            };
          };
        };
        packages = {
          alacritty = {
            enable = true;
            stylix = {
              enable = true;
            };
            favorite = 10;
          };
          nautilus = {
            favorite = 50;
          };
        };
        theming = {
          stylix = {
            image = ../../../../wallpapers/kde-breeze/light.png;
            scheme = "humanoid-light";
            polarity = "light";

            fonts = {
              fonts = {
                serif = {
                  package = pkgs.ubuntu-sans;
                  name = "Ubuntu";
                };
                sansSerif = {
                  package = pkgs.ubuntu-sans;
                  name = "Ubuntu";
                };
                monospace = {
                  package = pkgs.nerd-fonts.jetbrains-mono;
                  name = "JetBrainsMono Nerd Font";
                };
              };
              sizes = {
                applications = 10;
                desktop = 10;
                popups = 10;
                terminal = 12;
              };
            };
            opacity = {
              terminal = 0.65;
            };
          };
        };
      };
    };
  };
}
