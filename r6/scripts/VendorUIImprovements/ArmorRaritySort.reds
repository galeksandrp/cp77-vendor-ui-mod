module VendorUIImprovements.ArmorRaritySort

@addField(ScriptableDataView)
public let m_itemSortMode: ItemSortMode;

@addField(ScriptableDataView)
public let m_uiScriptableSystem: wref<UIScriptableSystem>;

@addMethod(ScriptableDataView)
public func PreSortingInjection(builder: ref<ItemCompareBuilder>) -> ref<ItemCompareBuilder> {}

@wrapMethod(BackpackDataView)
public final func SetSortMode(mode: ItemSortMode) -> Void {
  if VuiMod.Get().SectionArmorRaritySort {
    super.m_itemSortMode = mode; /* VuiMod */
    wrappedMethod(mode);
  } else {
    wrappedMethod(mode);
  }
}

@wrapMethod(CraftingDataView)
public final func SetSortMode(mode: ItemSortMode) -> Void {
  if VuiMod.Get().SectionArmorRaritySort {
    super.m_itemSortMode = mode; /* VuiMod */
    wrappedMethod(mode);
  } else {
    wrappedMethod(mode);
  }
}

@wrapMethod(CyberwareDataView)
public final func SetSortMode(mode: ItemSortMode) -> Void {
  if VuiMod.Get().SectionArmorRaritySort {
    super.m_itemSortMode = mode; /* VuiMod */
    wrappedMethod(mode);
  } else {
    wrappedMethod(mode);
  }
}

@wrapMethod(ItemModeGridView)
public final func SetSortMode(mode: ItemSortMode) -> Void {
  if VuiMod.Get().SectionArmorRaritySort {
    super.m_itemSortMode = mode; /* VuiMod */
    wrappedMethod(mode);
  } else {
    wrappedMethod(mode);
  }
}

@wrapMethod(BackpackDataView)
public final func BindUIScriptableSystem(uiScriptableSystem: wref<UIScriptableSystem>) -> Void {
  if VuiMod.Get().SectionArmorRaritySort {
    super.m_uiScriptableSystem = uiScriptableSystem; /* VuiMod */
    wrappedMethod(uiScriptableSystem);
  } else {
    wrappedMethod(uiScriptableSystem);
  }
}

@wrapMethod(CraftingDataView)
public final func BindUIScriptableSystem(uiScriptableSystem: wref<UIScriptableSystem>) -> Void {
  if VuiMod.Get().SectionArmorRaritySort {
    super.m_uiScriptableSystem = uiScriptableSystem; /* VuiMod */
    wrappedMethod(uiScriptableSystem);
  } else {
    wrappedMethod(uiScriptableSystem);
  }
}

@wrapMethod(CyberwareDataView)
public final func BindUIScriptableSystem(uiScriptableSystem: wref<UIScriptableSystem>) -> Void {
  if VuiMod.Get().SectionArmorRaritySort {
    super.m_uiScriptableSystem = uiScriptableSystem; /* VuiMod */
    wrappedMethod(uiScriptableSystem);
  } else {
    wrappedMethod(uiScriptableSystem);
  }
}

@wrapMethod(ItemModeGridView)
public final func BindUIScriptableSystem(uiScriptableSystem: wref<UIScriptableSystem>) -> Void {
  if VuiMod.Get().SectionArmorRaritySort {
    super.m_uiScriptableSystem = uiScriptableSystem; /* VuiMod */
    wrappedMethod(uiScriptableSystem);
  } else {
    wrappedMethod(uiScriptableSystem);
  }
}

@wrapMethod(SortingDropdownData)
public final static func GetDefaultDropdownOptions() -> array<ref<DropdownItemData>> {
  if VuiMod.Get().SectionArmorRaritySort {
    return VuiMod.Get().BuildSortOptions(); /* VuiMod */
  } else {
    return wrappedMethod();
  }
}

@wrapMethod(SortingDropdownData)
public final static func GetItemChooserWeaponDropdownOptions() -> array<ref<DropdownItemData>> {
  if VuiMod.Get().SectionArmorRaritySort {
    return VuiMod.Get().BuildSortOptions(); /* VuiMod */
  } else {
    return wrappedMethod();
  }
}

@addField(ItemCompareBuilder)
public let itemData1: InventoryItemData;

@addField(ItemCompareBuilder)
public let itemData2: InventoryItemData;

@wrapMethod(ItemCompareBuilder)
public final func PriceAsc() -> ref<ItemCompareBuilder> {
  if VuiMod.Get().SectionArmorRaritySort && VuiMod.Get().OptionTrueSorting {
    /* VuiMod Start */
    let itemPrices: array<Int32> = VuiMod.Get().FetchItemPrices(this);
    this.m_compareBuilder.IntAsc(itemPrices[0], itemPrices[1]);
    return this;
    /* VuiMod End */
  } else {
    return wrappedMethod();
  }
}

@wrapMethod(ItemCompareBuilder)
public final func PriceDesc() -> ref<ItemCompareBuilder> {
  if VuiMod.Get().SectionArmorRaritySort && VuiMod.Get().OptionTrueSorting {
    /* VuiMod Start */
    let itemPrices: array<Int32> = VuiMod.Get().FetchItemPrices(this);
    this.m_compareBuilder.IntDesc(itemPrices[0], itemPrices[1]);
    return this;
    /* VuiMod End */
  } else {
    return wrappedMethod();
  }
}

@wrapMethod(BackpackDataView)
public func SortItem(left: ref<IScriptable>, right: ref<IScriptable>) -> Bool {
  if VuiMod.Get().SectionArmorRaritySort {
    /* VuiMod Start */
    let dataWrapperList: array<ref<InventoryItemDataWrapper>> = VuiMod.Get().BuildDataWrapperList(this, left, right);
    return VuiMod.Get().SortItem(this, dataWrapperList);
    /* VuiMod End */
  } else {
    return wrappedMethod(left, right);
  }
}

@wrapMethod(ItemModeGridView)
public func SortItem(left: ref<IScriptable>, right: ref<IScriptable>) -> Bool {
 if VuiMod.Get().SectionArmorRaritySort {
    /* VuiMod Start */
    let dataWrapperList: array<ref<InventoryItemDataWrapper>> = VuiMod.Get().BuildDataWrapperList(this, left, right);
    return VuiMod.Get().SortItem(this, dataWrapperList);
    /* VuiMod End */
  } else {
    return wrappedMethod(left, right);
  }
}

@wrapMethod(CraftingDataView)
public func SortItem(left: ref<IScriptable>, right: ref<IScriptable>) -> Bool {
  if VuiMod.Get().SectionArmorRaritySort {
    /* VuiMod Start */
    let dataWrapperList: array<ref<InventoryItemDataWrapper>> = VuiMod.Get().BuildDataWrapperList(this, left, right);
    return VuiMod.Get().SortItem(this, dataWrapperList);
    /* VuiMod End */
  } else {
    return wrappedMethod(left, right);
  }
}

@wrapMethod(CyberwareDataView)
public func SortItem(left: ref<IScriptable>, right: ref<IScriptable>) -> Bool {
  if VuiMod.Get().SectionArmorRaritySort {
    /* VuiMod Start */
    let dataWrapperList: array<ref<InventoryItemDataWrapper>> = VuiMod.Get().BuildDataWrapperList(this, left, right);
    return VuiMod.Get().SortItem(this, dataWrapperList);
    /* VuiMod End */
  } else {
    return wrappedMethod(left, right);
  }
}