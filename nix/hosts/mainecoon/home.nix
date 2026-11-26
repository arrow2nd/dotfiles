{ pkgs, lib, ... }:
let
  # nixpkgs の llama-cpp は inkling2_loop (b12xxx で追加) に未対応のため upstream のタグに差し替える
  llamaCppRocm = pkgs.llama-cpp-rocm.overrideAttrs (
    finalAttrs: old: {
      version = "12776";
      src = pkgs.fetchFromGitHub {
        owner = "ggml-org";
        repo = "llama.cpp";
        tag = "b${finalAttrs.version}";
        hash = "sha256-dYPp3PGNyLM7dVp6YzhzGtgoHKHPccOFKFBlJ+zR8gE=";
        leaveDotGit = true;
        postFetch = ''
          git -C "$out" rev-parse --short HEAD > $out/COMMIT
          find "$out" -name .git -print0 | xargs -0 rm -rf
        '';
      };

      # Web UI は ui/ 配下へ移動し、ビルドも任意になったため npm でのビルドを外す
      nativeBuildInputs = lib.remove pkgs.npmHooks.npmConfigHook old.nativeBuildInputs;
      npmDeps = null;
      preConfigure = ''
        prependToVar cmakeFlags "-DLLAMA_BUILD_COMMIT:STRING=$(cat COMMIT)"
      '';
      cmakeFlags = old.cmakeFlags ++ [
        (lib.cmakeBool "LLAMA_BUILD_UI" false)
        # ビルド時に HF から UI を取得しようとするとサンドボックス内で失敗する
        (lib.cmakeBool "LLAMA_USE_PREBUILT_UI" false)
      ];
    }
  );
in
{
  imports = [
    ../../home/common/lib.nix
    ../../home/common/shell.nix
    ../../home/common/nvim.nix
    ../../home/common/dotfiles-symlinks.nix
    ../../home/common/trash-cleanup.nix
  ];

  home.stateVersion = "26.05";
  programs.home-manager.enable = true;
  nixpkgs.config.allowUnfree = true;

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "arrow2nd";
        email = "44780846+arrow2nd@users.noreply.github.com";
      };
      core.editor = "nvim";
      pull.rebase = false;
    };
  };

  home.packages = with pkgs; [
    fzf
    eza
    fd
    bat
    ripgrep
    jq
    trash-cli
    ghq
    yazi
    fastfetch

    llamaCppRocm
    python3Packages.huggingface-hub
    uv
  ];
}
