package codo.views.hud.robbery
{
   import codo.constants.HUDComponentTypes;
   import codo.views.hud.HUDComponent;
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class HUDObtainGoldHint extends HUDComponent
   {
      
      private const TICK_TEXT_WIDTH:Number = 78;
      
      private const LABEL_POSITION_NO_ICON:Number = 176;
      
      private const LABEL_POSITION_WITH_ICON:Number = 110;
      
      private const WARNING_ICON_MARGIN:Number = 4;
      
      private const LABEL_MARGIN:Number = 4;
      
      public var myTick:MovieClip;
      
      public var myLabel:TextField;
      
      public var myIcon:MovieClip;
      
      public var myBg:MovieClip;
      
      public var myWarningIcon:MovieClip;
      
      private var myTween:TweenLite;
      
      public function HUDObtainGoldHint()
      {
         super();
      }
      
      override public function get CompType() : int
      {
         return HUDComponentTypes.ROBBERY_OBTAIN_GOLD_HINT;
      }
      
      public function updateGoldValue(val:int, doAnim:Boolean) : void
      {
         if(val == 0)
         {
            alpha = 0;
            return;
         }
         this.myTick.myTickText.visible = doAnim;
         if(Boolean(this.myTick.myTickText.visible))
         {
            this.myTick.myTickText.myText.text = this.myTick.myGold.text;
            this.myTick.gotoAndPlay(1);
         }
         this.myTick.myGold.text = "$" + val;
         alpha = 1;
      }
      
      public function fadeOutHint() : void
      {
         this.tryKillTween();
         this.myTween = TweenLite.to(this,0.5,{
            "delay":1,
            "alpha":0,
            "onComplete":this.onTweenComplete
         });
      }
      
      public function setupHint(label:String, warningType:int, showIcon:Boolean) : void
      {
         var nextPosX:Number = NaN;
         this.myIcon.visible = showIcon;
         this.myWarningIcon.visible = warningType != 0;
         this.myLabel.text = label;
         var labelPositionY:Number = showIcon ? this.LABEL_POSITION_WITH_ICON : this.LABEL_POSITION_NO_ICON;
         this.myBg.y = this.myWarningIcon.y = this.myLabel.y = this.myTick.y = labelPositionY;
         var totalWidth:Number = (this.myWarningIcon.visible ? this.myWarningIcon.width + this.WARNING_ICON_MARGIN : 0) + this.LABEL_MARGIN + this.myLabel.textWidth + this.TICK_TEXT_WIDTH;
         nextPosX = -0.5 * totalWidth;
         this.myBg.width = totalWidth;
         this.myBg.x = nextPosX;
         if(this.myWarningIcon.visible)
         {
            this.myWarningIcon.gotoAndStop(warningType);
            nextPosX += this.WARNING_ICON_MARGIN;
            this.myWarningIcon.x = nextPosX;
            nextPosX += this.myWarningIcon.width;
         }
         nextPosX += this.LABEL_MARGIN;
         this.myLabel.x = nextPosX;
         nextPosX += this.myLabel.textWidth;
         this.myTick.x = nextPosX;
         this.tryKillTween();
      }
      
      private function tryKillTween() : void
      {
         if(this.myTween != null)
         {
            this.myTween.kill();
            this.onTweenComplete();
         }
      }
      
      private function onTweenComplete() : void
      {
         this.myTween = null;
      }
   }
}

