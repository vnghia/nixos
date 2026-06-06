{
  config = {
    _ = {
      system = {
        boot = {
          type = "lanzaboote";
        };
        nixos = {
          feature = {
            experimental = {
              common = {
                enable = true;
              };
            };
          };
        };
        packages = {
          nixLd = {
            enable = true;
          };
        };
      };
    };
  };
}
