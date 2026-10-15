package components.fsgpersistent_part
{
   import codo.constants.SE_ID;
   import codo.localization.Dict;
   import codo.utils.LocalizeUtil;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.text.TextField;
   import fsg.shared.BehaviourAudio;
   import fsg.shared.BehaviourClickable;
   
   public class QtCrateButton extends MovieClip
   {
      
      private static const FRAME_LABEL_START:String = "start";
      
      private static const FRAME_LABEL_ROLLOVER:String = "rollover";
      
      private static const FRAME_LABEL_ROLLOUT:String = "rollout";
      
      public var myHitArea:Sprite;
      
      public var myButtonLabelTF:TextField;
      
      public var crate_open:Sprite;
      
      private var mClickable:BehaviourClickable;
      
      private var mAudio:BehaviourAudio;
      
      private var mCrateButtonCallback:Function;
      
      public function QtCrateButton()
      {
         super();
         this.myButtonLabelTF.text = LocalizeUtil.localize(Dict.MAIN_MENU_LABEL_RARE_ITEM_CRATE_BTN);
         this.myHitArea.x = this.myButtonLabelTF.x;
         this.myHitArea.width = Math.max(this.myButtonLabelTF.textWidth,this.myHitArea.width);
         this.mClickable = new BehaviourClickable(this.myHitArea);
         this.mClickable.addClickCallback(this.onQTCrateButtonClick);
         this.mClickable.addMouseOverCallback(this.onQTCrateButtonRollOver);
         this.mClickable.addMouseOutCallback(this.onQTCrateButtonRollOut);
         this.mAudio = new BehaviourAudio(this.mClickable,SE_ID.UI_SOCIALPANEL_ROLLOVER,SE_ID.UI_SOCIALPANEL_OPEN);
         this.crate_open.mouseEnabled = false;
      }
      
      public function set label(l:String) : void
      {
         this.myButtonLabelTF.text = l;
      }
      
      public function set crateButtonCallback(callback:Function) : void
      {
         this.mCrateButtonCallback = callback;
      }
      
      private function onQTCrateButtonClick() : void
      {
         gotoAndPlay(FRAME_LABEL_START);
         if(this.mCrateButtonCallback != null)
         {
            this.mCrateButtonCallback(this);
         }
      }
      
      private function onQTCrateButtonRollOver() : void
      {
         gotoAndPlay(FRAME_LABEL_ROLLOVER);
      }
      
      private function onQTCrateButtonRollOut() : void
      {
         gotoAndPlay(FRAME_LABEL_ROLLOUT);
      }
   }
}

