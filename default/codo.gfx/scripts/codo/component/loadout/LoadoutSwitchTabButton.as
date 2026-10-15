package codo.component.loadout
{
   import codo.component.core.UIInteractiveComponent;
   import codo.cpp.UiCppNewItems;
   import codo.interfaces.ISelectable;
   import codo.style.GlobalGuide;
   import codo.utils.CursorUtil;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class LoadoutSwitchTabButton extends UIInteractiveComponent implements ISelectable
   {
      
      public var myLabel:TextField;
      
      public var myBackground:MovieClip;
      
      private var mSelected:Boolean;
      
      private var mIsMouseOver:Boolean;
      
      private var mIndex:int;
      
      private var mTabSelectedCallback:Function;
      
      public function LoadoutSwitchTabButton()
      {
         super();
         isInteractiveEnabled = true;
         if(Boolean(this.myBackground))
         {
            this.myBackground.gotoAndStop(1);
         }
         this.mSelected = false;
         this.mIsMouseOver = false;
         this.mIndex = 0;
         this.updateFrame();
      }
      
      public function set label(s:String) : void
      {
         this.myLabel.text = s;
      }
      
      public function set index(index:int) : void
      {
         this.mIndex = index;
      }
      
      public function set tabSelectedCallback(callback:Function) : void
      {
         this.mTabSelectedCallback = callback;
      }
      
      public function get selected() : Boolean
      {
         return this.mSelected;
      }
      
      public function set selected(newSelected:Boolean) : void
      {
         this.mSelected = newSelected;
         this.updateFrame();
      }
      
      override protected function onMouseOver() : void
      {
         CursorUtil.BeginCursor(CursorUtil.CURSOR_OVER_BUTTON);
         this.mIsMouseOver = true;
         this.updateFrame();
      }
      
      override protected function onMouseOut() : void
      {
         CursorUtil.EndCursor(CursorUtil.CURSOR_OVER_BUTTON);
         this.mIsMouseOver = false;
         this.updateFrame();
      }
      
      override protected function onMouseClickUp() : void
      {
         if(myHitArea.hitTestPoint(stage.mouseX,stage.mouseY))
         {
            this.selected = true;
            if(this.mTabSelectedCallback != null)
            {
               this.mTabSelectedCallback(this.mIndex);
            }
         }
      }
      
      protected function updateFrame() : void
      {
         if(this.mSelected)
         {
            if(Boolean(this.myBackground))
            {
               this.myBackground.gotoAndStop(2);
            }
            this.myLabel.textColor = GlobalGuide.WHITE;
            this.myLabel.alpha = 1;
         }
         else
         {
            this.myLabel.textColor = GlobalGuide.CODO_BLUE_LIGHT;
            if(Boolean(this.myBackground))
            {
               this.myBackground.gotoAndStop(1);
            }
            if(this.mIsMouseOver)
            {
               this.myLabel.alpha = 1;
            }
            else
            {
               this.myLabel.alpha = 0.5;
            }
         }
      }
      
      public function setBreadcrumb(breadcrumb:int) : void
      {
         UiCppNewItems.instance.InitBreadcrumb(this,breadcrumb);
         getBreadcrumb().scaleX = 1 / scaleX;
         getBreadcrumb().scaleY = 1 / scaleY;
      }
   }
}

