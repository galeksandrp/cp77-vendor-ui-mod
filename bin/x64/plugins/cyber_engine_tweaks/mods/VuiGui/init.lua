local VuiGui = {
  title = "VUI GUI",
  version = "1.31",
  basePath = "/VuiGui",
  savedSettingsPath = "settings.json",
  savedSettings = {},
  settings = {
    {
      name = "VendorStock",
      title = "Vendor Stock",
      desc = "Enables settings related to Vendor stock.",
      args = {
        "currentSetting",
        "defaultSetting",
        "callback",
      },
      children = {
        {
          name = "DaysToRestock",
          type = "rangeInt",
          title = "Days To Restock [0 = Instant]",
          desc = "Applies number of days to restock for Vendors.",
          args = {
            0,
            5,
            1,
            "currentSetting",
            "defaultSetting",
            "callback"
          },
        },
        {
          name = "StockAvailability",
          type = "rangeInt",
          title = "Stock Availability (%)",
          desc = "Changes stock availability for Vendors.",
          args = {
            0,
            100,
            1,
            "currentSetting",
            "defaultSetting",
            "callback"
          },
        },
        {
          name = "MoneyAvailability",
          type = "rangeInt",
          title = "Money Availability (%)",
          desc = "Changes money availability for Vendors.",
          args = {
            0,
            500,
            1,
            "currentSetting",
            "defaultSetting",
            "callback"
          },
        },
        {
          name = "ItemPriceMultiplier",
          type = "rangeInt",
          title = "Price Multiplier (%) [100% = 1]",
          desc = "Applies price multiplier for both Player & Vendors.",
          args = {
            0,
            200,
            1,
            "currentSetting",
            "defaultSetting",
            "callback"
          },
        },
        {
          name = "ItemBuyingPriceMultiplier",
          type = "rangeInt",
          title = "Buying Price Multiplier (%) [100% = 1]",
          desc = "Applies price multiplier only for Vendors. Dependent on \"Price Multiplier\".",
          args = {
            0,
            200,
            1,
            "currentSetting",
            "defaultSetting",
            "callback"
          },
        },
        {
          name = "KnownRecipesHidden",
          type = "switch",
          title = "Known Recipes Hidden",
          desc = "Hides known recipes from Vendors.",
          args = {
            "currentSetting",
            "defaultSetting",
            "callback",
          },
        },
      }
    },
    {
      name = "ArmorRaritySort",
      title = "Armor & Rarity Sort",
      desc = "Adds Armor sorting abiliy to DPS sort and renames Quality sort as Rarity.",
      args = {
        "currentSetting",
        "defaultSetting",
        "callback",
      },
      children = {
        {
          name = "TrueSorting",
          type = "switch",
          title = "True Sorting",
          desc = "Enables true sorting instead of the game's default.",
          args = {
            "currentSetting",
            "defaultSetting",
            "callback",
          },
        },
      }
    },
    {
      name = "CraftingSpecsFilter",
      title = "Crafting Specs Filter",
      desc = "Changes Cyberware filter to Crafting Specs one. Due to this change, the Attachments filter also shows Cyberware now.",
      args = {
        "currentSetting",
        "defaultSetting",
        "callback",
      },
    },
    {
      name = "UiFixes",
      title = "UI Fixes",
      children = {
        {
          name = "DropdownPositionFix",
          type = "switch",
          title = "Dropdown Position Fix",
          desc = "Solves the problem of incorrectly placed dropdown position in Cyberware screen.",
          args = {
            "currentSetting",
            "defaultSetting",
            "callback",
          },
        },
        {
          name = "InventoryFilterFix",
          type = "switch",
          title = "Inventory Filter Fix",
          desc = "Solves the problem where Grenades & Consumables would not be displayed when navigating from another Inventory screen.",
          args = {
            "currentSetting",
            "defaultSetting",
            "callback",
          },
        },
        {
          name = "IconicNotificationFix",
          type = "switch",
          title = "Iconic Notification Fix",
          desc = "Solves the problem of missing notification message when you want to disassemble Iconic items on the Inventory screen.",
          args = {
            "currentSetting",
            "defaultSetting",
            "callback",
          },
        }
      }
    },
  }
}
local VuiModInstance = {}
local nativeSettings

function UpperFirst(str)
  return (str:gsub("^%l", string.upper))
end

function Round(num)
  return num + (2^52 + 2^51) - (2^52 + 2^51)
end

function DeepCopy(original)
	local copy = {}

	for k, v in pairs(original) do
		if type(v) == "table" then
			v = DeepCopy(v)
		end

		copy[k] = v
	end
	return copy
end

function VuiGui.new()
  registerForEvent("onInit", function()
    nativeSettings = GetMod("nativeSettings")

    if not nativeSettings then
      print("Error: NativeSettings not found!")
      return
    end

    VuiModInstance = VuiMod.Get()

    VuiGui.LoadSettings()
    VuiGui.BuildSettings()

    ObserveAfter("PlayerPuppet", "OnGameAttached", function(self)
      if self:IsReplacer() == false then
        -- print("***************** CET PlayerPuppet OnGameAttached")
        VuiModInstance = VuiMod.Get()
        VuiGui.LoadSettings()
      end
    end)

    -- Because we are not able to wrap native functions with redscript
    Override("RPGManager", "CalculateSellPrice", function(self, vendor, itemID, wrappedMethod)
      if VuiModInstance.SectionVendorStock then
        local sellingPrice = wrappedMethod(vendor, itemID) * 10
        local sellingPriceMultiplier = math.min(200, math.max(0, VuiModInstance.OptionItemPriceMultiplier)) / 100

        return Round(sellingPrice * sellingPriceMultiplier)
      else
        return wrappedMethod(vendor, itemID)
      end
    end)

    Override("RPGManager", "CalculateBuyPrice", function(self, vendor, itemID, multiplier, wrappedMethod)
      if VuiModInstance.SectionVendorStock then
        local buyingPrice = RPGManager.CalculateSellPrice(vendor, itemID)
        local buyingPriceMultiplier = math.min(200, math.max(0, VuiModInstance.OptionItemBuyingPriceMultiplier)) / 100

        return Round(buyingPrice * buyingPriceMultiplier)
      else
        return wrappedMethod(vendor, itemID, multiplier)
      end
    end)
  end)

  registerForEvent("onShutdown", function()
    nativeSettings = nil
    VuiModInstance = nil
  end)
end

function VuiGui.LoadSettings()
  local file = io.open(VuiGui.savedSettingsPath, "r")

  if file then
    local content = file:read("*a");

    if content ~= "" then
      VuiGui.savedSettings = json.decode( content )

      file:close()

      for settingKey, setting in pairs(VuiGui.savedSettings) do
        if VuiModInstance[settingKey] ~= nil then
          VuiModInstance[settingKey] = setting
        end
      end
    end
  end
end

function VuiGui.BuildSettings()
  nativeSettings.addTab(VuiGui.basePath, VuiGui.title .. " (" .. VuiGui.version .. ")")

  for _, setting in ipairs(VuiGui.settings) do
    setting.path = VuiGui.basePath .. "/" .. setting.name
    nativeSettings.addSubcategory(setting.path, setting.title)

    if setting.args then
      local settingArgs = DeepCopy(setting.args)

      for argKey, settingArg in ipairs(settingArgs) do
        if type(settingArg) == "string" then
          settingArgs[argKey] = VuiGui["Get" .. UpperFirst(settingArg) .. "For"](setting, true)
        end
      end

      setting.id = nativeSettings.addSwitch(setting.path, "Enable", setting.desc, table.unpack(settingArgs))
    end

    if setting.children and VuiGui.savedSettings["Section" .. setting.name] ~= false then
      VuiGui.DrawOptions(setting)
    end
  end
end

function VuiGui.DrawOptions(setting)
  for _, childSetting in ipairs(setting.children) do
    local childSettingArgs = DeepCopy(childSetting.args)

    for childArgKey, childSettingArg in ipairs(childSettingArgs) do
      if type(childSettingArg) == "string" then
        childSettingArgs[childArgKey] = VuiGui["Get" .. UpperFirst(childSettingArg) .. "For"](childSetting, false)
      end
    end

    childSetting.id = nativeSettings["add" .. UpperFirst(childSetting.type)](setting.path, childSetting.title, childSetting.desc or setting.desc, table.unpack(childSettingArgs))
  end
end

function VuiGui.EraseOptions(setting)
  for _, childSetting in ipairs(setting.children) do
    nativeSettings.removeOption(childSetting.id);
  end
end

function VuiGui.GetDefaultSettingFor(setting, isSection)
  return FromVariant(VuiModInstance:GetDefaultSettingFor(setting.name, isSection))
end

function VuiGui.GetCurrentSettingFor(setting, isSection)
  local actualName = isSection and "Section" .. setting.name or "Option" .. setting.name

  return VuiModInstance[actualName]
end

function VuiGui.GetCallbackFor(setting, isSection)
  return function(newValue)
    local actualName = isSection and "Section" .. setting.name or "Option" .. setting.name

    VuiModInstance[actualName] = newValue
    VuiGui.savedSettings[actualName] = newValue

    if isSection then
      if newValue then
        VuiGui.DrawOptions(setting)
      else
        VuiGui.EraseOptions(setting)
      end
    end

    local file = io.open(VuiGui.savedSettingsPath, "w")

    if file then
      file:write( json.encode(VuiGui.savedSettings) )
      file:close()
    end
  end
end

VuiGui.new()