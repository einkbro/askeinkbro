local android = require("android")
local InputContainer = require("ui/widget/container/inputcontainer")
local _ = require("gettext")

local AskGPT = InputContainer:new {
  name = "askeinkbro",
  is_doc_only = true,
}

function AskGPT:init()
  self.ui.highlight:addToHighlightDialog("askeinkbro", function(_reader_highlight_instance)
    return {
      text = _("Query EinkBro"),
      enabled = yes,
      callback = function()
        android.dictLookup(_reader_highlight_instance.selected_text.text, "info.plateaukao.einkbro", "send")
      end,
    }
  end)
end

return AskGPT
