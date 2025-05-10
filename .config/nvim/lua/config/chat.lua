local h = require("util.helper")

require("CopilotChat").setup({
  model = "claude-3.7-sonnet",
  agent = "copilot",
  window = {
    layout = "vertical", -- 'vertical', 'horizontal', 'float', 'replace'
    width = 0.3,
    height = 0.5,
    relative = "editor", -- 'editor', 'win', 'cursor', 'mouse'
    border = "single", -- 'none', single', 'double', 'rounded', 'solid', 'shadow'
    title = "Copilot Chat",
  },
  question_header = "# 🦊 ",
  answer_header = "# 🤖 ",
  error_header = "# ⚠️ ",
  separator = "───",
  prompts = {
    Explain = {
      prompt = "Write an explanation for the selected code as paragraphs of text.",
      system_prompt = "COPILOT_EXPLAIN",
    },
    Review = {
      prompt = "Review the selected code.",
      system_prompt = "COPILOT_REVIEW",
    },
    Fix = {
      prompt = "There is a problem in this code. Identify the issues and rewrite the code with fixes. Explain what was wrong and how your changes address the problems.",
    },
    Optimize = {
      prompt = "Optimize the selected code to improve performance and readability. Explain your optimization strategy and the benefits of your changes.",
    },
    Docs = {
      prompt = "Please add documentation comments to the selected code.",
    },
    Tests = {
      prompt = "Please generate tests for my code.",
    },
    Commit = {
      prompt = "Write commit message for the change with commitizen convention. Keep the title under 50 characters and wrap message at 72 characters. Format as a gitcommit code block.",
      context = "git:staged",
    },
  },
})

h.nmap("<Leader>cc", "<CMD>CopilotChat<CR>")
h.nmap("<Leader>cf", "<CMD>CopilotChatFix<CR>")
h.nmap("<Leader>ce", "<CMD>CopilotChatExplain<CR>")
h.nmap("<Leader>cr", "<CMD>CopilotChatReview<CR>")
h.nmap("<Leader>co", "<CMD>CopilotChatOptimize<CR>")
h.nmap("<Leader>cd", "<CMD>CopilotChatDocs<CR>")
h.nmap("<Leader>ct", "<CMD>CopilotChatTests<CR>")
h.nmap("<Leader>cm", "<CMD>CopilotChatCommit<CR>")
