package components.fsggamemodes_part
{
   import codo.localization.Dict;
   import codo.utils.LocalizeUtil;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.text.TextField;
   import fsg.shared.BehaviourAudio;
   import fsg.shared.BehaviourClickable;
   import scaleform.gfx.TextFieldEx;
   
   public class GameModesTutorialButton extends MovieClip
   {
      
      private static const FRAME_OUT:uint = 1;
      
      private static const FRAME_OVER:uint = 2;
      
      private var mClickable:BehaviourClickable;
      
      private var mAudio:BehaviourAudio;
      
      public var myHitArea:MovieClip;
      
      public var myTF:TextField;
      
      public var myBkg:Sprite;
      
      public var myGlow:Sprite;
      
      public function GameModesTutorialButton()
      {
         super();
         TextFieldEx.setVerticalAlign(this.myTF,TextFieldEx.VALIGN_CENTER);
         this.myTF.text = LocalizeUtil.localize(Dict.GAME_SUMMARY_BUTTON_LABLE_INFO);
         this.mClickable = new BehaviourClickable(this.myHitArea);
         this.mClickable.addMouseOverCallback(this.onMouseOver);
         this.mClickable.addMouseOutCallback(this.onMouseOut);
         this.mAudio = new BehaviourAudio(this.mClickable);
      }
      
      private function onMouseOver() : void
      {
         gotoAndStop(FRAME_OVER);
      }
      
      private function onMouseOut() : void
      {
         gotoAndStop(FRAME_OUT);
      }
      
      private function onClick() : void
      {
         gotoAndStop(FRAME_OUT);
      }
      
      public function set clickCallback(callback:Function) : void
      {
         this.mClickable.addClickCallback(this.onClick);
         this.mClickable.addClickCallback(callback);
      }
   }
}

