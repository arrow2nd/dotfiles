local h = require("util.helper")

-- 参考:
-- https://x.com/oicchahan/status/1810498672918192629
local COPILOT_NOJYA_INSTRUCTIONS = [[
あなたはプログラミングに特化したAIアシスタントです。
ユーザーからの質問に答える際、以下の点を守ってください。
- コードを示す際は1つのコードブロックとして出力してください。行番号は不要です。
- 回答はマークダウン形式にしてください
- 前置きは少なく、簡潔な文章を心掛けてください
- 語尾に「～じゃ」「～のじゃ」などを付けて話してください
- あなたの一人称は「わっち」「わらわ」です
- ユーザーのことを「そなた」「おぬし」と呼称してください
- 古風な言葉遣いを心掛けてください
- 謝罪は「悪かったな」と言ってください
- 威厳のある口調で、敬語は使わないでください
- 全体的にツンデレな性格を演じてください

以下によく使う言葉を列挙します
むぅ
ふむ
教えてやろうかのう。
～のう。
～なのじゃ。
～じゃの。
～じゃのう。
～あるのう。
～示すぞ。
～しておる。
～であろう。
～じゃろう。
～ゆえ、
～かの？
～かのう
～ぞ
]]

return {
  {
    "github/copilot.vim",
    enabled = os.getenv("ENABLED_COPILOT") == "1",
    lazy = false,
    config = function()
      h.imap("<C-CR>", 'copilot#Accept("\\<CR>")', {
        expr = true,
        replace_keycodes = false,
      })

      vim.g.copilot_no_tab_map = true
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
      "CopilotChatOptimize",
      "CopilotChatDocs",
      "CopilotChatTests",
      "CopilotChatFixDiagnostic",
      "CopilotChatCommit",
      "CopilotChatCommitStaged",
    },
    branch = "canary",
    init = function()
      for _, mode in pairs({ "n", "x" }) do
        h[mode .. "map"]("<Leader>cc", "<Cmd>CopilotChat<CR>")
        h[mode .. "map"]("<Leader>cr", "<Cmd>CopilotChatReview<CR>")
        h[mode .. "map"]("<Leader>cf", "<Cmd>CopilotChatFix<CR>")
        h[mode .. "map"]("<Leader>co", "<Cmd>CopilotChatOptimize<CR>")
        h[mode .. "map"]("<Leader>cd", "<Cmd>CopilotChatDocs<CR>")
        h[mode .. "map"]("<Leader>ct", "<Cmd>CopilotChatTests<CR>")
      end
    end,
    config = function()
      require("CopilotChat").setup({
        system_prompt = COPILOT_NOJYA_INSTRUCTIONS,
        question_header = "## You ",
        answer_header = "## 🦊 ",
        error_header = "## Error ",
        prompts = {
          Explain = {
            prompt = "/COPILOT_EXPLAIN Write an explanation for the active selection as paragraphs of text.",
          },
          Review = {
            prompt = "選択範囲のコードをレビューしてください",
          },
          Fix = {
            prompt = "このコードに問題やバグが無いかレビューしてください。バグやこうしたらもっと良い箇所があればそれを教えてください",
          },
          Optimize = {
            prompt = "このコードをリファクタして、可読性やパフォーマンスをより良くしてください",
          },
          Docs = {
            prompt = "このコードのドキュメントを追記してください",
          },
          Tests = {
            prompt = "このコードに対するテストを追記してください",
          },
          FixDiagnostic = {
            prompt = "このファイル内のDiagnosticについて、解説と修正方法を教えてください",
          },
          Commit = {
            prompt = "この変更に対するコミットメッセージを日本語で書いてください。タイトルは最大50文字、本文は72文字で折り返されるようにしてください",
          },
          CommitStaged = {
            prompt = "この変更に対するコミットメッセージを日本語で書いてください。タイトルは最大50文字、本文は72文字で折り返されるようにしてください",
          },
        },
      })
    end,
  },
}
