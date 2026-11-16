{inputs, ...}: {
  perSystem = {
    self',
    pkgs,
    lib,
    ...
  }: let
    host = "router";
    profile = "glinet_gl-mt6000";
    release = "25.12.6";
  in {
    packages = {
      # Define image build
      "${host}-image" = let
        profiles = inputs.openwrt-imagebuilder.lib.profiles {inherit pkgs;};
      in
        inputs.openwrt-imagebuilder.lib.build (profiles.identifyProfile profile
          // {
            inherit release;
            # add package to include in the image, ie. packages that you don't
            # want to install manually later
            packages =
              [
                "-apk-mbedtls"
                "-libustream-mbedtls"
                "-wpad-basic-mbedtls"
              ]
              ++ [
                "apk-openssl"
                "libustream-openssl"
                "wpad-openssl"
              ]
              ++ ["luci" "luci-app-attendedsysupgrade" "openssh-sftp-server" "luci-mod-rpc" "luci-app-sqm"];

            disabledServices = [];

            # TODO: pull this into a bootstrap derivation?
            files = pkgs.runCommand "image-files" {} ''
              mkdir -p $out/etc/uci-defaults
              cat > $out/etc/uci-defaults/99-bootstrap <<EOF
              uci -q batch << EOI
              set system.@system[0].hostname='${host}'
              commit
              EOI
              EOF
            '';
          });
      # Define config deployer
      "${host}-deploy" =
        (import inputs.dewclaw {
          inherit pkgs;
          configuration = import ./_uci.nix {
            inherit host;
          };
        }).targets.${
          host
        };
    };
  };
}
