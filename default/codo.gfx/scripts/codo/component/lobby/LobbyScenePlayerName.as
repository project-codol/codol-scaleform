package codo.component.lobby
{
   import codo.base.BaseSubElement;
   import flash.text.TextField;
   
   public class LobbyScenePlayerName extends BaseSubElement
   {
      
      public var myClientName:TextField;
      
      public var myCharacterName:TextField;
      
      public function LobbyScenePlayerName()
      {
         super();
      }
      
      public function setClientName(clientName:String) : void
      {
         this.myClientName.text = clientName;
      }
   }
}

