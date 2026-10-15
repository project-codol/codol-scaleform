package codo.views.hud.vip
{
   import codo.localization.DictVIP;
   import codo.views.hud.shared.AnimatedWaypointBase;
   import components.hud.CircleProgressBar;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class EvactionWaypoint extends AnimatedWaypointBase
   {
      
      private const ICON_BASE_SIZE:Number = 54;
      
      private const TEXT_BG_MARGIN:Number = 4;
      
      private const FRAME_DEFENDER:int = 1;
      
      private const FRAME_ATTACKER:int = 2;
      
      private const FRAME_ARROW_NEUTRAL:int = 1;
      
      private const FRAME_ARROW_DEFENDER:int = 2;
      
      private const FRAME_ARROW_ATTACKER:int = 3;
      
      private const LABEL_ARRAY:Array = ["A","B","C","D"];
      
      public var myText:TextField;
      
      public var myTextBg:MovieClip;
      
      public var myLabel:TextField;
      
      public var myProgressBar:CircleProgressBar;
      
      public function EvactionWaypoint()
      {
         super();
      }
      
      override public function setData(data:*) : void
      {
         gotoAndStop(Boolean(data.isAttacker) ? this.FRAME_ATTACKER : this.FRAME_DEFENDER);
         if(Boolean(data.isAttacker))
         {
            this.myText.text = data.progress > 0 ? DictVIP.VIP_EVACUATING : DictVIP.TARGET;
         }
         else
         {
            this.myText.text = data.progress > 0 ? DictVIP.VIP_EVACUATING : DictVIP.DEFENSE;
         }
         this.myTextBg.width = this.myText.textWidth + this.TEXT_BG_MARGIN * 2;
         if(data.progress > 0)
         {
            myArrow.gotoAndStop(Boolean(data.isAttacker) ? this.FRAME_ARROW_ATTACKER : this.FRAME_ARROW_DEFENDER);
         }
         else
         {
            myArrow.gotoAndStop(this.FRAME_ARROW_NEUTRAL);
         }
         this.myProgressBar.SetProgress(data.progress,false);
         this.myLabel.text = this.LABEL_ARRAY[data.id];
      }
      
      override public function setupScale(w:Number, h:Number) : void
      {
         scaleX = w / this.ICON_BASE_SIZE;
         scaleY = w / this.ICON_BASE_SIZE;
      }
      
      override public function setupAlpha(a:Number) : void
      {
         alpha = (Math.sin((a - 0.5) * Math.PI) + 1) * 0.5;
      }
   }
}

