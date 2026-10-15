package codo.component.career
{
   import codo.common.CFunctionCommonContainer;
   import codo.component.core.UIInteractiveComponent;
   import codo.localization.Dict;
   import codo.objects.ChallengeRewardObj;
   import codo.objects.ProductObj;
   import codo.style.GlobalGuide;
   import codo.utils.GraphicUtil;
   import codo.utils.ItemUtil;
   import codo.utils.LocalizeUtil;
   import flash.display.MovieClip;
   import flash.geom.ColorTransform;
   import flash.text.TextField;
   import fsg.util.FsgImageHolder;
   
   public class ChallengeChecklistItemRewardOld extends UIInteractiveComponent
   {
      
      public var myRewardImage:FsgImageHolder;
      
      public var myXpGp:TextField;
      
      public var myQuantity:TextField;
      
      public var myDuration:TextField;
      
      public var myCheck:MovieClip;
      
      public function ChallengeChecklistItemRewardOld()
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
         if(reward.type == ChallengeRewardObj.REWARD_TYPE_ITEM)
         {
            prodObj = CFunctionCommonContainer.GetItemInfo(reward.entityId);
         }
         else
         {
            prodObj = ItemUtil.getProductObjByProductId(reward.entityId);
         }
         if(Boolean(prodObj))
         {
            ItemUtil.setItemImage(this.myRewardImage,prodObj);
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
         var gpxpStr:String = "";
         if(reward.gp != 0)
         {
            gpxpStr = "+ " + reward.gp.toString() + " GP" + "\n";
         }
         if(reward.xp != 0)
         {
            gpxpStr += "+ " + reward.xp.toString() + " XP";
         }
         this.myXpGp.text = gpxpStr;
         this.setComplete(reward.claimed);
      }
      
      public function setComplete(complete:Boolean) : void
      {
         GraphicUtil.desaturate(this.myRewardImage,complete);
         var tint:Number = 0.6;
         this.myRewardImage.transform.colorTransform = complete ? new ColorTransform(tint,tint,tint,tint,7,66,96,0.5) : null;
         this.myXpGp.textColor = this.myDuration.textColor = complete ? GlobalGuide.CODO_GRAY_LIGHT : GlobalGuide.WHITE;
         this.myCheck.visible = complete;
      }
   }
}

