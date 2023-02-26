module VendorUIImprovements.ArmorRaritySort

@addField(ScriptableDataView)
public let m_itemSortModeUtils: ItemSortMode;

@addMethod(ScriptableDataView)
public func PreSortingInjection(builder: ref<ItemCompareBuilder>) -> ref<ItemCompareBuilder> {}

@wrapMethod(BackpackDataView)
public final func SetSortMode(mode: ItemSortMode) -> Void {
  if VuiMod.Get().SectionArmorRaritySort {
    super.m_itemSortModeUtils = mode; /* VuiMod */
    wrappedMethod(mode);
  } else {
    wrappedMethod(mode);
  }
}

@wrapMethod(CraftingDataView)
public final func SetSortMode(mode: ItemSortMode) -> Void {
  if VuiMod.Get().SectionArmorRaritySort {
    super.m_itemSortModeUtils = mode; /* VuiMod */
    wrappedMethod(mode);
  } else {
    wrappedMethod(mode);
  }
}

@wrapMethod(CyberwareDataView)
public final func SetSortMode(mode: ItemSortMode) -> Void {
  if VuiMod.Get().SectionArmorRaritySort {
    super.m_itemSortModeUtils = mode; /* VuiMod */
    wrappedMethod(mode);
  } else {
    wrappedMethod(mode);
  }
}

@wrapMethod(ItemModeGridView)
public final func SetSortMode(mode: ItemSortMode) -> Void {
  if VuiMod.Get().SectionArmorRaritySort {
    super.m_itemSortModeUtils = mode; /* VuiMod */
    wrappedMethod(mode);
  } else {
    wrappedMethod(mode);
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
    return VuiMod.Get().DynamicPriceAsc(this); /* VuiMod */
  } else {
    return wrappedMethod();
  }
}

@wrapMethod(ItemCompareBuilder)
public final func PriceDesc() -> ref<ItemCompareBuilder> {
  if VuiMod.Get().SectionArmorRaritySort && VuiMod.Get().OptionTrueSorting {
    return VuiMod.Get().DynamicPriceDesc(this); /* VuiMod */
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
