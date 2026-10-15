package codo.component.social
{
   import codo.component.Button;
   import flash.display.MovieClip;
   
   public class SocialHamburgerButton extends Button
   {
      
      public var myTab:MovieClip;
      
      private var mShowHamburgerButtonClickedHandler:Function;
      
      public function SocialHamburgerButton()
      {
         super();
         this.hasNoLabel = true;
         this.myTab.gotoAndStop(mUpStateFrame);
         registerClickEvent(this.onClickHanlder,this);
      }
      
      public function setShowHamburgerButtonClickedHandler(handler:Function) : void
      {
         this.mShowHamburgerButtonClickedHandler = handler;
      }
      
      override public function setData(data:*) : void
      {
         super.setData(data);
      }
      
      override public function setToggled(toggled:Boolean) : void
      {
         super.setToggled(toggled);
         if(toggled)
         {
            this.myTab.gotoAndStop(OVER_STATE_FRAME);
         }
         else
         {
            this.myTab.gotoAndStop(mUpStateFrame);
         }
      }
      
      override protected function showHighlight() : void
      {
         super.showHighlight();
         this.myTab.gotoAndStop(OVER_STATE_FRAME);
      }
      
      override protected function endHighlight() : void
      {
         super.endHighlight();
         this.myTab.gotoAndStop(mUpStateFrame);
      }
      
      override protected function showClickState() : void
      {
         super.showClickState();
         this.myTab.gotoAndStop(DOWN_STATE_FRAME);
      }
      
      private function onClickHanlder(data:*) : void
      {
         if(this.mShowHamburgerButtonClickedHandler != null)
         {
            this.mShowHamburgerButtonClickedHandler(this);
         }
      }
   }
}

