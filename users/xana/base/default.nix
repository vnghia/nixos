{
  lib,
  config,
  ...
}:
{
  config = {
    user = {
      username = "xana";
      groups = {
        wheel = true;
        networkManager = true;
      };
    };
  };
}
