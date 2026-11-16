{host, ...}: {
  openwrt."${host}" = {
    sopsSecrets = ./secrets.yaml;
    uci = {
      # Do not wipe this config if it already exists,
      # either because it's a pain to manage and/or it breaks things if we clobber it
      retain = [
        "ucitrack"
        "firewall"
        "luci"
        "rpcd"
      ];
      settings = {
        system.system = [{notes._secret = "notes";}];
        network = {
          interface.loopback = {
            device = "lo";
            ipaddr = ["127.0.0.1/8"];
            proto = "static";
          };
          globals = [
            {
              ula_prefix = "fd61:785d:d25c::/48";
              packet_steering = "1";
              "dhcp_default_duid" = "0004b73548fe0601493ca59b8b8d3317cff5";
            }
          ];
          interface.lan = {
            device = "br-lan";
            proto = "static";
            ip6assign = "60";
            ipaddr = ["192.168.1/24"];
            multipath = "off";
          };
          interface.wan = {
            proto = "ppoe";
            username._secret = "ppoe_username";
            password._secret = "ppoe_password";
            ipv6 = "auto";
            norelease = "1";
            multipath = "off";
            device = "eth1";
            peerdns = "0";
            dns = ["9.9.9.9"];
          };
          device = [
            {
              name = "br-lan";
              ports = ["lan1" "lan2" "lan3" "lan4" "lan5"];
              type = "bridge";
            }
            {
              name = "br-wan";
              type = "bridge";
            }
            {
              name = "phy0-ap0";
              multicast_to_unicast = "1";
            }
            {
              name = "eth0";
              mtu = "1500";
              mtu6 = "1500";
            }
          ];

          #       config globals 'globals'
          #	option dhcp_default_duid '0004b73548fe0601493ca59b8b8d3317cff5'
          #	option ula_prefix 'fd61:785d:d25c::/48'
          #	option packet_steering '1'
        };
      };
    };
  };
}
