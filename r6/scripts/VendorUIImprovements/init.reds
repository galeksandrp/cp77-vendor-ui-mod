@addField(PlayerPuppet)
public let VuiMod: ref<VuiMod>;

@addField(AllBlackboardDefinitions)
public let VuiMod: wref<VuiMod>;

public class VuiMod {
  private let gameInstance: GameInstance;
  private let inventoryManager: ref<InventoryDataManagerV2>;

  public let DpsLocKey: String;
  public let ArmorLocKey: String;
  public let RarityLocKey: String;
  public let CraftingSpecLocKey: String;

  public let DefaultSettings: array<array<Variant>>;

  public let SectionVendorStock: Bool;
  public let SectionArmorRaritySort: Bool;
  public let SectionCraftingSpecsFilter: Bool;

  public let OptionDaysToRestock: Int32;
  public let OptionStockAvailability: Int32;
  public let OptionMoneyAvailability: Int32;
  public let OptionItemPriceMultiplier: Int32;
  public let OptionItemBuyingPriceMultiplier: Int32;
  public let OptionKnownRecipesHidden: Bool;
  public let OptionTrueSorting: Bool;
  public let OptionDropdownPositionFix: Bool;
  public let OptionInventoryFilterFix: Bool;
  public let OptionIconicNotificationFix: Bool;

  private func Initialize(player: ref<PlayerPuppet>) {
    this.gameInstance = player.GetGame();
    this.inventoryManager = new InventoryDataManagerV2();

    this.DpsLocKey = "Lockey#15365";
    this.ArmorLocKey = "Lockey#40290";
    this.RarityLocKey = "Lockey#43282";
    this.CraftingSpecLocKey = "Lockey#19670";

    this.DefaultSettings = [
      [ToVariant("SectionVendorStock"), ToVariant(true)],
      [ToVariant("SectionArmorRaritySort"), ToVariant(true)],
      [ToVariant("SectionCraftingSpecsFilter"), ToVariant(true)],
      [ToVariant("OptionDaysToRestock"), ToVariant(1)],
      [ToVariant("OptionStockAvailability"), ToVariant(70)],
      [ToVariant("OptionMoneyAvailability"), ToVariant(150)],
      [ToVariant("OptionItemPriceMultiplier"), ToVariant(85)],
      [ToVariant("OptionItemBuyingPriceMultiplier"), ToVariant(115)],
      [ToVariant("OptionKnownRecipesHidden"), ToVariant(true)],
      [ToVariant("OptionTrueSorting"), ToVariant(true)],
      [ToVariant("OptionDropdownPositionFix"), ToVariant(true)],
      [ToVariant("OptionInventoryFilterFix"), ToVariant(true)],
      [ToVariant("OptionIconicNotificationFix"), ToVariant(true)]
    ];

    this.SectionVendorStock = FromVariant(this.GetDefaultSettingFor("VendorStock", true));
    this.SectionArmorRaritySort = FromVariant(this.GetDefaultSettingFor("ArmorRaritySort", true));
    this.SectionCraftingSpecsFilter = FromVariant(this.GetDefaultSettingFor("CraftingSpecsFilter", true));

    this.OptionDaysToRestock = FromVariant(this.GetDefaultSettingFor("DaysToRestock", false));
    this.OptionStockAvailability = FromVariant(this.GetDefaultSettingFor("StockAvailability", false));
    this.OptionMoneyAvailability = FromVariant(this.GetDefaultSettingFor("MoneyAvailability", false));
    this.OptionItemPriceMultiplier = FromVariant(this.GetDefaultSettingFor("ItemPriceMultiplier", false));
    this.OptionItemBuyingPriceMultiplier = FromVariant(this.GetDefaultSettingFor("ItemBuyingPriceMultiplier", false));
    this.OptionKnownRecipesHidden = FromVariant(this.GetDefaultSettingFor("KnownRecipesHidden", false));
    this.OptionTrueSorting = FromVariant(this.GetDefaultSettingFor("TrueSorting", false));
    this.OptionDropdownPositionFix = FromVariant(this.GetDefaultSettingFor("DropdownPositionFix", false));
    this.OptionInventoryFilterFix = FromVariant(this.GetDefaultSettingFor("InventoryFilterFix", false));
    this.OptionIconicNotificationFix = FromVariant(this.GetDefaultSettingFor("IconicNotificationFix", false));
  }

  public static func Create(player: ref<PlayerPuppet>) {
    let instance: ref<VuiMod> = new VuiMod();

    instance.Initialize(player);

    player.VuiMod = instance;
    GetAllBlackboardDefs().VuiMod = instance;
  }

  public static func Get() -> wref<VuiMod> {
    return GetAllBlackboardDefs().VuiMod;
  }

  public func GetDefaultSettingFor(name: String, isSection: Bool) -> Variant {
    let setting: array<Variant>;
    let settingName: String;
    let actualName: String;

    let i: Int32 = 0;
    while (i < ArraySize(this.DefaultSettings)) {
      setting = this.DefaultSettings[i];
      settingName = FromVariant(setting[0]);

      if isSection {
        actualName = "Section" + name;
      } else {
        actualName = "Option" + name;
      }

      if Equals(settingName, actualName) {
        return setting[1];
      }

      i += 1;
    }

    return ToVariant(-1);
  }

  public func BuildSortOptions() -> array<ref<DropdownItemData>> {
    let result: array<ref<DropdownItemData>>;
    let dpsName: CName = StringToName(GetLocalizedText(this.DpsLocKey) + " / " + GetLocalizedText(this.ArmorLocKey));

    ArrayPush(result, SortingDropdownData.GetDropdownItemData(ToVariant(ItemSortMode.Default), n"UI-Sorting-Default", IntEnum(0l)));
    ArrayPush(result, SortingDropdownData.GetDropdownItemData(ToVariant(ItemSortMode.NewItems), n"UI-Sorting-NewItems", IntEnum(0l)));
    ArrayPush(result, SortingDropdownData.GetDropdownItemData(ToVariant(ItemSortMode.NameAsc), n"UI-Sorting-Name", DropdownItemDirection.Down));
    ArrayPush(result, SortingDropdownData.GetDropdownItemData(ToVariant(ItemSortMode.NameDesc), n"UI-Sorting-Name", DropdownItemDirection.Up));
    ArrayPush(result, SortingDropdownData.GetDropdownItemData(ToVariant(ItemSortMode.DpsDesc), dpsName, DropdownItemDirection.Down));
    ArrayPush(result, SortingDropdownData.GetDropdownItemData(ToVariant(ItemSortMode.DpsAsc), dpsName, DropdownItemDirection.Up));
    ArrayPush(result, SortingDropdownData.GetDropdownItemData(ToVariant(ItemSortMode.QualityDesc), StringToName(this.RarityLocKey), DropdownItemDirection.Down));
    ArrayPush(result, SortingDropdownData.GetDropdownItemData(ToVariant(ItemSortMode.QualityAsc), StringToName(this.RarityLocKey), DropdownItemDirection.Up));
    ArrayPush(result, SortingDropdownData.GetDropdownItemData(ToVariant(ItemSortMode.WeightDesc), n"UI-Sorting-Weight", DropdownItemDirection.Down));
    ArrayPush(result, SortingDropdownData.GetDropdownItemData(ToVariant(ItemSortMode.WeightAsc), n"UI-Sorting-Weight", DropdownItemDirection.Up));
    ArrayPush(result, SortingDropdownData.GetDropdownItemData(ToVariant(ItemSortMode.PriceDesc), n"UI-Sorting-Price", DropdownItemDirection.Down));
    ArrayPush(result, SortingDropdownData.GetDropdownItemData(ToVariant(ItemSortMode.PriceAsc), n"UI-Sorting-Price", DropdownItemDirection.Up));
    ArrayPush(result, SortingDropdownData.GetDropdownItemData(ToVariant(ItemSortMode.ItemType), n"UI-Sorting-ItemType", IntEnum(0l)));

    return result;
  }

  public func BuildDataWrapperList(dataView: wref<ScriptableDataView>, left: ref<IScriptable>, right: ref<IScriptable>) -> array<ref<InventoryItemDataWrapper>> {
    let isCrafting: Bool = dataView.IsA(n"CraftingDataView");
    let isRipperdoc: Bool = dataView.IsA(n"CyberwareDataView");
    let itemDataList: array<InventoryItemData>;

    if !isCrafting && !isRipperdoc {
      itemDataList = [
        left as WrappedInventoryItemData.ItemData,
        right as WrappedInventoryItemData.ItemData
      ];
    } else {
      if isCrafting {
        if IsDefined(left as ItemCraftingData) && IsDefined(right as ItemCraftingData) {
          itemDataList = [
            left as ItemCraftingData.inventoryItem,
            right as ItemCraftingData.inventoryItem
          ];
        } else {
          itemDataList = [
            left as RecipeData.inventoryItem,
            right as RecipeData.inventoryItem
          ];
        }
      } else {
        itemDataList = [
          left as CyberwareDataWrapper.InventoryItem,
          right as CyberwareDataWrapper.InventoryItem
        ];
      }
    }


    let sortDataList: array<InventoryItemSortData> = [
      InventoryItemData.GetSortData(itemDataList[0]),
      InventoryItemData.GetSortData(itemDataList[1])
    ];

    let i: Int32 = 0;
    while (i < ArraySize(sortDataList)) {
      if Equals(sortDataList[i].Name, "") {
        sortDataList[i] = ItemCompareBuilder.BuildInventoryItemSortData(itemDataList[i], dataView.m_uiScriptableSystem);
      };

      i += 1;
    };

    let dataWrapperList: array<ref<InventoryItemDataWrapper>> = [
      new InventoryItemDataWrapper(),
      new InventoryItemDataWrapper()
    ];

    i = 0;
    while (i < ArraySize(dataWrapperList)) {
      dataWrapperList[i].ItemData = itemDataList[i];
      dataWrapperList[i].SortData = sortDataList[i];

      i += 1;
    };

    return dataWrapperList;
  }

  public func CreateItemCompareBuilder(dataWrapperList: array<ref<InventoryItemDataWrapper>>) -> ref<ItemCompareBuilder> {
    let builder: ref<ItemCompareBuilder> = new ItemCompareBuilder();

    builder.m_compareBuilder = CompareBuilder.Make();
    builder.m_sortData1 = dataWrapperList[0].SortData;
    builder.m_sortData2 = dataWrapperList[1].SortData;
    builder.itemData1 = dataWrapperList[0].ItemData;
    builder.itemData2 = dataWrapperList[1].ItemData;

    return builder;
  }

  public func DefaultSort(builder: ref<ItemCompareBuilder>) -> Bool {
    return builder.QualityDesc().ItemType().NameAsc().GetBool();
  }

  public func ArmorAsc(builder: ref<ItemCompareBuilder>) -> ref<ItemCompareBuilder> {
    builder.m_compareBuilder.FloatAsc(InventoryItemData.GetArmorF(builder.itemData1), InventoryItemData.GetArmorF(builder.itemData2));
    return builder;
  }

  public func ArmorDesc(builder: ref<ItemCompareBuilder>) -> ref<ItemCompareBuilder> {
    builder.m_compareBuilder.FloatDesc(InventoryItemData.GetArmorF(builder.itemData1), InventoryItemData.GetArmorF(builder.itemData2));
    return builder;
  }

  public func SortItem(dataView: ref<ScriptableDataView>, dataWrapperList: array<ref<InventoryItemDataWrapper>>) -> Bool {
    let compareBuilder: ref<ItemCompareBuilder> = this.CreateItemCompareBuilder(dataWrapperList);
    let isInventory: Bool = this.IsA(n"ItemModeGridView");

    if !isInventory {
      compareBuilder = dataView.PreSortingInjection(compareBuilder);
    }

    if Equals(dataView.m_itemSortMode, ItemSortMode.NewItems) {
      if isInventory {
        return this.DefaultSort(this.ArmorDesc(compareBuilder.NewItem(dataView.m_uiScriptableSystem).DPSDesc()));
      } else {
        return this.DefaultSort(compareBuilder.NewItem(dataView.m_uiScriptableSystem));
      }
    }

    if VuiMod.Get().OptionTrueSorting {
      switch dataView.m_itemSortMode {
        case ItemSortMode.NameAsc:
          return compareBuilder.NameAsc().GetBool();
        case ItemSortMode.NameDesc:
          return compareBuilder.NameDesc().GetBool();
        case ItemSortMode.DpsAsc:
            return this.ArmorAsc(compareBuilder.DPSAsc()).GetBool();
        case ItemSortMode.DpsDesc:
            return this.ArmorDesc(compareBuilder.DPSDesc()).GetBool();
        case ItemSortMode.QualityAsc:
          return compareBuilder.QualityAsc().PriceDesc().GetBool();
        case ItemSortMode.QualityDesc:
          return compareBuilder.QualityDesc().PriceDesc().GetBool();
        case ItemSortMode.WeightAsc:
          return compareBuilder.WeightAsc().QualityDesc().PriceDesc().GetBool();
        case ItemSortMode.WeightDesc:
          return compareBuilder.WeightDesc().QualityDesc().PriceDesc().GetBool();
        case ItemSortMode.PriceAsc:
          return compareBuilder.PriceAsc().GetBool();
        case ItemSortMode.PriceDesc:
          return compareBuilder.PriceDesc().GetBool();
        case ItemSortMode.ItemType:
          return compareBuilder.ItemType().QualityDesc().PriceDesc().GetBool();
      };
    } else {
      switch dataView.m_itemSortMode {
        case ItemSortMode.NameAsc:
          return compareBuilder.NameAsc().QualityDesc().GetBool();
        case ItemSortMode.NameDesc:
          return compareBuilder.NameDesc().QualityDesc().GetBool();
        case ItemSortMode.DpsAsc:
          return this.ArmorAsc(compareBuilder.DPSAsc()).QualityDesc().NameAsc().GetBool();
        case ItemSortMode.DpsDesc:
          return this.ArmorDesc(compareBuilder.DPSDesc()).QualityDesc().NameDesc().GetBool();
        case ItemSortMode.QualityAsc:
          return compareBuilder.QualityAsc().NameAsc().QualityDesc().GetBool();
        case ItemSortMode.QualityDesc:
          return compareBuilder.QualityDesc().NameAsc().QualityDesc().GetBool();
        case ItemSortMode.WeightAsc:
          return compareBuilder.WeightAsc().NameAsc().QualityDesc().GetBool();
        case ItemSortMode.WeightDesc:
          return compareBuilder.WeightDesc().NameAsc().QualityDesc().GetBool();
        case ItemSortMode.PriceAsc:
          return compareBuilder.PriceAsc().NameAsc().QualityDesc().GetBool();
        case ItemSortMode.PriceDesc:
          return compareBuilder.PriceDesc().NameAsc().QualityDesc().GetBool();
        case ItemSortMode.ItemType:
          return compareBuilder.ItemType().NameAsc().QualityDesc().GetBool();
      };
    }

    return this.DefaultSort(compareBuilder);
  }

  public func GetPoolCount(vendor: ref<Vendor>) -> Int32 {
    return vendor.GetVendorRecord().GetItemStockCount();
  }

  public func CalculateDaysToRestock() -> Float {
    let daysToRestock: Int32 = Min(5, Max(0, this.OptionDaysToRestock));
    let ingameTime: GameTime = GameTime.MakeGameTime(daysToRestock, 0);

    return Cast(GameTime.GetSeconds(ingameTime));
  }

  public func CalculateStockAvailability(vendor: ref<Vendor>) -> Int32 {
    let poolCount: Float = Cast(this.GetPoolCount(vendor));
    let stockAvailability: Float = MinF(100.0, MaxF(0.0, Cast(this.OptionStockAvailability))) / 100.0;

    return RoundF(poolCount * stockAvailability);
  }

  public func CalculateMoneyAvailability(quantity: Int32) -> Int32 {
    let money: Float = Cast(quantity);
    let moneyAvailability: Float = MinF(500.0, MaxF(0.0, Cast(this.OptionMoneyAvailability))) / 100.0;

    return RoundF(money * moneyAvailability);
  }

  public func CalculateVendorMoney(vendor: ref<Vendor>, player: ref<PlayerPuppet>, itemPool: script_ref<array<wref<VendorItem_Record>>>, newStock: script_ref<array<SItemStack>>) -> Void {
    let moneyRecord: wref<VendorItem_Record>;
    let itemStacks: array<SItemStack>;
    let i: Int32 = ArraySize(Deref(itemPool)) - 1;
    let j: Int32;

    while i >= 0 {
      if ItemID.IsOfTDBID(ItemID.FromTDBID(t"Items.money"), Deref(itemPool)[i].Item().GetID()) {
        if !IsDefined(moneyRecord) {
          moneyRecord = Deref(itemPool)[i];
        }

        ArrayErase(Deref(itemPool), i);
      }
      i -= 1;
    }

    if IsDefined(moneyRecord) {
      i = 0;
      while i < 2 {
        itemStacks = vendor.CreateStacksFromVendorItem(moneyRecord, player);

        j = 0;
        while j < ArraySize(itemStacks) {
          itemStacks[j].quantity = this.CalculateMoneyAvailability(itemStacks[j].quantity);
          ArrayPush(Deref(newStock), itemStacks[j]);
          j += 1;
        };

        i += 1;
      };
    }
  }

  public func GetItemStackQuantity(vendor: ref<Vendor>, player: ref<PlayerPuppet>, quantityMods: array<wref<StatModifier_Record>>) -> Int32 {
    return Max(1, RoundF(RPGManager.CalculateStatModifiers(quantityMods, vendor.m_gameInstance, player, Cast(vendor.m_vendorObject.GetEntityID()))));
  }

  public func FetchItemPrices(compareBuilder: ref<ItemCompareBuilder>) -> array<Int32> {
    let buyPrices: array<Int32> = [
      Cast(InventoryItemData.GetBuyPrice(compareBuilder.itemData1)),
      Cast(InventoryItemData.GetBuyPrice(compareBuilder.itemData2))
    ];
    let foundPrices: array<Int32> = [
      compareBuilder.m_sortData1.Price,
      compareBuilder.m_sortData2.Price
    ];
    let i: Int32 = 0;

    while (i < ArraySize(buyPrices)) {
      if buyPrices[i] != 0 {
        foundPrices[i] = buyPrices[i];
      }
      i += 1;
    }

    return foundPrices;
  }

  public func HasPlayerCraftingSpec(vendorItem: wref<VendorItem_Record>) -> Bool {
    let craftingSystem: ref<CraftingSystem> = CraftingSystem.GetInstance(this.gameInstance);

    return vendorItem.Item().TagsContains(n"Recipe") &&
      craftingSystem.IsRecipeKnown(TweakDBInterface.GetItemRecipeRecord(vendorItem.Item().GetID()).CraftingResult().Item().GetID(), craftingSystem.m_playerCraftBook);
  }

  public func OpenIconicDisassemblePopup(controller: wref<InventoryItemModeLogicController>, itemData: InventoryItemData) -> Void {
    let data: ref<VendorConfirmationPopupData> = new VendorConfirmationPopupData();

    data.notificationName = n"base\\gameplay\\gui\\widgets\\notifications\\vendor_confirmation.inkwidget";
    data.isBlocking = true;
    data.useCursor = true;
    data.queueName = n"modal_popup";
    data.itemData = itemData;
    data.quantity = InventoryItemData.GetQuantity(itemData);
    data.type = VendorConfirmationPopupType.DisassembeIconic;

    controller.m_confirmationPopupToken = controller.m_inventoryController.ShowGameNotification(data);
    controller.m_confirmationPopupToken.RegisterListener(controller, n"OnIconicDisassemblePopupClosed");
    controller.m_buttonHintsController.Hide();
  }
}

@wrapMethod(PlayerPuppet)
protected cb func OnGameAttached() -> Bool {
  // LogChannel(n"Debug", "***************** PlayerPuppet OnGameAttached");
  wrappedMethod();
  if !this.IsReplacer() {
    VuiMod.Create(this);
  }
}