package components.fsgpersistent_part
{
   import codo.localization.DictMarket;
   import flash.display.MovieClip;
   import fsg.shared.BarDialogButton;
   import fsg.shared.BehaviourAnimatedClickable;
   import fsg.shared.BehaviourAudio;
   import fsg.shared.BehaviourClickable;
   
   public class FsgDropdownMenuItem extends BarDialogButton
   {
      
      private static const UP_STATE_FRAME:int = 1;
      
      private static const OVER_STATE_FRAME:int = 2;
      
      private static const DOWN_STATE_FRAME:int = 1;
      
      private static const DISABLED_STATE_FRAME:int = 3;
      
      public var myNewTag:MovieClip;
      
      private var m_optionIndex:int = 0;
      
      public function FsgDropdownMenuItem()
      {
         super();
         m_clickable = new BehaviourClickable(myHitArea);
         m_animated = new BehaviourAnimatedClickable(this,m_clickable,UP_STATE_FRAME,OVER_STATE_FRAME,DOWN_STATE_FRAME,DISABLED_STATE_FRAME);
         m_audio = new BehaviourAudio(m_clickable,"ui_general_rollover","ui_general_proceed");
         this.isNew = false;
      }
      
      public function set isNew(mState:Boolean) : void
      {
         if(this.myNewTag != null)
         {
            this.myNewTag.gotoAndStop(1);
            this.myNewTag.myNewText.myTextTF.text = DictMarket.MARKETPLACE_NEW_ITEM;
            this.myNewTag.visible = mState;
            this.myNewTag.gotoAndPlay(2);
         }
      }
      
      public function set optionIndex(index:int) : void
      {
         this.m_optionIndex = index;
      }
      
      public function get optionIndex() : int
      {
         return this.m_optionIndex;
      }
      
      public function get isNew() : Boolean
      {
         if(this.myNewTag != null)
         {
            return this.myNewTag.visible;
         }
         return false;
      }
   }
}

