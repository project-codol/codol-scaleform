package codo.views.motd_parts
{
   import codo.component.ScrollBar;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class MOTDFilterCategoryButtonScrollList extends MovieClip
   {
      
      public var myScrollBar:ScrollBar;
      
      public var mySpacer:Sprite;
      
      public var mySubCategoryMount:Sprite;
      
      private var mListMaxHeight:Number = 0;
      
      private var mHeight:Number = 0;
      
      public function MOTDFilterCategoryButtonScrollList()
      {
         var scrollBarSettings:Object = null;
         super();
         scrollBarSettings = new Object();
         scrollBarSettings.hitArea = this;
         scrollBarSettings.scrollCallback = this.onScroll;
         this.mySpacer.visible = false;
         this.myScrollBar.init(scrollBarSettings);
         this.myScrollBar.setPosition(0,false);
      }
      
      public function set listMaxHeight(h:Number) : void
      {
         this.mListMaxHeight = h;
         this.refreshScrollBar();
      }
      
      override public function set height(h:Number) : void
      {
         this.mHeight = h;
         this.refreshScrollBar();
      }
      
      private function refreshScrollBar() : void
      {
         this.myScrollBar.setBarLength(this.mListMaxHeight,this.mHeight);
         this.myScrollBar.setPosition(0,false);
         this.myScrollBar.visible = this.myScrollBar.enabled = this.mHeight > this.mListMaxHeight;
         this.myScrollBar.setEnabled(this.myScrollBar.enabled);
      }
      
      protected function onScroll(position:Number) : void
      {
         this.mySubCategoryMount.y = -(this.mySubCategoryMount.height - this.mListMaxHeight) * position;
      }
   }
}

