package codo.views
{
   import codo.base.PopupView;
   import codo.common.CFunctionCommonContainer;
   import codo.component.TextField;
   import codo.component.core.ItemCardBase;
   import codo.constants.BCEvent;
   import codo.event.ParaEvent;
   import codo.localization.Dict;
   import codo.objects.ActivityData;
   import codo.objects.ProductObj;
   import codo.objects.SystemMsgObj;
   import codo.style.GlobalGuide;
   import codo.style.PopupGuide;
   import flash.display.MovieClip;
   
   public class ActivityRewardPopup extends PopupView
   {
      
      private static const TYPE_ITEM:int = 1;
      
      private static const TYPE_XP:int = 2;
      
      private static const TYPE_GP:int = 3;
      
      private static const TYPE_TCMSG:int = 4;
      
      private static const POPUP_WIDTH:Number = 600;
      
      private static const POPUP_HEIGHT:Number = 294;
      
      public var myHeader:TextField;
      
      public var myDescription:TextField;
      
      public var myQuantity:TextField;
      
      public var myReward:ItemCardBase;
      
      public var myXPGPIcon:MovieClip;
      
      private var m_msgObj:SystemMsgObj;
      
      private var myDescriptionX:Number;
      
      public function ActivityRewardPopup()
      {
         super();
         this.myHeader.font = GlobalGuide.FONT_FACE_BOLD;
         this.myHeader.fontSize = GlobalGuide.FONT_SIZE_LARGE;
         this.myHeader.width = POPUP_WIDTH;
         this.myHeader.height = 42;
         this.myHeader.text = Dict.TITLE_SYS_GIFT;
         myPopup.width = POPUP_WIDTH;
         myPopup.height = POPUP_HEIGHT;
         myPopup.myHeaderbar.title = "";
         myPopup.configConfirmButton(Dict.CONFIRM,this.onConfirm,true);
         this.myDescription.textStyle = PopupGuide.styleActivityRewardPopupMsg;
         this.myDescription.width = 260;
         this.myDescription.height = 140;
         this.myDescriptionX = this.myDescription.x;
         this.myQuantity.textStyle = PopupGuide.styleActivityRewardQuantity;
         this.myQuantity.width = 200;
         this.myQuantity.height = 60;
         listen(BCEvent.EVT_SET_ACTIVITY_VIEW_MSG,this.onSetActivityMsg);
      }
      
      override protected function showView() : void
      {
         super.showView();
      }
      
      private function onSetActivityMsg(cEvt:ParaEvent) : void
      {
         var activityData:ActivityData = null;
         var itemObj:Object = null;
         var prod:ProductObj = null;
         var msgObj:SystemMsgObj = cEvt.myPara as SystemMsgObj;
         this.m_msgObj = msgObj;
         if(Boolean(msgObj.activityData))
         {
            activityData = msgObj.activityData as ActivityData;
            this.myDescription.text = this.m_msgObj.message;
            this.myDescription.x = this.myDescriptionX;
            if(activityData.type == TYPE_XP)
            {
               this.myReward.visible = false;
               this.myXPGPIcon.visible = this.myQuantity.visible = true;
               this.myQuantity.text = "+" + String(activityData.xp);
               this.myXPGPIcon.gotoAndStop(1);
            }
            else if(activityData.type == TYPE_GP)
            {
               this.myReward.visible = false;
               this.myXPGPIcon.visible = this.myQuantity.visible = true;
               this.myQuantity.text = "+" + String(activityData.gp);
               this.myXPGPIcon.gotoAndStop(2);
            }
            else if(activityData.type == TYPE_ITEM)
            {
               this.myReward.visible = true;
               this.myXPGPIcon.visible = this.myQuantity.visible = false;
               itemObj = activityData.item;
               prod = CFunctionCommonContainer.GetItemInfo(int(itemObj.id));
               if(itemObj.hasOwnProperty("duration") && itemObj.duration > 0)
               {
                  prod.expiryDuration = itemObj.duration;
               }
               else
               {
                  prod.expiryDuration = 0;
               }
               this.myReward.setData(prod);
            }
            else if(activityData.type == TYPE_TCMSG)
            {
               this.myReward.visible = false;
               this.myXPGPIcon.visible = this.myQuantity.visible = false;
               this.myDescription.x = (POPUP_WIDTH - this.myDescription.width) / 2;
            }
         }
      }
      
      private function onConfirm() : void
      {
         this.closePopupView();
      }
      
      override protected function closePopupView() : void
      {
         this.m_msgObj.btn0Handle();
      }
   }
}

