package components.fsggamemodes_part.pve
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import fsg.shared.BehaviourAudio;
   import fsg.shared.BehaviourClickable;
   
   public class PveViewRandomRewardButton extends Sprite
   {
      
      public var myIcon:Sprite;
      
      public var myAnim:PveViewRandomRewardBox;
      
      public var myHitBox:MovieClip;
      
      private var mClickable:BehaviourClickable;
      
      private var mAudio:BehaviourAudio;
      
      public function PveViewRandomRewardButton()
      {
         super();
         this.mClickable = new BehaviourClickable(this.myHitBox);
         this.mClickable.addMouseOverCallback(this.onMouseOver);
         this.mClickable.addMouseOutCallback(this.onMouseOut);
         this.mAudio = new BehaviourAudio(this.mClickable);
         this.setMarketReadyMode(false);
      }
      
      public function addClickCallback(callback:Function) : void
      {
         this.mClickable.addClickCallback(callback);
      }
      
      private function onMouseOver() : void
      {
         this.myAnim.gotoAndPlay("shake");
      }
      
      private function onMouseOut() : void
      {
      }
      
      public function setMarketReadyMode(isReady:Boolean) : void
      {
         var DISABLED_ALPHA:Number = 0.5;
         this.mClickable.setEnabled(isReady);
         this.myIcon.visible = !isReady;
         if(isReady)
         {
            this.myAnim.gotoAndPlay("loop");
         }
         else
         {
            this.myAnim.gotoAndStop("loop");
         }
      }
   }
}

