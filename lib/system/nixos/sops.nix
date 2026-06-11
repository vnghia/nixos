{
  lib,
  ...
}:
let
  systemdService = "sops-nix.service";
in
{
  sops = {
    mkRequiresOption = with lib; {
      requiresSops = mkEnableOption "Sops requirement";
    };

    mkSystemdServiceRequirements =
      cfg:
      lib.mkIf cfg.requiresSops {
        Unit = {
          Requires = [ systemdService ];
          After = [ systemdService ];
        };
      };

    mkSecrets =
      pkgs: name: path:
      with pkgs;
      let
        secretsDerivation = (
          runCommandLocal name { nativeBuildInputs = [ sops ]; } ''
            mkdir $out
            export SOPS_AGE_KEY_FILE=${../../../secrets/keys/build.txt}
            sops decrypt ${path} --output-type json > $out/secrets.json
          ''
        );
      in
      (builtins.fromJSON (builtins.readFile "${secretsDerivation}/secrets.json"));
  };
}
