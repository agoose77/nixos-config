{
  services.openvpn.servers = {
    londonBiscuits = {
      autoStart = false;
      config = ''config /root/nixos/openvpn/londonBiscuits.conf '';
      updateResolvConf = true;
    };
  };
}
