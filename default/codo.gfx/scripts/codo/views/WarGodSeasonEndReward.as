package codo.views
{
   import codo.base.PopupView;
   import codo.common.CFunctionCommonContainer;
   import codo.component.Button;
   import codo.component.TextField;
   import codo.component.marketplaceitem.parts.MarketplaceItemCard;
   import codo.constants.BCEvent;
   import codo.event.ParaEvent;
   import codo.localization.Dict;
   import codo.localization.DictMarket;
   import codo.localization.DictWarGod;
   import codo.objects.ProductObj;
   import codo.objects.SystemMsgObj;
   import codo.objects.WarGodRewardObj;
   import codo.objects.WarGodSeasonEndRewardObj;
   import codo.style.WarGodGuide;
   import codo.utils.ItemUtil;
   import codo.utils.LocalizeUtil;
   import codo.utils.MarketItemUtil;
   import codo.utils.TextUtil;
   import flash.display.MovieClip;
   import fsg.util.FsgImageHolder;
   
   public class WarGodSeasonEndReward extends PopupView
   {
      
      private static const CURRENCY_ID_HP:int = 8;
      
      private static const CURRENCY_ID_EHP:int = 9;
      
      private static const CURRENCY_HP_ICON:String = "scaleform_ash/itemicons/currency_hp";
      
      private static const CURRENCY_EHP_ICON:String = "scaleform_ash/itemicons/currency_ehp";
      
      public var myTitle:TextField;
      
      public var myName:TextField;
      
      public var myTime:TextField;
      
      public var myDescription:TextField;
      
      public var myConfirmBtn:Button;
      
      public var myReward:MarketplaceItemCard;
      
      public var myCurrencyReward:MovieClip;
      
      private var mMsgObj:SystemMsgObj;
      
      public function WarGodSeasonEndReward()
      {
         super();
         myPopup.visible = false;
         this.myTitle.textStyle = WarGodGuide.styleRewardTitle;
         this.myTitle.width = 850;
         this.myTitle.height = 58;
         this.myTitle.x = 0;
         this.myTitle.y = 0;
         this.myName.textStyle = WarGodGuide.styleRewardName;
         this.myName.width = 432;
         this.myName.height = 36;
         this.myName.x = 0;
         this.myName.y = 309;
         this.myTime.textStyle = WarGodGuide.styleRewardTime;
         this.myTime.width = 432;
         this.myTime.height = 32;
         this.myTime.x = 0;
         this.myTime.y = 350;
         this.myDescription.textStyle = WarGodGuide.styleRewardDescription;
         this.myDescription.width = 836;
         this.myDescription.height = 62;
         this.myDescription.x = 14;
         this.myDescription.y = 420;
         this.myTitle.text = DictWarGod.WARGOD_SEASON_REWARD_TITLE;
         this.myConfirmBtn.label = Dict.CONFIRM;
         this.myReward.setCardStyle(MarketItemUtil.ITEM_CARD_LARGE_FRAME,false);
         this.myReward.withDiscountTag = false;
         listen(BCEvent.EVT_SET_SEASON_END_REWARD_MSG,this.onSetSeasonEndRewardMsg);
         this.myConfirmBtn.registerClickEvent(this.closePopupView);
      }
      
      private function onSetSeasonEndRewardMsg(cEvt:ParaEvent) : void
      {
         var msgObj:WarGodSeasonEndRewardObj = null;
         var prod:ProductObj = null;
         this.mMsgObj = cEvt.myPara as SystemMsgObj;
         if(!this.mMsgObj.wargodSeasonRewardObj)
         {
            return;
         }
         this.myDescription.text = this.mMsgObj.message;
         msgObj = this.mMsgObj.wargodSeasonRewardObj;
         this.myName.text = msgObj.seasonName;
         TextUtil.resizeTextToFitWidth(this.myName.myTextClip);
         this.myTime.text = msgObj.seasonTime;
         if(msgObj.rewardType == WarGodSeasonEndRewardObj.CHALLENGE_REWARD)
         {
            this.myTitle.text = DictWarGod.WARGOD_CHALLENGE_REWARD_TITLE;
         }
         else
         {
            this.myTitle.text = DictWarGod.WARGOD_SEASON_REWARD_TITLE;
         }
         if(msgObj.itemType == WarGodRewardObj.TYPE_CURRENCY)
         {
            this.myCurrencyReward.visible = true;
            this.myReward.visible = false;
            this.displayCurrencyReward(msgObj.currencyID,msgObj.itemParameter);
         }
         else
         {
            this.myCurrencyReward.visible = false;
            this.myReward.visible = true;
            if(msgObj.seasonId == 1 || msgObj.seasonId == 2)
            {
               prod = CFunctionCommonContainer.GetItemInfo(msgObj.itemId);
            }
            else
            {
               prod = ItemUtil.getProductObjByProductId(msgObj.itemId);
            }
            prod.isBought = true;
            if(msgObj.itemType == WarGodRewardObj.TYPE_RENTAL)
            {
               prod.stackable = false;
               prod.remainSecond = msgObj.itemParameter * 24 * 3600;
               prod.isPermanentHave = prod.remainSecond == 0;
            }
            else
            {
               prod.stackable = true;
               prod.stackNumber = msgObj.itemParameter;
            }
            this.myReward.setData(prod);
         }
      }
      
      override protected function closePopupView() : void
      {
         this.mMsgObj.btn0Handle();
      }
      
      private function displayCurrencyReward(currencyID:int, currencyAmount:int) : void
      {
         var imageUrl:String = "";
         var description:String = "";
         if(currencyID == CURRENCY_ID_HP)
         {
            imageUrl = CURRENCY_HP_ICON;
            description = LocalizeUtil.localize(DictMarket.HP) + " " + String(currencyAmount);
         }
         if(currencyID == CURRENCY_ID_EHP)
         {
            imageUrl = CURRENCY_EHP_ICON;
            description = LocalizeUtil.localize(DictMarket.EHP) + " " + String(currencyAmount);
         }
         (this.myCurrencyReward.myItemImageHolder as FsgImageHolder).setImage(imageUrl);
         this.myCurrencyReward.myItemNameTF.text = description;
      }
   }
}

