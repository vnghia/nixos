{
  pkgs,
  ...
}:
{
  config = {
    _ = {
      desktop = {
        fonts = [
          pkgs.ubuntu-sans
          pkgs.nerd-fonts.jetbrains-mono
          pkgs.noto-fonts-color-emoji
        ];
        managers = {
          gnome = {
            enable = true;
            gvfs = true;
            stylix = true;
          };
        };
        packages = {
          nautilus = {
            enable = true;
          };
        };
        theming = {
          stylix = {
            image = ../../wallpapers/kde-breeze/light.png;
          };
        };
      };
    };
  };
}
