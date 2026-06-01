{
  config = {
    cli = {
      packages = {
        git = {
          enable = true;
          user = {
            name = "Vo Van Nghia";
            email = "git@vnghia.com";
          };
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
}
