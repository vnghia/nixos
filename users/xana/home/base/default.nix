{ pkgs, ... }:
{
  config = {
    home = {
      username = "xana";
      homeDirectory = "/home/xana";
    };

    programs.home-manager.enable = true;

    cli = {
      packages = {
        git = {
          enable = true;
          user = {
            name = "Vo Van Nghia";
            email = "git@vnghia.com";
          };
        };
      };
    };

    home.stateVersion = "26.05";
  };
}
