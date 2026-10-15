package codo.component.lobby
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class LobbyRoomSizeDetails extends MovieClip
   {
      
      public var myCurrentPlayerCountTF:TextField;
      
      public var myMaxPlayerCountTF:TextField;
      
      public function LobbyRoomSizeDetails()
      {
         super();
      }
      
      public function update(currentPlayerCount:int, maxPlayerCount:int) : void
      {
         this.myCurrentPlayerCountTF.text = currentPlayerCount.toString();
         this.myMaxPlayerCountTF.text = maxPlayerCount.toString();
      }
   }
}

