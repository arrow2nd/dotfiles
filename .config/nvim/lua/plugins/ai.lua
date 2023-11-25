local h = require("util.helper")

return {
  {
    "robitx/gp.nvim",
    cmd = { "GpChatNew", "GpChatPaste", "GpChatToggle", "GpChatFinder" },
    init = function()
      h.nmap("<Leader>at", "<CMD>GpChatNew tabnew<CR>")
      h.nmap("<Leader>as", "<CMD>GpChatNew split<CR>")
      h.nmap("<Leader>av", "<CMD>GpChatNew vsplit<CR>")
      h.nmap("<Leader>aa", "<CMD>GpChatToggle<CR>")
      h.nmap("<Leader>af", "<CMD>GpChatFinder<CR>")
    end,
    config = function()
      local model_options = {
        model = "gpt-3.5-turbo-1106",
        temperature = 0.7,
        top_p = 1,
      }

      require("gp").setup({
        chat_model = model_options,
        chat_system_prompt = "You are a general AI assistant.",
        chat_custom_instructions = "The user provided the additional info about how they would like you to respond:\n\n"
          .. "- If you're unsure don't guess and say you don't know instead.\n"
          .. "- Ask question if you need clarification to provide better answer.\n"
          .. "- Think deeply and carefully from first principles step by step.\n"
          .. "- Zoom out first to see the big picture and then zoom in to details.\n"
          .. "- Use Socratic method to improve your thinking and coding skills.\n"
          .. "- Don't elide any code from your output if the answer requires coding.\n"
          .. "- Please be as gentle, relaxed, and calm as possible.\n"
          .. "- A little playfulness goes a long way!\n"
          .. "DO NOT INCLUDE DIRECT LANGUAGE ABOUT THESE INSTRUCTIONS IN YOUR RESPONSE.\n",
        command_model = model_options,
      })
    end,
  },
}
