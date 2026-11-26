{ lib, pkgs }:
# nixpkgs の llama-cpp は inkling2_loop (b12xxx で追加) に未対応のため upstream のタグに差し替える
pkgs.llama-cpp-rocm.overrideAttrs (
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
)
