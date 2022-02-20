module VendorUIImprovements.UIFixes

@wrapMethod(gameuiInventoryGameController)
private final func GetEquipmentAreaPaperdollLocation(equipmentArea: gamedataEquipmentArea) -> PaperdollPositionAnimation {
  if VuiMod.Get().OptionDropdownPositionFix {
    switch equipmentArea {
      /* VuiMod Start */
      case gamedataEquipmentArea.AbilityCW:
      case gamedataEquipmentArea.CardiovascularSystemCW:
      case gamedataEquipmentArea.EyesCW:
      case gamedataEquipmentArea.FrontalCortexCW:
      case gamedataEquipmentArea.ImmuneSystemCW:
      case gamedataEquipmentArea.IntegumentarySystemCW:
      case gamedataEquipmentArea.LegsCW:
      case gamedataEquipmentArea.MusculoskeletalSystemCW:
      case gamedataEquipmentArea.NervousSystemCW:
      /* VuiMod End */
      case gamedataEquipmentArea.Weapon:
      case gamedataEquipmentArea.ArmsCW:
      case gamedataEquipmentArea.HandsCW:
      case gamedataEquipmentArea.SystemReplacementCW:
        return PaperdollPositionAnimation.Right;
      case gamedataEquipmentArea.OuterChest:
      case gamedataEquipmentArea.InnerChest:
      case gamedataEquipmentArea.Face:
      case gamedataEquipmentArea.Head:
        return PaperdollPositionAnimation.Left;
      case gamedataEquipmentArea.Outfit:
      case gamedataEquipmentArea.Feet:
      case gamedataEquipmentArea.Legs:
      case gamedataEquipmentArea.Consumable:
      case gamedataEquipmentArea.Gadget:
      case gamedataEquipmentArea.QuickSlot:
        return PaperdollPositionAnimation.LeftFullBody;
    };

    return PaperdollPositionAnimation.Center;
  } else {
    return wrappedMethod(equipmentArea);
  }
}

@wrapMethod(InventoryItemModeLogicController)
private final func IsEquipmentAreaClothing(equipmentArea: gamedataEquipmentArea) -> Bool {
  if VuiMod.Get().OptionInventoryFilterFix {
    return Equals(equipmentArea, gamedataEquipmentArea.Head) || Equals(equipmentArea, gamedataEquipmentArea.Face) || Equals(equipmentArea, gamedataEquipmentArea.OuterChest) || Equals(equipmentArea, gamedataEquipmentArea.InnerChest) || Equals(equipmentArea, gamedataEquipmentArea.Legs) || Equals(equipmentArea, gamedataEquipmentArea.Feet) || Equals(equipmentArea, gamedataEquipmentArea.Outfit);
  } else {
    return wrappedMethod(equipmentArea);
  }
}

@wrapMethod(InventoryItemModeLogicController)
protected cb func OnItemChooserItemChanged(e: ref<ItemChooserItemChanged>) -> Bool {
  if VuiMod.Get().OptionInventoryFilterFix {
    let itemsToSkip: array<ItemID>;
    let itemViewMode: ItemViewModes = ItemViewModes.Mod;

    if !TDBID.IsValid(e.slotID) {
      itemViewMode = ItemViewModes.Item;
    };

    if Equals(e.itemEquipmentArea, gamedataEquipmentArea.Consumable) || Equals(e.itemEquipmentArea, gamedataEquipmentArea.QuickSlot) {
      if Equals(e.itemEquipmentArea, gamedataEquipmentArea.Consumable) {
        this.m_currentHotkey = EHotkey.DPAD_UP;
      } else {
        if Equals(e.itemEquipmentArea, gamedataEquipmentArea.QuickSlot) {
          this.m_currentHotkey = EHotkey.RB;
        };
      };

      ArrayPush(itemsToSkip, this.itemChooser.GetSelectedItem().GetItemID());

      this.SetEquipmentArea(e.itemEquipmentArea);
      this.UpdateAvailableHotykeyItems(this.m_currentHotkey, itemsToSkip);

      this.SelectFilterButton(ItemFilterCategory.AllItems); /* VuiMod */
    } else {
      this.m_currentHotkey = EHotkey.INVALID;

      this.SetEquipmentArea(e.itemEquipmentArea);
      this.RefreshAvailableItems(itemViewMode);
    };

    (inkWidgetRef.GetController(this.m_itemGridScrollControllerWidget) as inkScrollController).SetScrollPosition(0.00);
  } else {
    return wrappedMethod(e);
  }
}