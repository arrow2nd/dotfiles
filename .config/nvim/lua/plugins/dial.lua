return {
  {
    "monaqa/dial.nvim",
    keys = { "<C-a>", "<C-x>" },
    config = function()
      local augend = require("dial.augend")
      require("dial.config").augends:register_group({
        default = {
          augend.integer.alias.decimal,
          augend.integer.alias.hex,
          augend.constant.alias.bool,
          augend.semver.alias.semver,
          augend.date.alias["%Y/%m/%d"],
        }
      })

      local h = require("util.helper")
      h.nmap("<C-a>", require("dial.map").inc_normal(), { noremap = true })
      h.nmap("<C-x>", require("dial.map").dec_normal(), { noremap = true })
    end
  }
}
