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
public final func GetMaxItemStacksPerVendor() -> Int32 {
  if VuiMod.Get().SectionVendorStock {
    return VuiMod.Get().CalculateStockAvailability(this); /* VuiMod */
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
            randomPowerLevel = MathHelper.RandFromNormalDist(GameInstance.GetStatsSystem(this.m_gameInstance).GetStatValue(Cast(GetPlayer(this.m_gameInstance).GetEntityID()), gamedataStatType.PowerLevel), 1.00);
            itemStack.powerLevel = RoundF(randomPowerLevel * 100.00);
          };

          itemStack.itemID = itemID;

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
    let continueLoop: Bool; /* VuiMod */

    this.m_stockInit = true;
    this.m_vendorRecord.ItemStock(itemPool);

    /* VuiMod Start */
    VuiMod.Get().CalculateVendorMoney(this, player, itemPool, this.m_stock);
    continueLoop = ArraySize(this.m_stock) < this.GetMaxItemStacksPerVendor();
    /* VuiMod End */

    i = 0;
    while i < ArraySize(itemPool) && continueLoop { /* VuiMod */
      itemStacks = this.CreateStacksFromVendorItem(itemPool[i], player);

      j = 0;
      while j < ArraySize(itemStacks) && continueLoop { /* VuiMod */
        ArrayPush(this.m_stock, itemStacks[j]);

        continueLoop = ArraySize(this.m_stock) < this.GetMaxItemStacksPerVendor(); /* VuiMod */
        j += 1;
      };
      i += 1;
    };
  } else{
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
    let player: ref<PlayerPuppet> = GetPlayer(this.m_gameInstance);

    this.LazyInitStock();

    i = 0;
    while i < ArraySize(this.m_stock) {
      if !this.ShouldRegenerateItem(ItemID.GetTDBID(this.m_stock[i].itemID)) {
        ArrayPush(newStock, this.m_stock[i]);
      };
      i += 1;
    };

    dynamicStock = this.CreateDynamicStockFromPlayerProgression(GetPlayer(this.m_gameInstance));
    i = 0;
    while i < ArraySize(dynamicStock) && ArraySize(newStock) < this.GetMaxItemStacksPerVendor() {
      ArrayPush(newStock, dynamicStock[i]);
      i += 1;
    };

    this.m_vendorRecord.ItemStock(itemPool);

    VuiMod.Get().CalculateVendorMoney(this, player, itemPool, newStock); /* VuiMod */

    itemPoolSize = ArraySize(itemPool);
    continueLoop = ArraySize(newStock) < this.GetMaxItemStacksPerVendor();

    if itemPoolSize > 0 { /* VuiMod */
      circularIndex = RandRange(0, itemPoolSize);

      i = 0;
      while i < itemPoolSize && continueLoop {
        itemPoolIndex = circularIndex % itemPoolSize;

        if this.ShouldRegenerateItem(itemPool[itemPoolIndex].Item().GetID()) {
          itemStacks = this.CreateStacksFromVendorItem(itemPool[itemPoolIndex], player);

          j = 0;
          while j < ArraySize(itemStacks) && continueLoop {
            ArrayPush(newStock, itemStacks[j]);

            continueLoop = ArraySize(newStock) < this.GetMaxItemStacksPerVendor();
            j += 1;
          };
        };

        circularIndex += 1;
        i += 1;
      };

      this.m_stock = newStock;
    }
  } else {
    wrappedMethod();
  }
}

@wrapMethod(Vendor)
private final const func PlayerCanBuy(itemStack: script_ref<SItemStack>) -> Bool {
  if VuiMod.Get().SectionVendorStock && VuiMod.Get().OptionKnownRecipesHidden {
    let availablePrereq: wref<IPrereq_Record>;
    let filterTags: array<CName>;
    let i: Int32;
    let itemData: wref<gameItemData>;
    let viewPrereqs: array<wref<IPrereq_Record>>;
    let vendorItem: wref<VendorItem_Record> = TweakDBInterface.GetVendorItemRecord(Deref(itemStack).vendorItemID);

    vendorItem.GenerationPrereqs(viewPrereqs);

    if !VuiMod.Get().HasPlayerCraftingSpec(vendorItem) && RPGManager.CheckPrereqs(viewPrereqs, GetPlayer(this.m_gameInstance)) { /* VuiMod */
      filterTags = this.m_vendorRecord.VendorFilterTags();
      itemData = GameInstance.GetTransactionSystem(this.m_gameInstance).GetItemData(this.m_vendorObject, Deref(itemStack).itemID);
      availablePrereq = vendorItem.AvailabilityPrereq();
      Deref(itemStack).requirement = RPGManager.GetStockItemRequirement(vendorItem);

      if IsDefined(availablePrereq) {
        Deref(itemStack).isAvailable = RPGManager.CheckPrereq(availablePrereq, GetPlayer(this.m_gameInstance));
      };

      i = 0;
      while i < ArraySize(filterTags) {
        if IsDefined(itemData) && itemData.HasTag(filterTags[i]) {
          return false;
        };

        i += 1;
      };

      return true;
    };

    return false;
  } else {
    return wrappedMethod(itemStack);
  }
}