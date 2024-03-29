local h = require("util.helper")

return {
  {
    "monaqa/dial.nvim",
    keys = { "<C-a>", "<C-x>" },
    config = function()
      local dial = require("dial.config")
      local augend = require("dial.augend")

      dial.augends:register_group({
        default = {
          augend.integer.alias.decimal,
          augend.integer.alias.hex,
          augend.constant.alias.bool,
          augend.semver.alias.semver,
          -- 日付
          augend.date.alias["%Y/%m/%d"],
          augend.date.alias["%Y-%m-%d"],
          augend.date.alias["%Y年%m月%d日"],
          augend.date.alias["%m月%d日"],
        },
      })

      h.nmap("<C-a>", require("dial.map").inc_normal(), { noremap = true })
      h.nmap("<C-x>", require("dial.map").dec_normal(), { noremap = true })
    end,
  },
}
