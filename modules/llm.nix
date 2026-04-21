{ config, pkgs, inputs, ... }:
{
  services.ollama = {
    enable = true;
    package = pkgs.ollama-rocm; 
  };

  services.open-webui = {
    enable = true;
    environment = {
      OLLAMA_API_BASE_URL = "http://127.0.0.1:11434";
    };
  };
  #networking.firewall.allowedTCPPorts = [ 8080 ];

}
