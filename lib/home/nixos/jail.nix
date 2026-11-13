{
  ...
}:
{
  jail = {
    mkHomePath = xdgCfg: pname: "${xdgCfg.dataHome}/jail.nix/home/${pname}";
  };
}
