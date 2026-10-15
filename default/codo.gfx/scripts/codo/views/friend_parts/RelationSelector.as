package codo.views.friend_parts
{
   import codo.component.TextField;
   import codo.component.core.UIInteractiveComponent;
   import codo.interfaces.ISelectable;
   import codo.style.FriendGuide;
   import flash.display.MovieClip;
   
   public class RelationSelector extends UIInteractiveComponent implements ISelectable
   {
      
      private static const NORMAL_FRAME:int = 1;
      
      private static const FOCUS_FREAME:int = 2;
      
      private static const SELECTED_FRAME:int = 3;
      
      private static const LABEl_WIDTH:int = 350;
      
      public var myLabel:TextField;
      
      public var myBackground:MovieClip;
      
      private var mSelected:Boolean = false;
      
      public function RelationSelector()
      {
         super();
         isInteractiveEnabled = true;
         this.myLabel.textStyle = FriendGuide.styleRelationSelector;
         this.myLabel.width = LABEl_WIDTH;
      }
      
      override public function setData(data:*) : void
      {
         super.setData(data);
         if(data != null)
         {
            this.myLabel.text = data;
         }
      }
      
      public function get selected() : Boolean
      {
         return this.mSelected;
      }
      
      public function set selected(newSelected:Boolean) : void
      {
         if(this.mSelected == newSelected)
         {
            return;
         }
         this.mSelected = newSelected;
         if(newSelected)
         {
            this.myBackground.gotoAndStop(SELECTED_FRAME);
         }
         else
         {
            this.myBackground.gotoAndStop(NORMAL_FRAME);
         }
      }
      
      override public function get height() : Number
      {
         return this.myBackground.height;
      }
      
      override protected function onMouseOver() : void
      {
         super.onMouseOver();
         if(!this.mSelected)
         {
            this.myBackground.gotoAndStop(FOCUS_FREAME);
         }
      }
      
      override protected function onMouseOut() : void
      {
         super.onMouseOut();
         if(!this.mSelected)
         {
            this.myBackground.gotoAndStop(NORMAL_FRAME);
         }
      }
   }
}

