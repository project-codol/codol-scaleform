package codo.component.lobby
{
   import codo.component.TextField;
   import codo.component.core.UIInteractiveComponent;
   import flash.display.MovieClip;
   
   public class LobbyVoteButton extends UIInteractiveComponent
   {
      
      public var myVoteButtonFrame:MovieClip;
      
      public var myVoteText0:TextField;
      
      public var myTextField0:TextField;
      
      public var votingType:int;
      
      private var mToggled:Boolean = false;
      
      private var mVoteCallback:Function = null;
      
      public function LobbyVoteButton()
      {
         super();
         isInteractiveEnabled = true;
      }
      
      public function set toggled(value:Boolean) : void
      {
         this.mToggled = value;
         if(this.mToggled)
         {
            gotoAndStop("Selected");
         }
         else
         {
            gotoAndStop("Normal");
         }
      }
      
      override protected function onMouseOver() : void
      {
         super.onMouseOver();
         if(!this.mToggled)
         {
            gotoAndStop("Mouseover");
         }
      }
      
      override protected function onMouseOut() : void
      {
         super.onMouseOut();
         if(this.mToggled)
         {
            gotoAndStop("Selected");
         }
         else
         {
            gotoAndStop("Normal");
         }
      }
      
      public function setVoteCallback(f:Function) : void
      {
         this.mVoteCallback = f;
      }
      
      override protected function onMouseClick() : void
      {
         super.onMouseClick();
         if(!this.mToggled)
         {
            gotoAndStop("Mousedown");
            this.mToggled = true;
            if(this.mVoteCallback != null)
            {
               this.mVoteCallback(this.votingType);
            }
         }
      }
      
      override protected function onMouseClickUp() : void
      {
         super.onMouseClickUp();
         if(this.mToggled)
         {
            gotoAndStop("Selected");
         }
         else
         {
            gotoAndStop("Normal");
         }
      }
   }
}

