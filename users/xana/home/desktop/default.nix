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
        frameworks = {
          gtk = {
            stylix = {
              enable = true;
            };
          };
          qt = {
            stylix = {
              enable = true;
            };
          };
        };
        managers = {
          gnome = {
            location = true;
            stylix = {
              enable = true;
            };
            themes = {
              light = "light";
              dark = "dark";
            };
            dconf = {
              org.gnome.desktop.peripherals = {
                mouse = {
                  speed = 0.5;
                };
                touchpad = {
                  speed = 0.5;
                };
              };
            };
          };
        };
        packages = {
          alacritty = {
            enable = true;
            stylix = {
              enable = true;
              config = {
                fonts.override.sizes.terminal = 12;
              };
            };
            favorite = 10;
          };
          keepassxc = {
            enable = true;
            autostart = true;
          };
          nautilus = {
            enable = true;
            favorite = 50;
          };
          signal-desktop = {
            enable = true;
          };
          zen-browser = {
            enable = true;
            default = true;
            stylix = {
              enable = true;
            };
            favorite = 1;
          };
          vscodium = {
            enable = true;
            stylix = {
              enable = true;
              config = {
                fonts.override.sizes.terminal = 10.5;
              };
            };
            favorite = 5;
          };
        };
        theming = {
          stylix = {
            default = "light";
            themes = {
              light = {
                image = ../../../../wallpapers/kde-breeze/light.png;
                scheme = "humanoid-light";
                polarity = "light";
              };
              dark = {
                image = ../../../../wallpapers/kde-breeze/dark.png;
                scheme = "humanoid-dark";
                polarity = "dark";
              };
            };

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
                terminal = 11;
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
