package codo.component.social
{
   import codo.component.CloseButton;
   import codo.component.core.UIInteractiveComponent;
   import codo.interfaces.ISelectable;
   import flash.display.MovieClip;
   
   public class ClanTagButton extends UIInteractiveComponent implements ISelectable
   {
      
      public var myCloseBtn:CloseButton;
      
      public var myTag:ClanTag;
      
      public var myFeatured:MovieClip;
      
      private var mOnClickFunction:Function;
      
      public function ClanTagButton()
      {
         super();
         this.selected = false;
         isInteractiveEnabled = true;
         this.myCloseBtn.setClickCallback(this.InvokeClickFunction);
         setClickCallback(this.InvokeClickFunction);
      }
      
      public function setupByRow(row:int) : void
      {
         this.myTag.setTagIDByRow(row);
         this.UpdateFeaturedColor();
      }
      
      public function set id(idVal:int) : void
      {
         this.myTag.id = idVal;
         this.UpdateFeaturedColor();
      }
      
      public function get id() : int
      {
         return this.myTag.id;
      }
      
      public function set onClickFunction(func:Function) : void
      {
         this.mOnClickFunction = func;
      }
      
      public function get selected() : Boolean
      {
         return this.myFeatured.visible;
      }
      
      public function set selected(newSelected:Boolean) : void
      {
         this.myFeatured.visible = newSelected;
      }
      
      private function InvokeClickFunction() : void
      {
         if(this.mOnClickFunction != null)
         {
            this.mOnClickFunction(this.myTag.id);
         }
      }
      
      private function UpdateFeaturedColor() : void
      {
         gotoAndStop(this.myTag.colorIndex);
         this.myFeatured = getChildByName("myFeatured") as MovieClip;
      }
   }
}

