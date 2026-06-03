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
      user = {
        home = import ../home/desktop { inherit pkgs; };
      };
    };
  };
}
