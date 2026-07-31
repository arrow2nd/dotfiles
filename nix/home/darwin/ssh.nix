{ config, ... }:
let
  # macOS の 1Password agent ソケット（パスにスペースを含むため ssh_config 上で quote が必要）
  onePassSock = "\"${config.home.homeDirectory}/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock\"";
in
{
  programs.ssh.settings."*".identityAgent = onePassSock;
}
