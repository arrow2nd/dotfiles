vim.cmd('imap <expr> <Tab> vsnip#jumpable(1) ? "<Plug>(vsnip-jump-next)" : "<Tab>"')
vim.cmd('smap <expr> <Tab> vsnip#jumpable(1) ? "<Plug>(vsnip-jump-next)" : "<Tab>"')
vim.cmd('imap <expr> <S-Tab> vsnip#jumpable(-1) ? "<Plug>(vsnip-jump-prev)" : "<S-Tab>"')
vim.cmd('smap <expr> <S-Tab> vsnip#jumpable(-1) ? "<Plug>(vsnip-jump-prev)" : "<S-Tab>"')
