module VendorUIImprovements.VendorStockAvailability

@wrapMethod(Vendor)
protected func ShouldRegenerateStock() -> Bool {
  if VuiMod.Get().SectionVendorStock {
    let currentTime: Float;
    let regenTime: Float = VuiMod.Get().CalculateDaysToRestock(); /* VuiMod */

    if this.m_lastInteractionTime != 0.00 {
      currentTime = GameInstance.GetTimeSystem(this.m_gameInstance).GetGameTimeStamp();
      return currentTime - this.m_lastInteractionTime > regenTime;
    };

    return false;
  } else {
    return wrappedMethod();
  }
}

@wrapMethod(Vendor)
private final func CreateStacksFromVendorItem(vendorItem: wref<VendorItem_Record>, player: ref<PlayerPuppet>) -> array<SItemStack> {
  if VuiMod.Get().SectionVendorStock {
    let i: Int32;
    let isQuest: Bool;
    let itemStack: SItemStack;
    let outputStacks: array<SItemStack>;
    let quantity: Int32;
    let quantityMods: array<wref<StatModifier_Record>>;
    let randomPowerLevel: Float;
    let itemRecord: ref<Item_Record> = TweakDBInterface.GetItemRecord(vendorItem.Item().GetID());
    let itemID: ItemID = ItemID.FromTDBID(vendorItem.Item().GetID());

    vendorItem.Quantity(quantityMods);
    quantity = 1;

    if ArraySize(quantityMods) > 0 && IsDefined(this.m_vendorObject) {
      quantity = VuiMod.Get().GetItemStackQuantity(this, player, quantityMods); /* VuiMod */
    };

    if quantity > 0 {
      if !itemRecord.IsSingleInstance() {
        isQuest = itemRecord.TagsContains(n"Quest");

        i = 0;
        while i < quantity {
          itemStack.vendorItemID = vendorItem.GetID();

          if !isQuest {
            randomPowerLevel = MathHelper.RandFromNormalDist(GameInstance.GetStatsSystem(this.m_gameInstance).GetStatValue(Cast<StatsObjectID>(GetPlayer(this.m_gameInstance).GetEntityID()), gamedataStatType.PowerLevel), 1.00);
            itemStack.powerLevel = RoundF(randomPowerLevel * 100.00);
          };

          if itemRecord.UsesVariants() {
            itemStack.itemID = ItemID.FromTDBID(vendorItem.Item().GetID());
          } else {
            itemStack.itemID = itemID;
          };

          ArrayPush(outputStacks, itemStack);

          i += 1;
        };
      } else {
        itemStack.vendorItemID = vendorItem.GetID();
        itemStack.quantity = quantity;
        itemStack.itemID = itemID;

        ArrayPush(outputStacks, itemStack);
      };
    };

    ArrayClear(quantityMods);

    return outputStacks;
  } else {
    return wrappedMethod(vendorItem, player);
  }
}

@wrapMethod(Vendor)
private final func InitializeStock() -> Void {
  if VuiMod.Get().SectionVendorStock {
    let i: Int32;
    let itemPool: array<wref<VendorItem_Record>>;
    let itemStacks: array<SItemStack>;
    let j: Int32;
    let player: ref<PlayerPuppet> = GetPlayer(this.m_gameInstance);
    /* VuiMod Start */
    let continueLoop: Bool;
    let useAlternativeCyberware: Bool;
    /* VuiMod End */

    this.m_stockInit = true;
    useAlternativeCyberware = GameInstance.GetTransactionSystem(this.m_gameInstance).UseAlternativeCyberware(); /* VuiMod */

    if useAlternativeCyberware && this.m_vendorRecord.GetItemStock2Count() > 0 { /* VuiMod */
      this.m_vendorRecord.ItemStock2(itemPool);
    } else {
      this.m_vendorRecord.ItemStock(itemPool);
    };

    /* VuiMod Start */
    VuiMod.Get().CalculateVendorMoney(this, player, itemPool, this.m_stock);
    continueLoop = ArraySize(this.m_stock) < VuiMod.Get().CalculateStockAvailability(this, useAlternativeCyberware);
    /* VuiMod End */

    i = 0;
    while i < ArraySize(itemPool) && continueLoop { /* VuiMod */
      itemStacks = this.CreateStacksFromVendorItem(itemPool[i], player);

      j = 0;
      while j < ArraySize(itemStacks) {
        ArrayPush(this.m_stock, itemStacks[j]);

        continueLoop = ArraySize(this.m_stock) < VuiMod.Get().CalculateStockAvailability(this, useAlternativeCyberware); /* VuiMod */

        j += 1;
      };

      i += 1;
    };
  } else {
    wrappedMethod();
  }
}

@wrapMethod(Vendor)
private final func RegenerateStock() -> Void {
  if VuiMod.Get().SectionVendorStock {
    let circularIndex: Int32;
    let continueLoop: Bool;
    let dynamicStock: array<SItemStack>;
    let i: Int32;
    let itemPool: array<wref<VendorItem_Record>>;
    let itemPoolIndex: Int32;
    let itemPoolSize: Int32;
    let itemStacks: array<SItemStack>;
    let j: Int32;
    let newStock: array<SItemStack>;
    let useAlternativeCyberware: Bool;
    let player: ref<PlayerPuppet> = GetPlayer(this.m_gameInstance);

    this.LazyInitStock();

    i = 0;
    while i < ArraySize(this.m_stock) {
      if !this.ShouldRegenerateItem(ItemID.GetTDBID(this.m_stock[i].itemID)) {
        ArrayPush(newStock, this.m_stock[i]);
      };
      i += 1;
    };

    useAlternativeCyberware = GameInstance.GetTransactionSystem(this.m_gameInstance).UseAlternativeCyberware();
    dynamicStock = this.CreateDynamicStockFromPlayerProgression(GetPlayer(this.m_gameInstance));

    i = 0;
    while i < ArraySize(dynamicStock) && ArraySize(newStock) < VuiMod.Get().CalculateStockAvailability(this, useAlternativeCyberware) { /* VuiMod */
      ArrayPush(newStock, dynamicStock[i]);
      i += 1;
    };

    if useAlternativeCyberware && this.m_vendorRecord.GetItemStock2Count() > 0 {
      this.m_vendorRecord.ItemStock2(itemPool);
    } else {
      this.m_vendorRecord.ItemStock(itemPool);
    };

    VuiMod.Get().CalculateVendorMoney(this, player, itemPool, newStock); /* VuiMod */

    i = ArraySize(itemPool) - 1;
    while i >= 0 {
      if this.AlwaysInStock(itemPool[i].Item().GetID()) {
        itemStacks = this.CreateStacksFromVendorItem(itemPool[i], player);

        j = 0;
        while j < ArraySize(itemStacks) {
          ArrayPush(newStock, itemStacks[j]);
          j += 1;
        };

        ArrayErase(itemPool, i);
      };

      i -= 1;
    };

    itemPoolSize = ArraySize(itemPool);

    if itemPoolSize > 0 {
      continueLoop = ArraySize(newStock) < VuiMod.Get().CalculateStockAvailability(this, useAlternativeCyberware); /* VuiMod */
      circularIndex = RandRange(0, itemPoolSize);

      i = 0;
      while i < itemPoolSize && continueLoop {
        itemPoolIndex = circularIndex % itemPoolSize;

        if this.ShouldRegenerateItem(itemPool[itemPoolIndex].Item().GetID()) {
          itemStacks = this.CreateStacksFromVendorItem(itemPool[itemPoolIndex], player);

          j = 0;
          while j < ArraySize(itemStacks) && continueLoop {
            ArrayPush(newStock, itemStacks[j]);

            continueLoop = ArraySize(newStock) < VuiMod.Get().CalculateStockAvailability(this, useAlternativeCyberware); /* VuiMod */
            j += 1;
          };
        };

        circularIndex += 1;
        i += 1;
      };
    };

    this.m_stock = newStock;
  } else {
    wrappedMethod();
  }
}