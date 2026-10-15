package codo.views.hud.vip
{
   import codo.constants.HUDComponentTypes;
   import codo.localization.DictVIP;
   import codo.utils.LocalizeUtil;
   import codo.utils.MathUtil;
   import codo.views.hud.HUDComponent;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class HUDVIPEvactionHint extends HUDComponent
   {
      
      private const FRAME_DEFENDER:int = 1;
      
      private const FRAME_ATTACKER:int = 2;
      
      private const TEXT_BG_MARGIN:Number = 4;
      
      public var myText:TextField;
      
      public var myTextBg:MovieClip;
      
      public var myProgress:MovieClip;
      
      public var myProgressHead:MovieClip;
      
      public function HUDVIPEvactionHint()
      {
         super();
         this.myText.text = LocalizeUtil.localize(DictVIP.VIP_EVACUATING) + "...";
         this.myTextBg.width = this.myText.textWidth + this.TEXT_BG_MARGIN * 2;
      }
      
      override public function get CompType() : int
      {
         return HUDComponentTypes.VIP_EVACTION_HINT;
      }
      
      public function set isAttacker(attack:Boolean) : void
      {
         gotoAndStop(attack ? this.FRAME_ATTACKER : this.FRAME_DEFENDER);
      }
      
      public function set progress(p:Number) : void
      {
         p = MathUtil.clamp(p,0,1);
         this.myProgress.scaleX = p;
         this.myProgressHead.x = this.myProgress.x + this.myProgress.width;
      }
   }
}

