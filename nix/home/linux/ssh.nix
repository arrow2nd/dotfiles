{ config, ... }:
let
  onePassSock = "${config.home.homeDirectory}/.1password/agent.sock";
in
{
  home.sessionVariables.SSH_AUTH_SOCK = onePassSock;
  programs.ssh.settings."*".identityAgent = onePassSock;
}
