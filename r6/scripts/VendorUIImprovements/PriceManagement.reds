@replaceMethod(MarketSystem)
public final static func GetBuyPrice(vendorObject: wref<GameObject>, itemID: ItemID) -> Int32 {
  let priceMultiplier: Float = 1.0;
  let isPlayer: Bool = vendorObject.IsA(n"PlayerPuppet");

  if !isPlayer {
    let marketSystem: ref<MarketSystem> = MarketSystem.GetInstance(vendorObject.GetGame());
    let vendor: ref<Vendor> = marketSystem.GetVendor(vendorObject);

    if IsDefined(vendor) {
      priceMultiplier = vendor.GetPriceMultiplier();
    }
  }

  return RPGManager.CalculateBuyPrice(vendorObject.GetGame(), vendorObject, itemID, priceMultiplier);
}

@wrapMethod(InventoryDataManagerV2)
private final func GetInventoryItemDataInternal(owner: wref<GameObject>, itemData: wref<gameItemData>, itemRecord: wref<Item_Record>) -> InventoryItemData {
  if VuiMod.Get().SectionPriceManagement {
    let inventoryItemData: InventoryItemData = wrappedMethod(owner, itemData, itemRecord);
    let isPlayer = owner.IsA(n"PlayerPuppet");

    if isPlayer {
      InventoryItemData.SetBuyPrice(inventoryItemData, InventoryItemData.GetPrice(inventoryItemData));
    } else {
      InventoryItemData.SetPrice(inventoryItemData, InventoryItemData.GetBuyPrice(inventoryItemData));
    }

    return inventoryItemData;
  } else {
    return wrappedMethod(owner, itemData, itemRecord);
  }
}