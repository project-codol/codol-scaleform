package codo.component.lobby
{
   import codo.common.CFunctionCommonContainer;
   import codo.common.CFunctionContainer;
   import codo.component.core.UIInteractiveComponent;
   import codo.component.filter.LoadoutFilter;
   import codo.component.loadout.LoadoutButton;
   import codo.component.loadout.LoadoutViewPanelBase;
   import codo.constants.BCEvent;
   import codo.constants.DataID;
   import codo.constants.MarketMenuData;
   import codo.cpp.IUiCppItemListView;
   import codo.cpp.UiCppItemListView;
   import codo.cpp.UiCppNewItems;
   import codo.cpp.UiCppView;
   import codo.event.ParaEvent;
   import codo.localization.Dict;
   import codo.localization.DictMarket;
   import codo.manager.DataManager;
   import codo.manager.EventManager;
   import codo.objects.BindDataHelper;
   import codo.objects.CustomObject;
   import codo.objects.ProductObj;
   import codo.objects.RoomMemberObj;
   import codo.utils.LocalizeUtil;
   import flash.display.MovieClip;
   import flash.events.KeyboardEvent;
   import flash.ui.Keyboard;
   
   public class LobbyGearSubPanel extends LoadoutViewPanelBase implements IUiCppItemListView
   {
      
      public static const TATTOO_INDEX:int = 0;
      
      public static const EMOTE_INDEX:int = 1;
      
      public static const HEADWEAR_INDEX:int = 2;
      
      public static const EYEWEAR_INDEX:int = 3;
      
      public static const JACKET_INDEX:int = 4;
      
      public static const VEST_INDEX:int = 5;
      
      public static const GLOVES_INDEX:int = 6;
      
      public static const PANTS_INDEX:int = 7;
      
      public static const OUTFIT_INDEX:int = 8;
      
      public static const GEAR_SLOT_NUM:int = 9;
      
      public static const AVATAR_INDEX:int = 10;
      
      public static const GEAR_LABEL_TEXT_WIDTH:int = 140;
      
      public static const WARNING_HEADER_TEXT_WIDTH:int = 400;
      
      public var myAvatarSlot:MovieClip;
      
      public var myGear:LobbyGearDisplay;
      
      public var myLoadoutFilter:LoadoutFilter;
      
      private var mBackCallback:Function;
      
      protected var mGearSlotSelectedCallback:Function;
      
      private var _currentMember:RoomMemberObj = null;
      
      private var m_bindLobbyCharacterData:BindDataHelper;
      
      public function LobbyGearSubPanel()
      {
         super();
      }
      
      public function getLobbyItemFooterButton(name:String) : LobbyItemFooterButton
      {
         return this.myGear[name] as LobbyItemFooterButton;
      }
      
      public function getLoadoutButton(name:String) : LoadoutButton
      {
         return this.myGear[name] as LoadoutButton;
      }
      
      override protected function onInit() : void
      {
         this.myGear.myGearTitle.text = LocalizeUtil.localize(Dict.WEAPONLOADOUT_GEAR);
         this.myGear.myGearSubtitle.text = LocalizeUtil.localize(Dict.LOADOUT_LOBBY_GEAR_INSTRUCTIONS);
         this.myGear.myGearSubtitle.width = WARNING_HEADER_TEXT_WIDTH;
         this.m_bindLobbyCharacterData = new BindDataHelper(DataID.LOBBY_CHARACTER_DATA,this.bind_onLobbyCharacterDataUpdated);
         for(var i:int = TATTOO_INDEX; i < GEAR_SLOT_NUM; i++)
         {
            this.myGear["GearLabel" + i].myLabel.width = GEAR_LABEL_TEXT_WIDTH;
            this.getLobbyItemFooterButton("myBuyButton" + i).setCallback(this.onBuyButtonPressed);
            this.getLoadoutButton("myGearSlot" + i).registerFocusEvent(this.onGearSlotFocused,this.getLoadoutButton("myGearSlot" + i));
            this.getLoadoutButton("myGearSlot" + i).registerClickEvent(this.onGearSlotSelected,i);
            this.getLoadoutButton("myGearSlot" + i).registerUnfocusEvent(this.onGearSlotUnfocused,this.getLoadoutButton("myGearSlot" + i));
         }
         this.getLobbyItemFooterButton("myBuyButton" + AVATAR_INDEX).setCallback(this.onBuyButtonPressed);
         this.myGear.loadoutButtons[TATTOO_INDEX].setBreadcrumb(UiCppNewItems.CRUMB_TATTOOS);
         this.myGear.loadoutButtons[EMOTE_INDEX].setBreadcrumb(UiCppNewItems.CRUMB_EMOTES);
         this.myGear.loadoutButtons[HEADWEAR_INDEX].setBreadcrumb(UiCppNewItems.CRUMB_HEADGEAR);
         this.myGear.loadoutButtons[EYEWEAR_INDEX].setBreadcrumb(UiCppNewItems.CRUMB_EYEWEAR);
         this.myGear.loadoutButtons[JACKET_INDEX].setBreadcrumb(UiCppNewItems.CRUMB_JACKETS);
         this.myGear.loadoutButtons[VEST_INDEX].setBreadcrumb(UiCppNewItems.CRUMB_VESTS);
         this.myGear.loadoutButtons[GLOVES_INDEX].setBreadcrumb(UiCppNewItems.CRUMB_GLOVES);
         this.myGear.loadoutButtons[PANTS_INDEX].setBreadcrumb(UiCppNewItems.CRUMB_PANTS);
         this.myGear.GearLabel0.myLabel.text = LocalizeUtil.localize(DictMarket.CATEGORY_TATTOO);
         this.myGear.GearLabel1.myLabel.text = LocalizeUtil.localize(DictMarket.ITEM_MENU_EMO);
         this.myGear.GearLabel2.myLabel.text = LocalizeUtil.localize(DictMarket.CATEGORY_HEADGEAR);
         this.myGear.GearLabel3.myLabel.text = LocalizeUtil.localize(DictMarket.CATEGORY_EYEWEAR);
         this.myGear.GearLabel4.myLabel.text = LocalizeUtil.localize(DictMarket.CATEGORY_JACKET);
         this.myGear.GearLabel5.myLabel.text = LocalizeUtil.localize(DictMarket.CATEGORY_VEST);
         this.myGear.GearLabel6.myLabel.text = LocalizeUtil.localize(DictMarket.CATEGORY_GLOVE);
         this.myGear.GearLabel7.myLabel.text = LocalizeUtil.localize(DictMarket.CATEGORY_PANTS);
         this.myGear.GearLabel8.myLabel.text = LocalizeUtil.localize(DictMarket.CATEGORY_OUTFIT);
         this.myGear.myAvatarSlot.myCategory.text = LocalizeUtil.localize(DictMarket.ITEM_MENU_AVATAR);
         this.myGear.myAvatarSlot.myName.width = WARNING_HEADER_TEXT_WIDTH;
         this.myLoadoutFilter.visible = false;
         this.myLoadoutFilter.GEAR_DATA = MarketMenuData.CATEGORY_LOBBY_GEAR;
      }
      
      override protected function makeUiCpp() : UiCppView
      {
         return new UiCppItemListView(this,null,null,this.myLoadoutFilter.getUiCpp());
      }
      
      override protected function enableData() : void
      {
         this.updateGearForMember(null);
         EventManager.getInstance().listen(BCEvent.EVT_SELECTED_MEMBER_MAYBE_CHANGED,this.onSelectedMemberChanged);
         EventManager.getInstance().listen(BCEvent.EVT_REFRESH_UI_AFTER_INVENTORY_CHANGE,this.updatePanel);
         DataManager.getInstance().bind(DataID.CHARACTERLOADOUT_CHARACTERS_CURRENT_SHOWN_ID,this.updatePanel);
         stage.addEventListener(KeyboardEvent.KEY_UP,this.onStageKeyHandle);
         this.m_bindLobbyCharacterData.bind();
      }
      
      override protected function disableData() : void
      {
         EventManager.getInstance().unlisten(BCEvent.EVT_SELECTED_MEMBER_MAYBE_CHANGED,this.onSelectedMemberChanged);
         EventManager.getInstance().unlisten(BCEvent.EVT_REFRESH_UI_AFTER_INVENTORY_CHANGE,this.updatePanel);
         DataManager.getInstance().bind(DataID.CHARACTERLOADOUT_CHARACTERS_CURRENT_SHOWN_ID,this.updatePanel);
         stage.removeEventListener(KeyboardEvent.KEY_UP,this.onStageKeyHandle);
         this.m_bindLobbyCharacterData.unbind();
      }
      
      private function onStageKeyHandle(e:KeyboardEvent) : void
      {
         if(e.type == KeyboardEvent.KEY_UP)
         {
            switch(e.keyCode)
            {
               case Keyboard.ESCAPE:
                  this.onClosePanel();
            }
         }
      }
      
      private function onSelectedMemberChanged(cEvt:ParaEvent) : void
      {
         this.updateGearForMember(cEvt.myPara);
      }
      
      private function bind_onLobbyCharacterDataUpdated(cRes:Object) : void
      {
         this.updateGearForMember(cRes.data);
      }
      
      private function updateGearForMember(currentMember:RoomMemberObj) : void
      {
         var i:int = 0;
         var product:ProductObj = null;
         var characterID:int = 0;
         var itemInBundle:int = 0;
         var bundleProductID:int = 0;
         if(currentMember == null)
         {
            currentMember = DataManager.getInstance().getDP(DataID.CURRENT_SELECTED_CHARACTER_MEMBER_OBJ);
            if(currentMember == null)
            {
               currentMember = DataManager.getInstance().getDP(DataID.MY_AVATAR_MEMBER_OBJ);
            }
         }
         if(currentMember == null)
         {
            return;
         }
         this._currentMember = currentMember;
         var emptyData:CustomObject = new CustomObject();
         emptyData.isLocked = false;
         emptyData.isEmpty = true;
         if(!currentMember.isMe)
         {
            emptyData.isEnable = false;
         }
         this.getLobbyItemFooterButton("myBuyButton" + AVATAR_INDEX).visible = false;
         for(i = TATTOO_INDEX; i < GEAR_SLOT_NUM; i++)
         {
            this.getLoadoutButton("myGearSlot" + i).myImage.clearImage();
            this.getLoadoutButton("myGearSlot" + i).setData(emptyData);
            this.getLobbyItemFooterButton("myBuyButton" + i).visible = false;
         }
         if(currentMember.isMe)
         {
            this.myLoadoutFilter.refreshCharacters(this);
            UiCppItemListView(_uiCpp).SetInitData([null],true);
         }
         else
         {
            characterID = 0;
            itemInBundle = 0;
            for(i = 0; i < currentMember.weaponloadObj.characterParts.length; i++)
            {
               if(currentMember.weaponloadObj.characterParts[i] != 0)
               {
                  product = CFunctionCommonContainer.GetItemInfo(currentMember.weaponloadObj.characterParts[i]);
                  this.setUpGearProduct(product,currentMember);
                  if(product.group == MarketMenuData.TYPE_CHARACTER)
                  {
                     characterID = product.id;
                  }
                  if(product.isInBundle)
                  {
                     itemInBundle = product.id;
                  }
               }
            }
            if(characterID != 0 && itemInBundle != 0)
            {
               bundleProductID = CFunctionContainer.AS_GetBundleProductIDByCharacterAndPiece(characterID,itemInBundle);
               if(bundleProductID > 0)
               {
                  product = new ProductObj(CFunctionCommonContainer.GetBundleInfo(bundleProductID));
                  this.setUpGearProduct(product,currentMember);
               }
            }
            for(i = 0; i < currentMember.weaponloadObj.emotes.length; i++)
            {
               if(currentMember.weaponloadObj.emotes[i] != 0)
               {
                  product = CFunctionCommonContainer.GetItemInfo(currentMember.weaponloadObj.emotes[0]);
                  this.setUpGearProduct(product,currentMember);
                  break;
               }
            }
         }
      }
      
      private function setUpGearProduct(product:ProductObj, currentMember:RoomMemberObj) : void
      {
         var data:CustomObject = null;
         var index:int = -1;
         switch(product.group)
         {
            case MarketMenuData.GRP_TATTOO:
               index = TATTOO_INDEX;
               break;
            case MarketMenuData.GRP_EMOTE:
               index = EMOTE_INDEX;
               break;
            case MarketMenuData.GRP_HEADGEAR:
               index = HEADWEAR_INDEX;
               break;
            case MarketMenuData.GRP_EYEWEAR:
               index = EYEWEAR_INDEX;
               break;
            case MarketMenuData.GRP_JACKET:
               index = JACKET_INDEX;
               break;
            case MarketMenuData.GRP_VEST:
               index = VEST_INDEX;
               break;
            case MarketMenuData.GRP_GLOVE:
               index = GLOVES_INDEX;
               break;
            case MarketMenuData.GRP_PANTS:
               index = PANTS_INDEX;
               break;
            case MarketMenuData.TYPE_CHARACTER:
               index = AVATAR_INDEX;
               break;
            case MarketMenuData.GRP_OUTFIT:
               index = OUTFIT_INDEX;
         }
         if(index < 0)
         {
            return;
         }
         if(index != AVATAR_INDEX && product.isInBundle)
         {
            return;
         }
         this.getLobbyItemFooterButton("myBuyButton" + index).setProduct(product);
         this.getLobbyItemFooterButton("myBuyButton" + index).visible = !currentMember.isMe && !product.isOwned();
         if(index != AVATAR_INDEX)
         {
            data = new CustomObject();
            data.imageURL = product.imageURL;
            data.product = product;
            data.index = index;
            if(currentMember.isMe)
            {
               data.clearCallback = this.onClearGear;
               data.isEmpty = false;
            }
            this.getLoadoutButton("myGearSlot" + index).setData(data);
         }
         else
         {
            this.myGear["myAvatarSlot"].myImage.setImage(product.imageURL || "");
            this.myGear.myAvatarSlot.myName.text = product.name;
         }
      }
      
      public function registerBackCallback(f:Function) : void
      {
         this.mBackCallback = f;
      }
      
      public function registerGearSlotSelectedCallback(c:Function) : void
      {
         this.mGearSlotSelectedCallback = c;
      }
      
      private function onClosePanel() : void
      {
         if(null != this.mBackCallback)
         {
            this.mBackCallback(this);
         }
      }
      
      private function onGearSlotFocused(item:UIInteractiveComponent) : void
      {
         var data:Object = item.getData();
         if(data == null)
         {
            return;
         }
         if(data.product != null)
         {
            EventManager.getInstance().broadcast(BCEvent.EVT_SHOW_ITEM_INFO_PREVIEW,{
               "product":data.product,
               "compare":false
            });
         }
      }
      
      private function onGearSlotUnfocused() : void
      {
         EventManager.getInstance().broadcast(BCEvent.EVT_HIDE_ITEM_INFO_PREVIEW);
      }
      
      private function onGearSlotSelected(slotIndex:int) : void
      {
         if(!this._currentMember.isMe)
         {
            return;
         }
         var categoryIndex:int = 0;
         switch(slotIndex)
         {
            case EMOTE_INDEX:
               categoryIndex = 1;
               break;
            case HEADWEAR_INDEX:
               categoryIndex = 2;
               break;
            case EYEWEAR_INDEX:
               categoryIndex = 3;
               break;
            case JACKET_INDEX:
               categoryIndex = 4;
               break;
            case VEST_INDEX:
               categoryIndex = 5;
               break;
            case TATTOO_INDEX:
               categoryIndex = 6;
               break;
            case GLOVES_INDEX:
               categoryIndex = 7;
               break;
            case PANTS_INDEX:
               categoryIndex = 8;
               break;
            case OUTFIT_INDEX:
               categoryIndex = 9;
               break;
            default:
               categoryIndex = 0;
         }
         if(this.mGearSlotSelectedCallback != null)
         {
            this.mGearSlotSelectedCallback(categoryIndex);
         }
      }
      
      public function onBuyButtonPressed(product:ProductObj) : void
      {
         EventManager.getInstance().broadcast(BCEvent.EVT_MARKET_PURCHASE_POPUP,{"itemData":product});
      }
      
      public function onClearGear(gearSlot:LoadoutButton) : void
      {
         var prod:ProductObj = gearSlot.getData().product;
         if(prod.group != MarketMenuData.GRP_KNIFE)
         {
            EventManager.getInstance().broadcast(BCEvent.EVT_CHARACTERLOADOUT_UNEQUIP_ITEM_BY_ITEM,{"data":prod});
         }
         else
         {
            EventManager.getInstance().broadcast(BCEvent.EVT_WEAPONLOADOUT_UNEQUIP_ITEM,{"data":prod});
         }
         this.updateGearForMember(this._currentMember);
      }
      
      public function updatePanel() : void
      {
         this.updateGearForMember(this._currentMember);
      }
      
      public function uiCppSetItems(list1:Array, list2:Array, ownedFirst:Boolean) : void
      {
         var productArray:Array = null;
         var product:ProductObj = null;
         var i:int = 0;
         if(this._currentMember.isMe)
         {
            productArray = ownedFirst ? list1 : list2;
            for(i = 0; i < productArray.length; i++)
            {
               product = productArray[i];
               if(product.isEquipped())
               {
                  this.setUpGearProduct(product,this._currentMember);
               }
            }
         }
         else
         {
            this.updateGearForMember(this._currentMember);
         }
      }
   }
}

