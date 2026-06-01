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
      };
    };

    impermanence.directories = [
      "code"
    ];
  };
}
