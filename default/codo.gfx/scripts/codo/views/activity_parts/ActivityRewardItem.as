package codo.views.activity_parts
{
   import codo.component.core.ItemCardBase;
   import codo.localization.Dict;
   import codo.style.GlobalGuide;
   import codo.style.MarketGuide;
   import codo.utils.LocalizeUtil;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.text.TextField;
   import scaleform.gfx.TextFieldEx;
   
   public class ActivityRewardItem extends ItemCardBase
   {
      
      public var myInnerOutline:MovieClip;
      
      public var myTierCornerFill:MovieClip;
      
      public var myDurationTF:TextField;
      
      public function ActivityRewardItem()
      {
         super();
      }
      
      override public function setData(data:*) : void
      {
         super.setData(data);
         TextFieldEx.setVerticalAlign(myItemNameTF,TextFieldEx.VALIGN_BOTTOM);
         GlobalGuide.formatComponentsByTier(MarketGuide.COLOR_BY_TIER[data.tier],new <DisplayObject>[this.myInnerOutline,this.myTierCornerFill]);
         myItemCategoryTF.visible = myBuffs.visible = false;
         this.myDurationTF.visible = data.expiryDuration > 0;
         this.myDurationTF.text = String(data.expiryDuration) + LocalizeUtil.localize(Dict.DAY);
      }
      
      override protected function onIconImageLoaded(e:Event) : void
      {
         var bmpImage:DisplayObject = null;
         myItemIconHolder.removeEventListener(Event.COMPLETE,this.onIconImageLoaded);
         bmpImage = myItemIconHolder.loadedAsset;
         var MAX_HEIGHT:uint = 160;
         bmpImage.height = Math.min(MAX_HEIGHT,bmpImage.height);
         bmpImage.scaleX = bmpImage.scaleY;
         bmpImage.x = this.myInnerOutline.x + (this.myInnerOutline.width - bmpImage.width) * 0.5;
         bmpImage.y = this.myInnerOutline.y + (this.myInnerOutline.height - bmpImage.height) * 0.5;
      }
   }
}

