package codo.component
{
   import codo.component.core.UIInteractiveComponent;
   import codo.style.SocialGuide;
   import flash.display.MovieClip;
   
   public class LeaderboardToggleButton extends UIInteractiveComponent
   {
      
      public var myLabel:TextField;
      
      public var myTabDivisor:MovieClip;
      
      private var mActive:Boolean;
      
      public function LeaderboardToggleButton()
      {
         super();
         this.isInteractiveEnabled = true;
         this.setActive(false);
      }
      
      override protected function onMouseOver() : void
      {
         super.onMouseOver();
         if(!this.mActive)
         {
            this.myLabel.textStyle = SocialGuide.styleLeaderboardToggleButtonMouseHover;
         }
      }
      
      override protected function onMouseOut() : void
      {
         super.onMouseOut();
         if(!this.mActive)
         {
            this.myLabel.textStyle = SocialGuide.styleLeaderboardToggleButtonInactive;
         }
      }
      
      public function setActive(active:Boolean) : void
      {
         this.mActive = active;
         if(active)
         {
            this.myLabel.textStyle = SocialGuide.styleLeaderboardToggleButtonActive;
         }
         else
         {
            this.myLabel.textStyle = SocialGuide.styleLeaderboardToggleButtonInactive;
         }
      }
      
      public function getActive() : Boolean
      {
         return this.mActive;
      }
      
      public function set text(txt:String) : void
      {
         this.myLabel.text = txt;
      }
      
      public function get text() : String
      {
         return this.myLabel.text;
      }
      
      public function setWidth(value:int) : void
      {
         this.myLabel.width = value;
         myHitArea.width = value;
      }
      
      public function getWidth() : int
      {
         return this.myLabel.width;
      }
      
      public function showTabDivisor(bShow:Boolean) : void
      {
         this.myTabDivisor.visible = bShow;
      }
   }
}

