{
  config = {
    _ = {
      network = {
        networkManager = {
          enable = true;
          wifi = {
            backend = "iwd";
          };
        };
      };
    };
  };
}
