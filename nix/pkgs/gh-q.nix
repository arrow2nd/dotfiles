# MIT License
#
# Copyright (c) 2021 カワリミ人形
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# ref: https://github.com/arrow2nd/gh-q

{ pkgs }:

let
  app = pkgs.writeShellApplication {
    name = "gh-q";
    runtimeInputs = with pkgs; [ gh fzf ghq ];
    text = ''
      DEFAULT_USER=$(gh api user -q .login)
      # shellcheck disable=SC2016
      REPO=$(gh api graphql --paginate -F owner="''${1:-$DEFAULT_USER}" -f query='
      query ($owner: String!, $endCursor: String) {
        repositoryOwner(login: $owner) {
          repositories(first: 30, after: $endCursor) {
            pageInfo { hasNextPage endCursor }
            nodes { nameWithOwner }
          }
        }
      }
      ' -q '.data.repositoryOwner.repositories.nodes[].nameWithOwner' | fzf)
      ghq get -p "$REPO" "''${@:2}"
    '';
  };
in
pkgs.stdenvNoCC.mkDerivation {
  pname = "gh-q";
  version = "0.1.0";
  dontUnpack = true;
  installPhase = ''
    mkdir -p $out/bin
    cp ${app}/bin/gh-q $out/bin/gh-q
  '';
}
