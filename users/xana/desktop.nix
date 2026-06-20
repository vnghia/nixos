{
  imports = [
    ./base.nix
  ];

  config = {
    _ = {
      users = {
        users = {
          xana = {
            home = ./home/desktop.nix;
          };
        };
      };
    };
  };
}
