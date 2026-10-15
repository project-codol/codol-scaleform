package codo.views.hud.td
{
   import codo.constants.HUDComponentTypes;
   import codo.localization.DictTD;
   import codo.views.hud.HUDComponent;
   import com.greensock.TweenLite;
   import flash.text.TextField;
   
   public class NightComingHint extends HUDComponent
   {
      
      public var myTitle:TextField;
      
      public function NightComingHint()
      {
         super();
         this.myTitle.text = DictTD.NIGHT_COMING_HINT;
         this.scaleX = this.scaleY = 0.8;
      }
      
      override public function get CompType() : int
      {
         return HUDComponentTypes.TD_NIGHT_COMING_HINT;
      }
      
      override public function set visible(visible:Boolean) : void
      {
         super.visible = visible;
         TweenLite.killTweensOf(this);
         if(visible)
         {
            alpha = 0;
            TweenLite.to(this,1,{
               "delay":0.5,
               "alpha":1
            });
         }
      }
   }
}

