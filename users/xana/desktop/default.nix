{
  imports = [
    ../base
  ];

  config = {
    _ = {
      users = {
        users = {
          xana = {
            home = ../home/desktop;
          };
        };
      };
    };
  };
}
