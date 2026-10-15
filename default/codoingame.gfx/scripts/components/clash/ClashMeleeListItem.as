package components.clash
{
   import codo.component.TextField;
   import codo.component.core.UIInteractiveComponent;
   import codo.interfaces.ISelectable;
   import codo.style.GlobalGuide;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class ClashMeleeListItem extends UIInteractiveComponent implements ISelectable
   {
      
      protected var mSelected:Boolean = false;
      
      public var myBackground:MovieClip;
      
      public var myLockIcon:Sprite;
      
      public var myLabel:TextField;
      
      public function ClashMeleeListItem()
      {
         super();
         isInteractiveEnabled = true;
         this.myLabel.fontSize = GlobalGuide.FONT_SIZE_EXTRA_SMALL;
         this.myLabel.font = GlobalGuide.FONT_FACE_MEDIUM;
         this.myLabel.multiline = false;
         this.myLabel.width = 190;
         this.myBackground.gotoAndStop(1);
      }
      
      override protected function onMouseOver() : void
      {
         super.onMouseOver();
         if(!this.mSelected)
         {
            this.myBackground.gotoAndStop(2);
         }
      }
      
      override protected function onMouseOut() : void
      {
         super.onMouseOut();
         if(!this.mSelected)
         {
            this.myBackground.gotoAndStop(1);
         }
      }
      
      public function set selected(sel:Boolean) : void
      {
         this.mSelected = sel;
         if(this.mSelected)
         {
            this.myBackground.gotoAndStop(3);
         }
         else
         {
            this.myBackground.gotoAndStop(1);
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
            visible = false;
            return;
         }
         this.myLabel.text = data.name;
         this.myLockIcon.visible = data.locked;
      }
   }
}

