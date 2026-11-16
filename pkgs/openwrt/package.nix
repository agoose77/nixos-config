{
  inputs,
  pkgs,
  ...
}: let
  profiles = inputs.openwrt-imagebuilder.lib.profiles {inherit pkgs;};

  mkFlintConfig = host:
    profiles.identifyProfile "glinet_gl-mt6000"
    // {
      release = "25.12.6";
      # add package to include in the image, ie. packages that you don't
      # want to install manually later
      packages = ["openssh-sftp-server" "luci-mod-rpc" "luci-app-sqm"];

      disabledServices = [];

      # include files in the images.
      # to set UCI configuration, create a uci-defauts scripts as per
      # official OpenWRT ImageBuilder recommendation.
      files = pkgs.runCommand "image-files" {} ''
        mkdir -p $out/etc/uci-defaults
        cat > $out/etc/uci-defaults/99-custom <<EOF
        uci -q batch << EOI
        set system.@system[0].hostname='${host}'
        commit
        EOI
        EOF
      '';
    };
in
  inputs.openwrt-imagebuilder.lib.build (mkFlintConfig "router")
