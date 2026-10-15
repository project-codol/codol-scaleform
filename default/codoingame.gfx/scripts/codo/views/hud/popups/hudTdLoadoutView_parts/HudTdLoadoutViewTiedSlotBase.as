package codo.views.hud.popups.hudTdLoadoutView_parts
{
   import codo.common.CFunctionInGameContainer;
   import flash.display.MovieClip;
   import flash.geom.ColorTransform;
   
   public class HudTdLoadoutViewTiedSlotBase extends HudTdLoadoutViewSlotBase
   {
      
      public static var TIER_COLOR:Array = [11579568,356352,22420,6160532,10962946];
      
      public var myOutline:MovieClip;
      
      public var myColorBg:MovieClip;
      
      public function HudTdLoadoutViewTiedSlotBase()
      {
         super();
      }
      
      override public function set lootItemIndex(lootItemIndex:int) : void
      {
         super.lootItemIndex = lootItemIndex;
         var itemInfo:Object = CFunctionInGameContainer.AS_TD_GetLootItemInfo(lootItemIndex);
         var tier:int = itemInfo != null && itemInfo.tier < TIER_COLOR.length ? int(itemInfo.tier) : 0;
         this.myColorBg.gotoAndStop(tier + 1);
         var colorTransform:ColorTransform = new ColorTransform();
         colorTransform.color = TIER_COLOR[tier];
         this.myOutline.transform.colorTransform = colorTransform;
      }
   }
}

