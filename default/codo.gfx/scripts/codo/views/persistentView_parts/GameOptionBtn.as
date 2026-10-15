package codo.views.persistentView_parts
{
   import codo.style.GlobalGuide;
   import codo.utils.CursorUtil;
   import flash.display.Sprite;
   import fsg.shared.BehaviourAudio;
   import fsg.shared.BehaviourClickable;
   
   public class GameOptionBtn extends Sprite
   {
      
      public var myHitArea:Sprite;
      
      private var mClickable:BehaviourClickable;
      
      private var mAudio:BehaviourAudio;
      
      public function GameOptionBtn()
      {
         super();
         alpha = GlobalGuide.UNFOCUS_ALPHA;
         this.mClickable = new BehaviourClickable(this.myHitArea);
         this.mClickable.addMouseOverCallback(this.onMouseOver);
         this.mClickable.addMouseOutCallback(this.onMouseOut);
         this.mAudio = new BehaviourAudio(this.mClickable);
      }
      
      public function addClickCallback(callback:Function, clickAudio:String = null) : void
      {
         this.mClickable.addClickCallback(callback);
         if(clickAudio != null)
         {
            this.mAudio.overrideClickAudio(clickAudio);
         }
      }
      
      protected function onMouseOver() : void
      {
         CursorUtil.BeginCursor(CursorUtil.CURSOR_OVER_BUTTON);
         GlobalGuide.TOGGLE_ITEM_FOCUS(this,true);
      }
      
      protected function onMouseOut() : void
      {
         CursorUtil.EndCursor(CursorUtil.CURSOR_OVER_BUTTON);
         GlobalGuide.TOGGLE_ITEM_FOCUS(this,false);
      }
   }
}

