local android = require("android")
local Device = require("device")
local InputContainer = require("ui/widget/container/inputcontainer")
local DictQuickLookup = require("ui/widget/dictquicklookup")
local _ = require("gettext")

local AskEinkBro = InputContainer:new {
  name = "askeinkbro",
  is_doc_only = true,
}

local external = require("device/thirdparty"):new{
  dicts = {
      { "Aard2", "Aard2", false, "itkach.aard2", "aard2" },
      { "Alpus", "Alpus", false, "com.ngcomputing.fora.android", "search" },
      { "ColorDict", "ColorDict", false, "com.socialnmobile.colordict", "send" },
      { "Eudic", "Eudic", false, "com.eusoft.eudic", "send" },
      { "EudicPlay", "Eudic (Google Play)", false, "com.qianyan.eudic", "send" },
      { "Fora", "Fora Dict", false, "com.ngc.fora", "search" },
      { "ForaPro", "Fora Dict Pro", false, "com.ngc.fora.android", "search" },
      { "GoldenFree", "GoldenDict Free", false, "mobi.goldendict.android.free", "send" },
      { "GoldenPro", "GoldenDict Pro", false, "mobi.goldendict.android", "send" },
      { "Kiwix", "Kiwix", false, "org.kiwix.kiwixmobile", "text" },
      { "LookUp", "Look Up", false, "gaurav.lookup", "send" },
      { "LookUpPro", "Look Up Pro", false, "gaurav.lookuppro", "send" },
      { "Mdict", "Mdict", false, "cn.mdict", "send" },
      { "QuickDic", "QuickDic", false, "de.reimardoeffinger.quickdic", "quickdic" },
      { "EinkBro", "EinkBro", false, "info.plateaukao.einkbro", "text" },
  },
  check = function(self, app)
      return android.isPackageEnabled(app)
  end,
}

local function getExternalDictLookupList(self) 
  return external.dicts 
end

local doExternalDictLookup = function (self, text, method, callback)
  external.when_back_callback = callback
  local _, app, action = external:checkMethod("dict", method)
  if action then
      android.dictLookup(text, app, action)
  end
end

function AskEinkBro:init()
  self.ui.highlight:addToHighlightDialog("askeinkbro_basic", function(this)
    return {
      text = _("EinkBro Word"),
      enabled = yes,
      callback = function()
        android.dictLookup(this.selected_text.text, "info.plateaukao.einkbro", "text")
        this:onClose()
      end,
    }
  end)
  self.ui.highlight:addToHighlightDialog("askeinkbro_context", function(this)
    prev_context, next_context = self.ui.highlight:getSelectedWordContext(10)
    content = prev_context .. "<<" .. this.selected_text.text .. ">>" .. next_context
    return {
      text = _("EinkBro Context"),
      enabled = yes,
      callback = function()
        android.dictLookup(content, "info.plateaukao.einkbro", "text")
        this:onClose()
      end,
    }
  end)
  Device.getExternalDictLookupList = getExternalDictLookupList
  Device.doExternalDictLookup = doExternalDictLookup
end

function AskEinkBro:onDictButtonsReady(dict_popup, buttons)
  table.insert(buttons, {
      {
          id = "einkbro",
          text = "Query EinkBro",
          enabled = true,
          callback = function()
              android.dictLookup(dict_popup.word, "info.plateaukao.einkbro", "text")
              dict_popup:onClose()
          end,
      }
  })
end

return AskEinkBro