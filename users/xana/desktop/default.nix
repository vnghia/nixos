{
  pkgs,
  ...
}:
{
  imports = [
    ../base
  ];

  config = {
    _ = {
      users = {
        users = {
          xana = {
            home = import ../home/desktop { inherit pkgs; };
          };
        };
      };
    };
  };
}
