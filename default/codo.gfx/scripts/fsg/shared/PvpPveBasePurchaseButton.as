package fsg.shared
{
   import codo.utils.ScaleformUtil;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import fsg.util.FsgImageHolder;
   import scaleform.gfx.TextFieldEx;
   
   public class PvpPveBasePurchaseButton extends Sprite
   {
      
      private static const FRAME_MOUSEOVER:uint = 2;
      
      private static const FRAME_MOUSEOUT:uint = 1;
      
      public var myTextTF:TextField;
      
      public var myHitArea:Sprite;
      
      public var myIconHolder:FsgImageHolder;
      
      public var myWarningIcon:MovieClip;
      
      public var myBkg:MovieClip;
      
      private var mClickable:BehaviourClickable;
      
      private var mAudio:BehaviourAudio;
      
      public function PvpPveBasePurchaseButton()
      {
         super();
         this.mClickable = new BehaviourClickable(this.myHitArea);
         this.mClickable.addMouseOverCallback(this.onMouseOver);
         this.mClickable.addMouseOutCallback(this.onMouseOut);
         this.mAudio = new BehaviourAudio(this.mClickable);
         this.myTextTF.autoSize = TextFieldAutoSize.LEFT;
         TextFieldEx.setVerticalAlign(this.myTextTF,TextFieldEx.VALIGN_CENTER);
         this.setMarketReadyMode(false);
      }
      
      public function setModeToNonInteractive() : void
      {
         this.mClickable.setEnabled(false);
         this.myBkg.visible = this.myHitArea.visible = false;
         this.setMarketReadyMode(true);
      }
      
      protected function onMouseOver() : void
      {
         this.myTextTF.textColor = 0;
         this.myBkg.gotoAndStop(FRAME_MOUSEOVER);
      }
      
      protected function onMouseOut() : void
      {
         this.myTextTF.textColor = 16777215;
         this.myBkg.gotoAndStop(FRAME_MOUSEOUT);
      }
      
      public function setImage(image:String) : void
      {
         if(!ScaleformUtil.isScaleform)
         {
            return;
         }
         this.myIconHolder.setImage(image);
      }
      
      public function setMarketReadyMode(isReady:Boolean) : void
      {
         this.mClickable.setEnabled(isReady);
         this.myWarningIcon.visible = !isReady;
         this.myTextTF.alpha = isReady ? 1 : 0.2;
      }
      
      public function addClickCallback(callback:Function) : void
      {
         this.mClickable.addClickCallback(callback);
      }
   }
}

