package codo.component.lobby
{
   import codo.localization.DictRoom;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class LobbyStartButton extends LobbyMainButton
   {
      
      public var myCheckbox:MovieClip;
      
      public var myReadyLabel:TextField;
      
      public function LobbyStartButton()
      {
         super();
         myLabel.text = DictRoom.SET_READY;
         this.myReadyLabel.text = DictRoom.READY;
         this.switchReady(false);
      }
      
      public function switchTester(isTester:Boolean) : void
      {
         if(isTester)
         {
            myLabel.text = DictRoom.FORCE_START_MATCH;
         }
         else
         {
            myLabel.text = DictRoom.SET_READY;
         }
      }
      
      public function switchReady(isReady:Boolean) : void
      {
         if(isReady)
         {
            this.myCheckbox.visible = true;
            this.myReadyLabel.visible = true;
            myLabel.visible = false;
         }
         else
         {
            this.myCheckbox.visible = false;
            this.myReadyLabel.visible = false;
            myLabel.visible = true;
         }
      }
   }
}

