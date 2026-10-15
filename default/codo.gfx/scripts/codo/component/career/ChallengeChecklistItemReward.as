package codo.component.career
{
   import codo.common.CFunctionCommonContainer;
   import codo.component.core.UIInteractiveComponent;
   import codo.localization.Dict;
   import codo.objects.ChallengeRewardObj;
   import codo.objects.ProductObj;
   import codo.utils.GraphicUtil;
   import codo.utils.ItemUtil;
   import codo.utils.LocalizeUtil;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.geom.ColorTransform;
   import flash.text.TextField;
   import fsg.util.FsgImageHolder;
   
   public class ChallengeChecklistItemReward extends UIInteractiveComponent
   {
      
      private static const ITEM_FRAME:int = 1;
      
      private static const GP_FRAME:int = 2;
      
      private static const XP_FRAME:int = 3;
      
      private static const GP_BOUNDARY_X:Number = 64;
      
      private static const XP_BOUNDARY_X:Number = 56;
      
      public var myRewardImage:FsgImageHolder;
      
      public var myQuantity:TextField;
      
      public var myDuration:TextField;
      
      public var myCheck:MovieClip;
      
      public function ChallengeChecklistItemReward()
      {
         super();
         isInteractiveEnabled = true;
      }
      
      override public function setData(data:*) : void
      {
         var reward:ChallengeRewardObj = null;
         super.setData(data);
         reward = data as ChallengeRewardObj;
         var prodObj:ProductObj = null;
         if(reward.type == ChallengeRewardObj.REWARD_TYPE_GP)
         {
            this.myRewardImage.gotoAndStop(GP_FRAME);
         }
         else if(reward.type == ChallengeRewardObj.REWARD_TYPE_XP)
         {
            this.myRewardImage.gotoAndStop(XP_FRAME);
         }
         else if(reward.type == ChallengeRewardObj.REWARD_TYPE_ITEM)
         {
            prodObj = CFunctionCommonContainer.GetItemInfo(reward.entityId);
         }
         else
         {
            prodObj = ItemUtil.getProductObjByProductId(reward.entityId);
         }
         if(Boolean(prodObj))
         {
            this.myRewardImage.gotoAndStop(ITEM_FRAME);
            ItemUtil.setItemImage(this.myRewardImage,prodObj);
            this.myRewardImage.addEventListener(Event.COMPLETE,this.onImageLoadComplete);
            if(prodObj.stackable && reward.entityInfo > 1)
            {
               this.myDuration.visible = false;
               this.myQuantity.visible = true;
               this.myQuantity.text = reward.entityInfo.toString();
            }
            else
            {
               this.myDuration.visible = true;
               this.myQuantity.visible = false;
               this.myDuration.text = LocalizeUtil.param(Dict.X_DAYS,[reward.entityInfo]);
            }
         }
         else
         {
            this.myDuration.visible = false;
            this.myQuantity.visible = true;
            this.myQuantity.text = reward.entityInfo.toString();
            this.refreshLayout(reward.type);
            this.myRewardImage.removeEventListener(Event.COMPLETE,this.onImageLoadComplete);
         }
         this.setComplete(reward.claimed);
      }
      
      public function setComplete(complete:Boolean) : void
      {
         GraphicUtil.desaturate(this.myRewardImage,complete);
         var tint:Number = 0.6;
         this.myRewardImage.transform.colorTransform = complete ? new ColorTransform(tint,tint,tint,tint,7,66,96,0.5) : null;
         this.myCheck.visible = complete;
      }
      
      private function onImageLoadComplete(e:Event) : void
      {
         var iconImg:DisplayObject = null;
         if(this.myRewardImage != null)
         {
            iconImg = this.myRewardImage.getChildAt(0);
            iconImg.x = 0;
            this.myRewardImage.removeEventListener(Event.COMPLETE,this.onImageLoadComplete);
            this.refreshLayout(ChallengeRewardObj.REWARD_TYPE_ITEM);
         }
      }
      
      private function refreshLayout(type:int) : void
      {
         var iconImg:DisplayObject = null;
         var imgBoundaryX:Number = 0;
         if(type == ChallengeRewardObj.REWARD_TYPE_GP)
         {
            imgBoundaryX = GP_BOUNDARY_X;
         }
         else if(type == ChallengeRewardObj.REWARD_TYPE_XP)
         {
            imgBoundaryX = XP_BOUNDARY_X;
         }
         else
         {
            iconImg = this.myRewardImage.getChildAt(0);
            imgBoundaryX = iconImg.width + iconImg.x;
         }
         this.myQuantity.x = this.myCheck.x = imgBoundaryX - this.myCheck.width * 0.6;
         this.myDuration.x = this.myCheck.x + this.myCheck.width - this.myDuration.width;
      }
      
      override public function get width() : Number
      {
         var iconWidth:Number = this.myRewardImage.width;
         var textBoundaryY:Number = this.myQuantity.x + this.myQuantity.textWidth;
         return iconWidth > textBoundaryY ? iconWidth : textBoundaryY;
      }
   }
}

