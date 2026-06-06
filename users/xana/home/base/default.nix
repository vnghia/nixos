{
  config,
  ...
}:
{
  config = {
    _ = {
      cli = {
        packages = {
          eza = {
            enable = true;
          };
          git = {
            enable = true;
            user = {
              name = "Vo Van Nghia";
              email = "git@vnghia.com";
            };
          };
          just = {
            enable = true;
          };
          nh = {
            enable = true;
            clean = {
              enable = true;
            };
            flake = "${config.home.homeDirectory}/code/nixos";
          };
          starship = {
            enable = true;
          };
          uv = {
            enable = true;
          };
          vim = {
            enable = true;
          };
          zellij = {
            enable = true;
          };
          zoxide = {
            enable = true;
          };
        };
      };

      system.nixos.impermanence.directories = [
        "code"
      ];
    };
  };
}
