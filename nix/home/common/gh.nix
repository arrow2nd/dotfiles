{ pkgs, ... }:
let
  gh-q = import ../../pkgs/gh-q.nix { inherit pkgs; };
in
{
  programs.gh = {
    enable = true;
    extensions = [ gh-q ];
  };
}
