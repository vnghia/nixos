{
  lib,
  config,
  ...
}:
{
  config = {
    user = {
      name = "xana";
      shell = "zsh";
      groups = {
        wheel = true;
        networkManager = true;
      };
    };
  };
}
