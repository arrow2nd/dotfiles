local h = require("util.helper")
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

h.nmap("<C-a>", function()
	require("dial.map").manipulate("increment", "normal")
end, { noremap = true })

h.nmap("<C-x>", function()
	require("dial.map").manipulate("decrement", "normal")
end, { noremap = true })
