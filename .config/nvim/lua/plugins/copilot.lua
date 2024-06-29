return {
  {
    "github/copilot.vim",
    enabled = os.getenv("ENABLED_COPILOT") == "1",
    lazy = false,
    config = function()
      vim.g.copilot_no_tab_map = false
    end,
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    enabled = os.getenv("ENABLED_COPILOT") == "1",
    cmd = {
      "CopilotChat",
      "CopilotChatOpen",
      "CopilotChatToggle",
      "CopilotChatReview",
      "CopilotChatFix",
      "CopilotChatDocs",
      "CopilotChatTests",
    },
    branch = "canary",
    dependencies = {
      "github/copilot.vim",
      "nvim-lua/plenary.nvim",
    },
    config = true,
  },
}
