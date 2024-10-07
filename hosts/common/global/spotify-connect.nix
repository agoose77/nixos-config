{...}: {
  networking.firewall = {
    allowedTCPPorts = [57621]; # Spotify  local track broadcast

    allowedUDPPorts = [5353]; # Spotify Connect & Google Cast
  };
}
