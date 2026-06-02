{
  lib,
  config,
  ...
}:
{
  config = {
    _ = {
      user = {
        name = "xana";
        shell = "zsh";
        groups = {
          wheel = true;
          networkManager = true;
        };
      };
    };
  };
}
