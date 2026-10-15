package codo.views.leaderboard_sub.selection_sub
{
   import codo.component.TextField;
   import codo.component.core.UIInteractiveComponent;
   import codo.interfaces.ISelectable;
   import codo.style.LeaderBoardGuide;
   import codo.utils.CursorUtil;
   import flash.display.MovieClip;
   
   public class LeaderBoardModeItem extends UIInteractiveComponent implements ISelectable
   {
      
      public var myLabel:TextField;
      
      public var myBackground:MovieClip;
      
      public var myFocusBackground:MovieClip;
      
      public var mySelectedBackground:MovieClip;
      
      protected var mSelected:Boolean = false;
      
      public function LeaderBoardModeItem()
      {
         super();
         isInteractiveEnabled = true;
         this.myLabel.textStyle = LeaderBoardGuide.styleModeButton;
         this.myBackground.visible = true;
         this.myFocusBackground.visible = false;
         this.mySelectedBackground.visible = false;
      }
      
      override protected function onMouseOver() : void
      {
         super.onMouseOver();
         CursorUtil.BeginCursor(CursorUtil.CURSOR_OVER_BUTTON);
         if(!this.mSelected)
         {
            this.myBackground.visible = false;
            this.myFocusBackground.visible = true;
         }
      }
      
      override protected function onMouseOut() : void
      {
         super.onMouseOut();
         CursorUtil.EndCursor(CursorUtil.CURSOR_OVER_BUTTON);
         if(!this.mSelected)
         {
            this.myBackground.visible = true;
            this.myFocusBackground.visible = false;
         }
      }
      
      public function set selected(sel:Boolean) : void
      {
         this.mSelected = sel;
         if(this.mSelected)
         {
            this.myBackground.visible = false;
            this.myFocusBackground.visible = false;
            this.mySelectedBackground.visible = true;
         }
         else
         {
            this.myBackground.visible = true;
            this.myFocusBackground.visible = false;
            this.mySelectedBackground.visible = false;
         }
      }
      
      public function get selected() : Boolean
      {
         return this.mSelected;
      }
      
      override public function setData(data:*) : void
      {
         super.setData(data);
         if(data == null)
         {
            return;
         }
         this.myLabel.text = data.name;
      }
   }
}

