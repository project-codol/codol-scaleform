package codo.component.lobby
{
   import codo.base.BaseSubElement;
   import codo.constants.BCEvent;
   import codo.constants.DataID;
   import codo.event.ParaEvent;
   import codo.objects.RoomMemberObj;
   
   public class LobbyScenePlayerNames extends BaseSubElement
   {
      
      private static const UNSELECTED_FRAME:int = 1;
      
      private static const MOUSE_OVER_FRAME:int = 2;
      
      private static const MOUSE_DOWN_FRAME:int = 3;
      
      private static const SELECTED_FRAME:int = 4;
      
      private static const LOCAL_PLAYER_FRAME:int = 5;
      
      private const MAX_DISPLAYED_PLAYERS:int = 9;
      
      private const CHILD_PREFIX_PLAYER_NAME:String = "myPlayerName";
      
      public var myPlayerName0:LobbyScenePlayerName;
      
      public var myPlayerName1:LobbyScenePlayerName;
      
      public var myPlayerName2:LobbyScenePlayerName;
      
      public var myPlayerName3:LobbyScenePlayerName;
      
      public var myPlayerName4:LobbyScenePlayerName;
      
      public var myPlayerName5:LobbyScenePlayerName;
      
      public var myPlayerName6:LobbyScenePlayerName;
      
      public var myPlayerName7:LobbyScenePlayerName;
      
      public var myPlayerName8:LobbyScenePlayerName;
      
      private var currentSelectedPlayer:RoomMemberObj;
      
      public function LobbyScenePlayerNames()
      {
         super();
         listen(BCEvent.LOBBY_SET_PLAYER_NAMES,this.onLobbySetPlayerNames);
         bind(DataID.CURRENTLY_SELECTED_TEAM_MEMBER,this.bind_onSetCurrentlySelectedTeamMember);
      }
      
      private function onLobbySetPlayerNames(parameterEvent:ParaEvent) : void
      {
         var playerNames:Array = null;
         var i:int = 0;
         var myPlayerName:LobbyScenePlayerName = null;
         playerNames = parameterEvent.myPara;
         if(playerNames == null)
         {
            return;
         }
         for(i = 0; i < this.MAX_DISPLAYED_PLAYERS; i++)
         {
            myPlayerName = this[this.CHILD_PREFIX_PLAYER_NAME + i];
            if(myPlayerName != null)
            {
               myPlayerName.visible = i < playerNames.length && playerNames[i] != null;
               if(myPlayerName.visible)
               {
                  myPlayerName.x = playerNames[i].x;
                  myPlayerName.y = playerNames[i].y;
                  if(i == 0)
                  {
                     myPlayerName.gotoAndStop(LOCAL_PLAYER_FRAME);
                  }
                  else if(Boolean(this.currentSelectedPlayer) && playerNames[i].client == this.currentSelectedPlayer.name)
                  {
                     myPlayerName.gotoAndStop(SELECTED_FRAME);
                  }
                  else
                  {
                     myPlayerName.gotoAndStop(UNSELECTED_FRAME);
                  }
                  myPlayerName.setClientName(playerNames[i].client);
               }
            }
         }
      }
      
      private function bind_onSetCurrentlySelectedTeamMember(cRes:Object) : void
      {
         var selectedTeamMemberID:String = cRes.data;
         var roomMemberObj:RoomMemberObj = getDP(DataID.ROOM_MEMBER_OBJ_BY_ID,[selectedTeamMemberID]);
         if(roomMemberObj == null)
         {
            return;
         }
         this.currentSelectedPlayer = roomMemberObj;
      }
   }
}

