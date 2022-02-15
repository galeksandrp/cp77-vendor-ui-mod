module VendorUIImprovements.UIFixes

@addField(InventoryItemModeLogicController)
public let m_confirmationPopupToken: ref<inkGameNotificationToken>;

@addMethod(InventoryItemModeLogicController)
protected cb func OnIconicDisassemblePopupClosed(data: ref<inkGameNotificationData>) -> Bool {
  this.m_confirmationPopupToken = null;
  let resultData: ref<VendorConfirmationPopupCloseData> = data as VendorConfirmationPopupCloseData;
  if resultData.confirm {
    ItemActionsHelper.DisassembleItem(this.m_player, InventoryItemData.GetID(resultData.itemData));
    this.PlaySound(n"Item", n"OnDisassemble");
  };
  this.m_buttonHintsController.Show();
}

@wrapMethod(InventoryItemModeLogicController)
private final func HandleItemHold(itemData: InventoryItemData, actionName: ref<inkActionName>) -> Void {
  if VuiMod.Get().OptionIconicNotificationFix {
    if actionName.IsAction(n"disassemble_item") && !this.m_isE3Demo && RPGManager.CanItemBeDisassembled(this.m_player.GetGame(), InventoryItemData.GetGameItemData(itemData)) {
      if InventoryItemData.GetQuantity(itemData) > 1 {
        this.OpenQuantityPicker(itemData, QuantityPickerActionType.Disassembly);
      } else {
        /* VuiMod Start */
        if RPGManager.IsItemIconic(InventoryItemData.GetGameItemData(itemData)) {
          VuiMod.Get().OpenIconicDisassemblePopup(this, itemData);
        /* VuiMod End */
        } else {
          ItemActionsHelper.DisassembleItem(this.m_player, InventoryItemData.GetID(itemData));
          this.PlaySound(n"Item", n"OnDisassemble");
        };
      };
    } else {
      if actionName.IsAction(n"use_item") {
        if !InventoryGPRestrictionHelper.CanUse(itemData, this.m_player) {
          this.ShowNotification(this.m_player.GetGame(), this.DetermineUIMenuNotificationType());
          return ;
        };
        ItemActionsHelper.PerformItemAction(this.m_player, InventoryItemData.GetID(itemData));
        this.m_InventoryManager.MarkToRebuild();
      };
    };
  } else {
    wrappedMethod(itemData, actionName);
  }
}

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
private final func SetupFiltersToCheck(equipmentArea: gamedataEquipmentArea) -> Void {
  if VuiMod.Get().OptionInventoryFilterFix {
    this.m_filterManager.Clear(true);

    if Equals(equipmentArea, gamedataEquipmentArea.Weapon) {
      this.m_filterManager.AddFilterToCheck(ItemFilterCategory.RangedWeapons);
      this.m_filterManager.AddFilterToCheck(ItemFilterCategory.MeleeWeapons);
      this.m_filterManager.AddFilterToCheck(ItemFilterCategory.SoftwareMods);
      this.m_filterManager.AddFilterToCheck(ItemFilterCategory.Attachments);
    } else {
      if this.IsEquipmentAreaClothing(equipmentArea) {
        this.m_filterManager.AddFilterToCheck(ItemFilterCategory.Clothes);
        this.m_filterManager.AddFilterToCheck(ItemFilterCategory.SoftwareMods);
        this.m_filterManager.AddFilterToCheck(ItemFilterCategory.Attachments);
      } else {
        /* VuiMod Start */
        if Equals(equipmentArea, gamedataEquipmentArea.QuickSlot) || Equals(equipmentArea, gamedataEquipmentArea.Consumable) {
          this.m_filterManager.AddFilterToCheck(ItemFilterCategory.AllItems);
        }
        /* VuiMod End */
      }
    }
  } else {
    wrappedMethod(equipmentArea);
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

      this.SetEquipmentArea(e.itemEquipmentArea); /* VuiMod */
      this.UpdateAvailableHotykeyItems(this.m_currentHotkey, itemsToSkip);

      /* VuiMod Start */
      this.CreateFilterButtons(this.m_itemGridContainerController.GetFiltersGrid());
      this.SelectFilterButton(ItemFilterCategory.AllItems);
      /* VuiMod End */
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

@wrapMethod(InventoryItemModeLogicController)
private final func UpdateAvailableItems(viewMode: ItemViewModes, equipmentAreas: array<gamedataEquipmentArea>) -> Void {
  if VuiMod.Get().OptionInventoryFilterFix {
    let attachments: array<InventoryItemAttachments>;
    let attachmentsToCheck: array<TweakDBID>;
    let availableItems: array<InventoryItemData>;
    let i: Int32;
    let modifiedItemData: wref<gameItemData>;
    let targetFilter: Int32;
    let isWeapon: Bool = this.IsEquipmentAreaWeapon(equipmentAreas);
    let isClothing: Bool = this.IsEquipmentAreaClothing(equipmentAreas);

    if isWeapon || isClothing {
      this.m_InventoryManager.GetPlayerInventoryDataRef(equipmentAreas, true, this.m_itemDropQueue, availableItems);
      attachments = InventoryItemData.GetAttachments(this.itemChooser.GetModifiedItemData());

      if TDBID.IsValid(this.itemChooser.GetSelectedSlotID()) {
        ArrayPush(attachmentsToCheck, this.itemChooser.GetSelectedSlotID());
      } else {
        i = 0;
        while i < ArraySize(attachments) {
          if Equals(attachments[i].SlotType, InventoryItemAttachmentType.Generic) {
            ArrayPush(attachmentsToCheck, attachments[i].SlotID);
          };
          i += 1;
        };
      };

      this.m_InventoryManager.GetPlayerInventoryPartsForItemRef(this.itemChooser.GetModifiedItemID(), attachmentsToCheck, availableItems);
    } else {
      if Equals(viewMode, ItemViewModes.Mod) {
        availableItems = this.m_InventoryManager.GetPlayerInventoryPartsForItem((this.itemChooser as InventoryCyberwareItemChooser).GetModifiedItemID(), this.itemChooser.GetSelectedItem().GetSlotID());
      } else {
        this.m_InventoryManager.GetPlayerInventoryDataRef(equipmentAreas, true, this.m_itemDropQueue, availableItems);
      };
    };

    this.UpdateAvailableItemsGrid(availableItems);
    this.CreateFilterButtons(this.m_itemGridContainerController.GetFiltersGrid());

    if (isWeapon || isClothing) && this.m_lastSelectedDisplay != this.itemChooser.GetSelectedItem() {
      this.m_lastSelectedDisplay = this.itemChooser.GetSelectedItem();
      if Equals(viewMode, ItemViewModes.Mod) && this.GetFilterButtonIndex(ItemFilterCategory.Attachments) >= 0 {
        this.SelectFilterButton(ItemFilterCategory.Attachments);
      } else {
        targetFilter = 0;
        if isWeapon {
          modifiedItemData = InventoryItemData.GetGameItemData(this.itemChooser.GetModifiedItemData());
          if ItemCategoryFliter.IsOfCategoryType(ItemFilterCategory.RangedWeapons, modifiedItemData) {
            targetFilter = this.GetFilterButtonIndex(ItemFilterCategory.RangedWeapons);
          } else {
            if ItemCategoryFliter.IsOfCategoryType(ItemFilterCategory.MeleeWeapons, modifiedItemData) {
              targetFilter = this.GetFilterButtonIndex(ItemFilterCategory.MeleeWeapons);
            };
          };
        } else {
          /* VuiMod Start */
          if isClothing && this.GetFilterButtonIndex(ItemFilterCategory.Clothes) >= 0 {
            targetFilter = this.GetFilterButtonIndex(ItemFilterCategory.Clothes);
          }
          /* VuiMod End */
        };
        this.SelectFilterButtonByIndex(targetFilter);
      };
    };
  } else {
    wrappedMethod(viewMode, equipmentAreas);
  }
}

@wrapMethod(InventoryItemModeLogicController)
private final func HandleItemClick(itemData: InventoryItemData, actionName: ref<inkActionName>, opt displayContext: ItemDisplayContext) -> Void {
  if VuiMod.Get().OptionInventoryFilterFix {
    let isEquippedItemBlocked: Bool;
    let item: ItemModParams;
    if actionName.IsAction(n"drop_item") {
      if !InventoryItemData.IsEquipped(itemData) && RPGManager.CanItemBeDropped(this.m_player, InventoryItemData.GetGameItemData(itemData)) {
        if InventoryItemData.GetQuantity(itemData) > 1 {
          this.OpenQuantityPicker(itemData, QuantityPickerActionType.Drop);
        } else {
          item.itemID = InventoryItemData.GetID(itemData);
          item.quantity = 1;
          this.AddToDropQueue(item);
          this.RefreshAvailableItems();
          this.PlaySound(n"Item", n"OnDrop");
        };
      };
    } else {
      if NotEquals(displayContext, ItemDisplayContext.Attachment) && NotEquals(displayContext, ItemDisplayContext.GearPanel) && (actionName.IsAction(n"equip_item") || actionName.IsAction(n"click")) && !(InventoryItemData.IsEquipped(itemData) && Equals(this.m_currentHotkey, EHotkey.INVALID)) { /* VuiMod */
        isEquippedItemBlocked = InventoryItemData.GetGameItemData(this.itemChooser.GetModifiedItemData()).HasTag(n"UnequipBlocked");
        if !InventoryGPRestrictionHelper.CanEquip(itemData, this.m_player) || isEquippedItemBlocked {
          this.ShowNotification(this.m_player.GetGame(), this.DetermineUIMenuNotificationType());
          return;
        };
        this.EquipItem(itemData, this.itemChooser.GetSlotIndex());
        this.itemChooser.RefreshItems();
        this.RefreshAvailableItems();
        this.NotifyItemUpdate();
      };
    };
  } else {
    wrappedMethod(itemData, actionName, displayContext);
  }
}