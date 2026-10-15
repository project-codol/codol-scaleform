package codo.component.lobby
{
   import codo.component.Button;
   import codo.style.TextStyle;
   
   public class LobbyOptionsTabNavigation extends Button
   {
      
      private static const SELECTED_STATE_FRAME:int = 4;
      
      public function LobbyOptionsTabNavigation()
      {
         super();
      }
      
      override public function setData(data:*) : void
      {
         super.setData(data);
      }
      
      override public function draw() : void
      {
         super.draw();
         myLabel.x = 10;
         myLabel.alignment = TextStyle.HALIGN_LEFT;
      }
      
      override protected function onMouseClickUp() : void
      {
         if(shouldShowHighlight() && myBackground != null)
         {
            if(myHitArea.hitTestPoint(stage.mouseX,stage.mouseY) == false)
            {
               myBackground.gotoAndStop(mUpStateFrame);
            }
            else
            {
               myBackground.gotoAndStop(SELECTED_STATE_FRAME);
            }
         }
      }
      
      override public function setToggled(toggled:Boolean) : void
      {
         super.setToggled(toggled);
         if(toggled)
         {
            if(myBackground != null)
            {
               myBackground.gotoAndStop(SELECTED_STATE_FRAME);
            }
         }
      }
   }
}

