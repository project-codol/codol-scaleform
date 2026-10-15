package components.asympvp_part
{
   import codo.common.CFunctionCommonContainer;
   import codo.constants.BCEvent;
   import codo.event.ParaEvent;
   import codo.localization.Dict;
   import codo.localization.DictMarket;
   import codo.localization.DictRoom;
   import codo.objects.AsymPvpLoadoutObj;
   import codo.objects.ProductObj;
   import codo.utils.AsymPvpUtil;
   import codo.utils.LocalizeUtil;
   import codo.utils.ScaleformUtil;
   import components.BaseButton;
   import components.asym.AsymAbilityList;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import fsg.shared.BehaviourList;
   import fsg.shared.BehaviourScrollPane;
   import fsg.shared.DynamicSizeButton;
   import fsg.shared.ScrollBar;
   import fsg.shared.popups.PopupContentBase;
   import fsg.util.FsgImageHolder;
   import scaleform.gfx.TextFieldEx;
   
   public class AsymPurchasePopupViewContent extends PopupContentBase
   {
      
      public var myScrollArea:MovieClip;
      
      public var myScrollBar:ScrollBar;
      
      public var myMask:MovieClip;
      
      public var myAbilitiesList:AsymAbilityList;
      
      public var myImage:FsgImageHolder;
      
      public var myDefaultImage:FsgImageHolder;
      
      public var myBuyNowButton:DynamicSizeButton;
      
      public var myDefaultModelName:TextField;
      
      public var myModelName:TextField;
      
      public var myVariantName:TextField;
      
      private var mList:BehaviourList;
      
      private var mScrollPaneBehaviour:BehaviourScrollPane;
      
      private var mCurrentClassIndex:int = -1;
      
      private var mLoadouts:Array;
      
      private var mLoadoutCategories:Array;
      
      private var mListItems:Array;
      
      private var mCurrentLoadout:AsymPvpLoadoutObj;
      
      private var mOnPurchaseClickCallback:Function;
      
      public function AsymPurchasePopupViewContent()
      {
         var BTN_HEIGHT:uint = 0;
         super();
         BTN_HEIGHT = 66;
         this.myImage.mouseChildren = false;
         this.myImage.buttonMode = false;
         this.myImage.mouseEnabled = false;
         this.myDefaultImage.mouseChildren = false;
         this.myDefaultImage.buttonMode = false;
         this.myDefaultImage.mouseEnabled = false;
         this.myAbilitiesList.setKeys();
         this.myBuyNowButton.setSize(237,BTN_HEIGHT);
         this.myBuyNowButton.registerClickEvent(this.onBuyButtonClicked);
         var tf:TextField = this.myBuyNowButton.myButtonText.myTextTF;
         var format:TextFormat = tf.getTextFormat();
         format.size = 32;
         tf.setTextFormat(format);
         TextFieldEx.setVerticalAlign(tf,TextFieldEx.VALIGN_CENTER);
         this.mList = new BehaviourList(this.myScrollArea,true,5);
         this.mScrollPaneBehaviour = new BehaviourScrollPane(this.myScrollBar,this.myMask,this.myScrollArea,this);
      }
      
      public function initContent(onPurchaseClickCallback:Function) : void
      {
         var loadout:AsymPvpLoadoutObj = null;
         var loadoutArray:Array = null;
         var item:asymMonsterLoadoutListItem = null;
         var labelItem:asymMonsterCategoryListItem = null;
         var i:Number = NaN;
         var n:Number = NaN;
         var purchased:Boolean = false;
         this.mOnPurchaseClickCallback = onPurchaseClickCallback;
         this.mCurrentClassIndex = 0;
         this.mLoadouts = new Array();
         this.mListItems = new Array();
         var loadoutNonPurchaseable:Array = new Array();
         if(ScaleformUtil.isScaleform)
         {
            this.mLoadoutCategories = AsymPvpUtil.instance.loadoutCategories;
            for(i = 0; i < this.mLoadoutCategories.length; i++)
            {
               this.mLoadouts[i] = new Array();
               this.mLoadouts[i][0] = this.mLoadoutCategories[i];
               this.mLoadouts[i][1] = new Array();
               loadoutArray = AsymPvpUtil.instance.getClassLoadouts(i);
               for each(loadout in loadoutArray)
               {
                  if(loadout.isPurchaseable)
                  {
                     this.mLoadouts[i][1].push(loadout);
                  }
                  else if(loadout.isPurchased && !loadout.isExpired)
                  {
                     this.mLoadouts[i][1].push(loadout);
                     loadoutNonPurchaseable.push(loadout.itemID);
                  }
               }
            }
         }
         else
         {
            this.mLoadouts = this.generateDebugData();
         }
         for(var category:Number = 0; category < this.mLoadouts.length; category++)
         {
            labelItem = new asymMonsterCategoryListItem();
            labelItem.myTextTF.text = LocalizeUtil.localize(this.mLoadouts[category][0].name).toUpperCase();
            this.mList.addItem(labelItem);
            for(n = 0; n < this.mLoadouts[category][1].length; n++)
            {
               item = new asymMonsterLoadoutListItem();
               purchased = loadoutNonPurchaseable.indexOf(this.mLoadouts[category][1][n].itemID) == -1;
               item.isPurchaseButton(purchased);
               item.setData(this.mLoadouts[category][1][n]);
               item.addEventListener(BaseButton.EVT_CLICK,this.onLoadoutClick);
               this.mList.addItem(item);
               this.mListItems.push(item);
            }
         }
         if(this.mListItems.length > 0)
         {
            loadout = this.mLoadouts[0][1][0];
            this.mListItems[0].selected = true;
            this.displayLoadout(loadout);
         }
         this.myScrollBar.setPosition(0);
         this.mScrollPaneBehaviour.refreshScrollBar();
         this.myDefaultModelName.text = Dict.ASYM_PURCHASE_POPUP_DEFAULT_ROBOT;
      }
      
      private function setBotImage(img:String) : void
      {
         this.myImage.setImage(img);
      }
      
      private function setBotDefaultImage(img:String) : void
      {
         if(img == "")
         {
            this.myDefaultImage.visible = false;
         }
         else
         {
            this.myDefaultImage.visible = true;
            this.myDefaultImage.setImage(img);
         }
      }
      
      private function onLoadoutClick(cEvt:ParaEvent) : void
      {
         var item:AsymMonsterLoadoutListItem = cEvt.currentTarget as AsymMonsterLoadoutListItem;
         var loadout:AsymPvpLoadoutObj = item.getData() as AsymPvpLoadoutObj;
         this.displayLoadout(loadout);
         this.clearSelected();
         item.selected = true;
      }
      
      private function clearSelected() : void
      {
         for(var i:Number = 0; i < this.mListItems.length; i++)
         {
            this.mListItems[i].selected = false;
         }
      }
      
      private function displayLoadout(loadout:AsymPvpLoadoutObj) : void
      {
         var tloadout:AsymPvpLoadoutObj = null;
         var prod:ProductObj = CFunctionCommonContainer.GetItemInfo(loadout.itemID);
         var isOwnedPermanent:Boolean = prod.isOwnedPermanent();
         var isOwnedRental:Boolean = prod.isOwnedRental();
         var btnText:String = isOwnedRental ? DictMarket.EXTEND : DictMarket.BUY_NOW;
         this.myBuyNowButton.setEnabled(true);
         if(isOwnedPermanent)
         {
            btnText = DictMarket.PURCHASED;
            this.myBuyNowButton.setEnabled(false);
         }
         this.mCurrentLoadout = loadout;
         this.myAbilitiesList.setData(loadout);
         this.setBotImage(loadout.image);
         this.myModelName.text = LocalizeUtil.localize(loadout.category).toUpperCase();
         this.myVariantName.text = LocalizeUtil.localize(loadout.name).toUpperCase();
         this.myBuyNowButton.setText(LocalizeUtil.localize(btnText).toUpperCase());
         if(this.mListItems.length > 0)
         {
            tloadout = AsymPvpUtil.instance.getClassLoadouts(loadout.categoryType)[0];
            if(loadout.isDefault == true)
            {
               this.setBotDefaultImage("");
               this.myDefaultModelName.visible = false;
            }
            else
            {
               if(tloadout != null && tloadout.image != null)
               {
                  this.setBotDefaultImage(tloadout.image);
               }
               this.myDefaultModelName.visible = true;
            }
         }
      }
      
      public function refreshLoadout() : void
      {
         if(Boolean(this.mCurrentLoadout))
         {
            this.displayLoadout(this.mCurrentLoadout);
         }
      }
      
      override protected function configPopUpBase() : void
      {
         super.configPopUpBase();
         myPopupBase.configConfirmButton(DictRoom.JOIN,this.onConfirmClicked);
         myPopupBase.configCancelButton(DictMarket.CANCEL_BUY,this.onCancelClicked);
      }
      
      public function refreshButtons(showStartMatchButton:Boolean) : void
      {
         myPopupBase.resetButtons();
         if(showStartMatchButton)
         {
            myPopupBase.configConfirmButton(DictRoom.JOIN,this.onConfirmClicked);
         }
         myPopupBase.configCancelButton(DictMarket.CANCEL_BUY,this.onCancelClicked);
      }
      
      private function onBuyButtonClicked() : void
      {
         var isOwned:Boolean = CFunctionCommonContainer.IsItemInInventory(this.mCurrentLoadout.itemID) as Boolean;
         var prodObj:ProductObj = CFunctionCommonContainer.GetItemInfo(this.mCurrentLoadout.itemID);
         CFunctionCommonContainer.AS_SetupAndReturnMinSkus(prodObj);
         var bUseCP:Boolean = prodObj.CPSKUIndex != uint.MAX_VALUE;
         this.mOnPurchaseClickCallback();
         broadcast(BCEvent.EVT_MARKET_PURCHASE_POPUP,{
            "itemData":prodObj,
            "useCP":bUseCP
         });
      }
      
      private function onConfirmClicked() : void
      {
         broadcast(BCEvent.EVT_TOKEN_BUY_POPUP_START_GAME);
      }
      
      private function onCancelClicked() : void
      {
         this.broadcast(BCEvent.EVT_CANCEL_BUY_ASYM_ROBOT);
      }
      
      override protected function get viewWidth() : uint
      {
         return 860;
      }
      
      override protected function get viewHeight() : uint
      {
         return 479;
      }
      
      private function generateDebugData() : Array
      {
         var loadouts:Array = null;
         var j:Number = NaN;
         var returnArray:Array = new Array();
         var loadout:AsymPvpLoadoutObj = new AsymPvpLoadoutObj();
         for(var i:Number = 0; i < AsymPvpUtil.NUM_CLASSES; i++)
         {
            loadouts = new Array();
            for(j = 0; j < 4; j++)
            {
               loadout = new AsymPvpLoadoutObj();
               loadout.name = "Test " + j;
               loadout.id = "Test";
               loadout.category = "Category";
               loadout.isPurchased = false;
               loadout.itemID = i + j;
               loadouts.push(loadout);
            }
            returnArray[i] = new Array();
            returnArray[i][0] = {"name":"Category Header"};
            returnArray[i][1] = loadouts;
         }
         return returnArray;
      }
   }
}

