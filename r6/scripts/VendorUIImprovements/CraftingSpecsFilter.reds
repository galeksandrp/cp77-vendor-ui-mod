module VendorUIImprovements.CraftingSpecsFilter

@wrapMethod(ItemFilters)
public final static func GetLabelKey(filterType: ItemFilterType) -> CName {
  if VuiMod.Get().SectionCraftingSpecsFilter {
    switch filterType {
      case ItemFilterType.All:
        return n"UI-Filters-AllItems";
      case ItemFilterType.Weapons:
        return n"UI-Filters-Weapons";
      case ItemFilterType.Clothes:
        return n"UI-Filters-Clothes";
      case ItemFilterType.Consumables:
        return n"UI-Filters-Consumables";
      case ItemFilterType.Cyberware:
        return StringToName(VuiMod.Get().CraftingSpecsLocKey); /* VuiMod */
      case ItemFilterType.Attachments:
        return n"UI-Filters-Attachments";
      case ItemFilterType.Quest:
        return n"UI-Filters-QuestItems";
      case ItemFilterType.Buyback:
        return n"UI-Filters-Buyback";
      case ItemFilterType.LightWeapons:
        return n"UI-Filters-LightWeapons";
      case ItemFilterType.HeavyWeapons:
        return n"UI-Filters-HeavyWeapons";
      case ItemFilterType.MeleeWeapons:
        return n"UI-Filters-MeleeWeapons";
      case ItemFilterType.Hacks:
        return n"UI-Filters-Hacks";
    };

    return n"UI-Filters-AllItems";
  } else {
    return wrappedMethod(filterType);
  }
}

@wrapMethod(ItemFilters)
public final static func GetIcon(filterType: ItemFilterType) -> String {
  if VuiMod.Get().SectionCraftingSpecsFilter {
    switch filterType {
      case ItemFilterType.All:
        return "UIIcon.Filter_AllItems";
      case ItemFilterType.Weapons:
        return "UIIcon.Filter_Weapons";
      case ItemFilterType.Clothes:
        return "UIIcon.Filter_Clothes";
      case ItemFilterType.Consumables:
        return "UIIcon.Filter_Consumables";
      case ItemFilterType.Cyberware:
        return "UIIcon.LootingShadow_Material"; /* VuiMod */
      case ItemFilterType.Attachments:
        return "UIIcon.Filter_Attachments";
      case ItemFilterType.Quest:
        return "UIIcon.Filter_QuestItems";
      case ItemFilterType.Buyback:
        return "UIIcon.Filter_Buyback";
      case ItemFilterType.LightWeapons:
        return "UIIcon.Filter_LightWeapons";
      case ItemFilterType.HeavyWeapons:
        return "UIIcon.Filter_HeavyWeapons";
      case ItemFilterType.MeleeWeapons:
        return "UIIcon.Filter_MeleeWeapons";
      case ItemFilterType.Hacks:
        return "UIIcon.Filter_Hacks";
    };

    return "UIIcon.Filter_AllItems";
  } else {
    return wrappedMethod(filterType);
  }
}

@wrapMethod(ItemFilterCategories)
public final static func GetLabelKey(filterType: ItemFilterCategory) -> CName {
  if VuiMod.Get().SectionCraftingSpecsFilter {
    switch filterType {
      case ItemFilterCategory.RangedWeapons:
        return n"UI-Filters-RangedWeapons";
      case ItemFilterCategory.MeleeWeapons:
        return n"UI-Filters-MeleeWeapons";
      case ItemFilterCategory.Clothes:
        return n"UI-Filters-Clothes";
      case ItemFilterCategory.Consumables:
        return n"UI-Filters-Consumables";
      case ItemFilterCategory.Grenades:
        return n"UI-Filters-Grenades";
      case ItemFilterCategory.SoftwareMods:
        return n"UI-Filters-Mods";
      case ItemFilterCategory.Attachments:
        return n"UI-Filters-Attachments";
      case ItemFilterCategory.Programs:
        return n"UI-Filters-Hacks";
      case ItemFilterCategory.Cyberware:
        return StringToName(VuiMod.Get().CraftingSpecsLocKey); /* VuiMod */
      case ItemFilterCategory.Junk:
        return n"UI-Filters-Junk";
      case ItemFilterCategory.Quest:
        return n"UI-Filters-QuestItems";
      case ItemFilterCategory.Buyback:
        return n"UI-Filters-Buyback";
      case ItemFilterCategory.AllItems:
        return n"UI-Filters-AllItems";
    };

    return n"UI-Filters-AllItems";
  } else {
    return wrappedMethod(filterType);
  }
}

@wrapMethod(ItemFilterCategories)
public final static func GetIcon(filterType: ItemFilterCategory) -> String {
  if VuiMod.Get().SectionCraftingSpecsFilter {
    switch filterType {
      case ItemFilterCategory.RangedWeapons:
        return "UIIcon.Filter_RangedWeapons";
      case ItemFilterCategory.MeleeWeapons:
        return "UIIcon.Filter_MeleeWeapons";
      case ItemFilterCategory.Clothes:
        return "UIIcon.Filter_Clothes";
      case ItemFilterCategory.Consumables:
        return "UIIcon.Filter_Consumables";
      case ItemFilterCategory.Grenades:
        return "UIIcon.Filter_Grenades";
      case ItemFilterCategory.SoftwareMods:
        return "UIIcon.Filter_SoftwareMod";
      case ItemFilterCategory.Attachments:
        return "UIIcon.Filter_Attachments";
      case ItemFilterCategory.Programs:
        return "UIIcon.Filter_Hacks";
      case ItemFilterCategory.Cyberware:
        return "UIIcon.LootingShadow_Material"; /* VuiMod */
      case ItemFilterCategory.Junk:
        return "UIIcon.Filter_Junk";
      case ItemFilterCategory.Quest:
        return "UIIcon.Filter_QuestItems";
      case ItemFilterCategory.Buyback:
        return "UIIcon.Filter_Buyback";
      case ItemFilterCategory.AllItems:
        return "UIIcon.Filter_AllItems";
    };

    return "UIIcon.Filter_AllItems";
  } else {
    return wrappedMethod(filterType);
  }
}

@wrapMethod(ItemCategoryFliter)
public final static func IsOfCategoryType(filter: ItemFilterCategory, data: wref<gameItemData>) -> Bool {
  if VuiMod.Get().SectionCraftingSpecsFilter {
    if !IsDefined(data) {
      return false;
    };

    switch filter {
      case ItemFilterCategory.RangedWeapons:
        return data.HasTag(WeaponObject.GetRangedWeaponTag());
      case ItemFilterCategory.MeleeWeapons:
        return data.HasTag(WeaponObject.GetMeleeWeaponTag());
      case ItemFilterCategory.Clothes:
        return data.HasTag(n"Clothing");
      case ItemFilterCategory.Consumables:
        return data.HasTag(n"Consumable");
      case ItemFilterCategory.Grenades:
        return data.HasTag(n"Grenade");
      case ItemFilterCategory.Attachments:
        return (data.HasTag(n"itemPart") && !data.HasTag(n"SoftwareShard")) || data.HasTag(n"Cyberware") || data.HasTag(n"Fragment"); /* VuiMod */
      case ItemFilterCategory.Programs:
        return data.HasTag(n"SoftwareShard");
      case ItemFilterCategory.Cyberware:
        return data.HasTag(n"Recipe"); /* VuiMod */
      case ItemFilterCategory.Quest:
        return data.HasTag(n"Quest");
      case ItemFilterCategory.Junk:
        return data.HasTag(n"Junk");
      case ItemFilterCategory.AllItems:
        return true;
    };

    return false;
  } else {
    return wrappedMethod(filter, data);
  }
}

@wrapMethod(CraftingDataView)
public func FilterItem(item: ref<IScriptable>) -> Bool {
  if VuiMod.Get().SectionCraftingSpecsFilter {
    let itemRecord: ref<Item_Record>;
    let itemData: ref<ItemCraftingData> = item as ItemCraftingData;
    let recipeData: ref<RecipeData> = item as RecipeData;

    if IsDefined(itemData) {
      itemRecord = TweakDBInterface.GetItemRecord(ItemID.GetTDBID(InventoryItemData.GetID(itemData.inventoryItem)));
    } else {
      if IsDefined(recipeData) {
        itemRecord = recipeData.id;
      };
    };

    switch this.m_itemFilterType {
      case ItemFilterCategory.RangedWeapons:
        return itemRecord.TagsContains(WeaponObject.GetRangedWeaponTag());
      case ItemFilterCategory.MeleeWeapons:
        return itemRecord.TagsContains(WeaponObject.GetMeleeWeaponTag());
      case ItemFilterCategory.Clothes:
        return itemRecord.TagsContains(n"Clothing");
      case ItemFilterCategory.Consumables:
        return itemRecord.TagsContains(n"Consumable") || itemRecord.TagsContains(n"Ammo");
      case ItemFilterCategory.Grenades:
        return itemRecord.TagsContains(n"Grenade");
      case ItemFilterCategory.Attachments:
        return (itemRecord.TagsContains(n"itemPart") && !itemRecord.TagsContains(n"SoftwareShard")) || itemRecord.TagsContains(n"Cyberware") || itemRecord.TagsContains(n"Fragment"); /* VuiMod */
      case ItemFilterCategory.Programs:
        return itemRecord.TagsContains(n"SoftwareShard");
      /* case ItemFilterCategory.Cyberware:
        return itemRecord.TagsContains(n"Cyberware") || itemRecord.TagsContains(n"Fragment"); */ /* VuiMod */
      case ItemFilterCategory.AllItems:
        return true;
    };

    return true;
  } else {
    return wrappedMethod(item);
  }
}

@wrapMethod(CraftingLogicController)
protected func SetupFilters() -> Void {
  if VuiMod.Get().SectionCraftingSpecsFilter {
    ArrayPush(this.m_filters, EnumInt(ItemFilterCategory.AllCount));
    ArrayPush(this.m_filters, EnumInt(ItemFilterCategory.RangedWeapons));
    ArrayPush(this.m_filters, EnumInt(ItemFilterCategory.MeleeWeapons));
    ArrayPush(this.m_filters, EnumInt(ItemFilterCategory.Clothes));
    ArrayPush(this.m_filters, EnumInt(ItemFilterCategory.Consumables));
    ArrayPush(this.m_filters, EnumInt(ItemFilterCategory.Grenades));
    ArrayPush(this.m_filters, EnumInt(ItemFilterCategory.Attachments));
    /* ArrayPush(this.m_filters, EnumInt(ItemFilterCategory.Cyberware)); */ /* VuiMod */
    ArrayPush(this.m_filters, EnumInt(ItemFilterCategory.Programs));

    super.SetupFilters();
  } else {
    wrappedMethod();
  }
}