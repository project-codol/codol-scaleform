package codo.views.hud.zhuntObtainCrateHint
{
   import codo.constants.HUDComponentTypes;
   import codo.utils.TextUtil;
   import codo.views.hud.HUDComponent;
   import com.greensock.TweenLite;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class ZhuntObtainCrateHint extends HUDComponent
   {
      
      public var myHint:TextField;
      
      public function ZhuntObtainCrateHint()
      {
         super();
         alpha = 0;
      }
      
      override public function get CompType() : int
      {
         return HUDComponentTypes.ZHUNT_OBTAIN_CRATE_HINT;
      }
      
      public function cppShowHint() : void
      {
         TweenLite.killTweensOf(this);
         var format:TextFormat = this.myHint.getTextFormat();
         format.size = 31;
         this.myHint.setTextFormat(format);
         TextUtil.resizeTextToFitWidth(this.myHint);
         alpha = 0;
         TweenLite.to(this,0.5,{
            "alpha":1,
            "onComplete":this.onFadeInCompleted
         });
      }
      
      private function onFadeInCompleted() : void
      {
         TweenLite.to(this,0.5,{
            "delay":2,
            "alpha":0
         });
      }
   }
}

