{
  config = {
    _ = {
      system = {
        boot = {
          type = "systemd";
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
