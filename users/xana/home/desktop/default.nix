{
  pkgs,
  config,
  ...
}:
let
  desktopCfg = config._.desktop;

  themes = {
    light = "light";
    dark = "dark";
  };
in
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
        i18n = {
          input = {
            type = "fcitx5";
            config = {
              fcitx5 = {
                globalOptions = {
                  Hotkey = {
                    "TriggerKeys/0" = "Control+space";
                  };
                  Behavior = {
                    ActiveByDefault = false;
                    ShareInputState = "All";
                    PreeditEnabledByDefault = true;
                    ShowInputMethodInformation = true;
                    showInputMethodInformationWhenFocusIn = false;
                    CompactInputMethodInformation = true;
                    ShowFirstInputMethodInformation = true;
                  };
                };
                addons = {
                  "unikey" = {
                    package = "kdePackages.fcitx5-unikey";
                    globalSection = {
                      InputMethod = "Simple Telex";
                      OutputCharset = "Unicode";
                      SpellCheck = false;
                      Macro = false;
                      ProcessWAtBegin = true;
                      AutoNonVnRestore = true;
                      ModernStyle = true;
                      FreeMarking = true;
                      SurroundingText = false;
                      ModifySurroundingText = false;
                      DisplayUnderline = false;
                    };
                  };
                  "mozc" = {
                    package = "fcitx5-mozc-ut";
                  };
                };
                inputMethod = {
                  GroupOrder = {
                    "0" = "Default";
                  };
                  "Groups/0" = {
                    Name = "Default";
                    "Default Layout" = "us";
                    DefaultIM = "keyboard-us";
                  };
                  "Groups/0/Items/0" = {
                    Name = "keyboard-us";
                  };
                  "Groups/0/Items/1" = {
                    Name = "unikey";
                  };
                  "Groups/0/Items/2" = {
                    Name = "mozc";
                  };
                };
                stylix = {
                  enable = true;
                };
              };
            };
          };
        };
        managers = {
          gnome = {
            location = true;
            stylix = {
              enable = true;
            };
            themes = themes;
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
        programs = {
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
          chromium = {
            enable = true;
          };
          keepassxc = {
            enable = true;
            autostart = true;
            defaultDatabase = "me.kdbx";
          };
          mpv = {
            enable = true;
          };
          mullvad = {
            enable = true;
            autostart = true;
          };
          nautilus = {
            enable = true;
            favorite = 50;
          };
          obsidian = {
            enable = true;
            stylix = {
              enable = true;
              config = {
                fonts.override.sizes.applications = 16;
                vaultNames = [
                  "me"
                ];
              };
            };
            vaults = {
              me = { };
            };
          };
          signal-desktop = {
            enable = true;
          };
          tailscale = {
            enable = true;
          };
          thunderbird = {
            enable = true;
            default = true;
            profiles = {
              me = {
                isDefault = true;
              };
            };
            favorite = 100;
          };
          zen-browser = {
            enable = true;
            default = true;
            profiles = {
              me = {
                isDefault = true;
              };
            };
            stylix = {
              enable = true;
              config = {
                profileNames = [ "me" ];
              };
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
        security = {
          secret = {
            type = "keepassxc";
            config = {
              keepassxc = {
                confirmAccessItem = false;
              };
            };
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

      services = {
        syncthing = {
          folders = {
            passwords = {
              id = "keepass";
              label = "passwords";
              devices = [
                "sun"
                "android"
              ];
              path = desktopCfg.programs.keepassxc.directory;
              type = "sendreceive";
              versioning = {
                type = "simple";
                params.keep = "10";
              };
            };
          };
        };
      };
    };
  };
}
