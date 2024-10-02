local h = require("util.helper")

return {
  {
    "mistweaverco/kulala.nvim",
    init = function()
      vim.filetype.add({
        extension = {
          ["http"] = "http",
        },
      })

      h.nmap("<Leader>k", ":lua require('kulala').scratchpad()<CR>")
    end,
    opts = {
      curl_path = "curl",
      split_direction = "vertical",
      default_view = "body",

      -- dev, test, prod, can be anything
      -- see: https://learn.microsoft.com/en-us/aspnet/core/test/http-files?view=aspnetcore-8.0#environment-files
      default_env = "dev",

      -- can be used to show loading, done and error icons in inlay hints
      -- possible values: "on_request", "above_request", "below_request", or nil to disable
      -- If "above_request" or "below_request" is used, the icons will be shown above or below the request line
      -- Make sure to have a line above or below the request line to show the icons
      show_icons = "on_request",

      -- default icons
      icons = {
        inlay = {
          loading = "󱦟",
          done = "",
          error = "",
        },
      },

      -- additional cURL options
      -- see: https://curl.se/docs/manpage.html
      additional_curl_options = {},

      winbar = false,

      -- Specify the panes to be displayed by default
      -- Current available pane contains { "body", "headers", "headers_body", "script_output" },
      default_winbar_panes = { "body", "headers", "headers_body" },

      -- enable reading vscode rest client environment variables
      vscode_rest_client_environmentvars = false,

      -- disable the vim.print output of the scripts
      -- they will be still written to disk, but not printed immediately
      disable_script_print_output = false,

      -- set scope for environment and request variables
      -- possible values: b = buffer, g = global
      environment_scope = "b",

      certificates = {},
    },
  },
}
