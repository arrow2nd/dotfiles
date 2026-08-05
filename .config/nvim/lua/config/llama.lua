vim.g.llama_config = {
  keymap_fim_accept_full = "<C-CR>",

  -- <C-J> は skkeleton の起動キーと衝突するのと、n_cmpl = 1 なので潰す
  keymap_fim_next = "",
  keymap_fim_prev = "",

  -- instruct モードは 3B では実用にならないので無効
  keymap_inst_trigger = "",
  keymap_inst_rerun = "",
  keymap_inst_continue = "",
  keymap_inst_accept = "",
  keymap_inst_cancel = "",

  -- 推論時間は出さない。1 = statusline, 2 = inline らしい
  show_info = 0,
}
