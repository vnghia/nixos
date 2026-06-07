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
          gvfs = {
            enable = true;
          };
          nixLd = {
            enable = true;
          };
        };
      };
    };
  };
}
