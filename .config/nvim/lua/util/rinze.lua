-- rinze は devon と scottish だけに Nix で入れる（nix/home/{linux,darwin}/rinze.nix）。入っていない環境では読み込まない
local dir = vim.fn.stdpath("data") .. "/rinze"

return {
  dir = dir,
  available = vim.uv.fs_stat(dir) ~= nil and vim.fn.executable("rinzed") == 1,
}
