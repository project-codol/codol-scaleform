package codo.views.hudSpy
{
   import codo.component.TextField;
   import codo.localization.DictHud;
   import codo.style.GlobalGuide;
   import codo.style.SpyHudGuide;
   import codo.utils.LocalizeUtil;
   import flash.display.MovieClip;
   
   public class KarmaWarning extends MovieClip
   {
      
      public var myWarningTF:TextField;
      
      public var myBg:MovieClip;
      
      public function KarmaWarning()
      {
         super();
         this.initStage();
      }
      
      private function initStage() : void
      {
         this.myWarningTF.textStyle = SpyHudGuide.KarmaWarning;
         this.myWarningTF.text = "";
      }
      
      public function cppSetDamageRate(rate:int) : void
      {
         if(rate >= 100)
         {
            visible = false;
            return;
         }
         visible = true;
         LocalizeUtil.paramColorized(this.myWarningTF.myTextClip,DictHud.SPY_LOW_KARMA_WARNING,[rate.toString() + "%"],[GlobalGuide.BLACK]);
      }
   }
}

