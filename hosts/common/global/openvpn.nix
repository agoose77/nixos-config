
{...}: {
  services.openvpn.servers = {
    londonBiscuits  = { config = '' config /root/nixos/openvpn/londonBiscuits.conf ''; };
  };
}
