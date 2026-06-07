{
  pkgs,
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
        };
        fonts = [
          pkgs.ubuntu-sans
          pkgs.nerd-fonts.jetbrains-mono
          pkgs.noto-fonts-color-emoji
        ];
        managers = {
          gnome = {
            enable = true;
            stylix = true;
          };
        };
      };
    };
  };
}
