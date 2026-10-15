package codo.views
{
   import codo.base.PopupView;
   import codo.component.factory.MarketFactory;
   import codo.component.marketplaceitem.MarketplaceItem;
   import codo.constants.BCEvent;
   import codo.event.ParaEvent;
   import codo.localization.DictSystem;
   import codo.objects.RewardObjComplete;
   import codo.objects.SystemMsgObj;
   import flash.text.TextField;
   
   public class RewardPopup extends PopupView
   {
      
      public var myDescription:TextField;
      
      public var myItemCard:MarketplaceItem;
      
      private var mMsgObj:SystemMsgObj;
      
      public function RewardPopup()
      {
         super();
         this.initStage();
      }
      
      private function initStage() : void
      {
         this.myItemCard = MarketFactory.BUILD_MARKET_ITEM_LARGE_CARD() as MarketplaceItem;
         this.myItemCard.isInteractiveEnabled = false;
         this.myItemCard.x = 19;
         this.myItemCard.y = 100;
         addChild(this.myItemCard);
         myPopup.configCancelButton(DictSystem.CONFIRM,this.closePopupView);
         myPopup.height = 372;
         this.myDescription.x = 440;
         this.myDescription.y = 103;
         this.myDescription.width = 370;
         this.myItemCard.withOwnStateHint = false;
         listen(BCEvent.EVT_SET_REWARD_POPUP_MSG,this.onSetRewardPopupMsg);
      }
      
      private function onSetRewardPopupMsg(evt:ParaEvent) : void
      {
         this.mMsgObj = evt.myPara as SystemMsgObj;
         var rewardData:RewardObjComplete = this.mMsgObj.rewardPopupData;
         if(!rewardData)
         {
            return;
         }
         var header:String = rewardData.getExtraInfo1() as String;
         headerTitle = Boolean(header) ? header : "";
         var description:String = rewardData.getExtraInfo2() as String;
         this.myDescription.htmlText = Boolean(description) ? description : "";
         this.myItemCard.setData(rewardData.getWrappedObj());
      }
      
      override protected function closePopupView() : void
      {
         this.mMsgObj.btn0Handle();
      }
   }
}

