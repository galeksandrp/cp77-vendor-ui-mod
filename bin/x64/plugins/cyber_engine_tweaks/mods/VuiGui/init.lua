local VuiGui = {
  title = "VUI GUI",
  version = "1.50.3",
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
          title = "Stock Availability (%) [0% = Vanilla]",
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
      }
    },
    {
      name = "PriceManagement",
      title = "Price Management",
      desc = "Enables settings related to price management.",
      args = {
        "currentSetting",
        "defaultSetting",
        "callback",
      },
      children = {
        {
          name = "EqualPrices",
          type = "switch",
          title = "Equal Prices",
          desc = "Equalizes Player prices to Vendor prices.",
          args = {
            "currentSetting",
            "defaultSetting",
            "callback",
          },
        },
        {
          name = "PlayerItemPriceMultiplier",
          type = "rangeInt",
          title = "Player Price Multiplier (%) [100% = 1]",
          desc = "Applies price multiplier only for Player.",
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
          name = "VendorItemPriceMultiplier",
          type = "rangeInt",
          title = "Vendor Price Multiplier (%) [100% = 1]",
          desc = "Applies price multiplier only for Vendors.",
          args = {
            0,
            500,
            1,
            "currentSetting",
            "defaultSetting",
            "callback"
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
      name = "UIUXImp",
      title = "UI & UX Improvements",
      children = {
        {
          name = "FixDropdownPosition",
          type = "switch",
          title = "Fix Dropdown Position",
          desc = "Solves the problem of incorrectly placed dropdown position in Cyberware screen.",
          args = {
            "currentSetting",
            "defaultSetting",
            "callback",
          },
        },
        {
          name = "FixInventoryFilter",
          type = "switch",
          title = "Fix Inventory Filter",
          desc = "Solves the problem that the relevant filters are not selected on the Inventory Screen.",
          args = {
            "currentSetting",
            "defaultSetting",
            "callback",
          },
        },
        {
          name = "AddOwnedLabel",
          type = "switch",
          title = "Add Owned Label",
          desc = "Displays \"OWNED\" label for items already owned by the Player in Vendor items.",
          args = {
            "currentSetting",
            "defaultSetting",
            "callback",
          },
        },
        {
          name = "DisableVendorAutoSave",
          type = "switch",
          title = "Disable Vendor Auto Save",
          desc = "Toggles the autosave feature on the Vendor screen.",
          args = {
            "currentSetting",
            "defaultSetting",
            "callback",
          },
        },
      }
    },
  }
}
local VuiModInstance = {}
local vendorMultiplier = nil
local playerInstance = nil
local nativeSettings = nil

function UpperFirst(str)
  return (str:gsub("^%l", string.upper))
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

    -- We should implement PriceManagement here because
    -- we are not able to wrap native functions with redscript
    ObserveAfter("FullscreenVendorGameController", "Init", function(self)
      if VuiModInstance.SectionPriceManagement and VuiModInstance.OptionEqualPrices then
        local ssc = Game.GetScriptableSystemsContainer()
        local MarketSystem = ssc:Get(CName.new('MarketSystem'))
        local vendorInstance = self.VendorDataManager and MarketSystem:GetVendor(self.VendorDataManager:GetVendorInstance())

        vendorMultiplier = vendorInstance and vendorInstance:GetPriceMultiplier() or 1
        playerInstance = GetPlayer()
      end
    end)

    ObserveAfter("FullscreenVendorGameController", "OnUninitialize", function(self)
      vendorMultiplier = nil
      playerInstance = nil
    end)

    Override("RPGManager", "CalculateSellPrice", function(self, vendor, itemID, wrappedMethod)
      local calculatedPrice = wrappedMethod(vendor, itemID)

      if VuiModInstance.SectionPriceManagement then
        if VuiModInstance.OptionEqualPrices then
          calculatedPrice = Max(calculatedPrice, RoundF(RPGManager.CalculateBuyPrice(vendor, itemID, 9999) * (vendorMultiplier or 1)))
        end

        calculatedPrice =  RoundF(calculatedPrice * (Min(500, Max(0, VuiModInstance.OptionPlayerItemPriceMultiplier)) / 100))
      end

      return calculatedPrice
    end)

    Override("RPGManager", "CalculateBuyPrice", function(self, vendor, itemID, multiplier, wrappedMethod)
      local calculatedPrice = wrappedMethod(vendor, itemID, 1)

      if VuiModInstance.SectionPriceManagement then
        if VuiModInstance.OptionEqualPrices and multiplier == 9999 then
          return Max(calculatedPrice, playerInstance and wrappedMethod(playerInstance, itemID, 1) or 0)
        end

        calculatedPrice =  calculatedPrice * (Min(500, Max(0, VuiModInstance.OptionVendorItemPriceMultiplier)) / 100)
      end

      return RoundF(calculatedPrice * multiplier)
    end)
  end)

  registerForEvent("onShutdown", function()
    VuiModInstance = {}
    vendorMultiplier = nil
    playerInstance = nil
    nativeSettings = nil
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
        else
          VuiGui.savedSettings[settingKey] = nil
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

    if isSection and setting.children then
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
