package codo.component.playercard
{
   import codo.base.BaseSubElement;
   import codo.common.CFunctionCommonContainer;
   import codo.component.PlayerCard;
   import codo.constants.BCEvent;
   import codo.event.ParaEvent;
   import codo.objects.RoomMemberObj;
   import codo.utils.ScaleformUtil;
   import codo.utils.StringUtil;
   import components.fsgpersistent_part.FsgPlayerCardPrivileges;
   import fsg.util.FsgUtil;
   
   public class PlayerCard_Lobby extends BaseSubElement
   {
      
      public var myPlayerCard:PlayerCard;
      
      public var myPlayerPrivileges:FsgPlayerCardPrivileges;
      
      private var m_netcafe:int;
      
      private var m_qq_membership:int;
      
      private var m_curTeamMemberObj:RoomMemberObj;
      
      public function PlayerCard_Lobby()
      {
         super();
      }
      
      override public function active() : void
      {
         var privileges:Object = CFunctionCommonContainer.GetPlayerPrivileges();
         if(privileges != null)
         {
            this.m_qq_membership = privileges.qq_membership;
            this.m_netcafe = privileges.netcafe;
            this.myPlayerPrivileges.visible = true;
         }
         else
         {
            this.myPlayerPrivileges.visible = false;
         }
         if(this.m_curTeamMemberObj == null)
         {
            visible = false;
         }
         listen(BCEvent.EVT_CALLSIGN_REFRESH,this.onCallsignRefreshHandle);
         if(true == ScaleformUtil.isScaleform)
         {
            if(false == CFunctionCommonContainer.IsInGame())
            {
               listen(BCEvent.EVT_SELECTED_MEMBER_MAYBE_CHANGED,this.onSelectedMemberMaybeChanged);
            }
         }
      }
      
      override public function deactive() : void
      {
         unlisten(BCEvent.EVT_CALLSIGN_REFRESH,this.onCallsignRefreshHandle);
         unlisten(BCEvent.EVT_SELECTED_MEMBER_MAYBE_CHANGED,this.onSelectedMemberMaybeChanged);
      }
      
      private function handlePrestige(iNum:int) : void
      {
         var prestigeIcon:String = "";
         var prestigeStr:String = "";
         if(iNum > 0)
         {
            prestigeIcon = FsgUtil.getPrestigeIcon(iNum);
            prestigeStr = iNum.toString();
         }
         this.myPlayerCard.setPrestigeIcon(prestigeIcon);
         this.myPlayerCard.setPrestige(prestigeStr);
      }
      
      public function setPlayerCardData(player:RoomMemberObj, currentLevel:String, prestige:uint, wargodScore:int) : void
      {
         if(player != null)
         {
            if(player.name != null)
            {
               this.myPlayerCard.setName(StringUtil.addTag(player.clanTag,player.name));
            }
            else
            {
               this.myPlayerCard.setName("");
            }
            if(player.clanName != null)
            {
               this.myPlayerCard.setClanName(player.clanName);
            }
            else
            {
               this.myPlayerCard.setClanName("");
            }
            if(this.myPlayerPrivileges.visible == true)
            {
               this.myPlayerPrivileges.showPlayerPrivileges(this.m_qq_membership,this.m_netcafe);
            }
            if(currentLevel != null)
            {
               this.myPlayerCard.setRank(currentLevel);
            }
            this.handlePrestige(prestige);
            if(player.callSignObj != null)
            {
               if(player.callSignObj.cardTitle != null)
               {
                  this.myPlayerCard.setTitle(player.callSignObj.cardTitle);
               }
               this.myPlayerCard.setBackground(player.callSignObj.cardBackgroundURL);
               this.myPlayerCard.setEmblem(player.callSignObj.cardIconURL);
               this.myPlayerCard.setNameplate(player.callSignObj.cardNameplateColor);
               this.myPlayerCard.setFrame(player.callSignObj.cardFrameURL);
            }
         }
      }
      
      public function selectMember(member:RoomMemberObj) : void
      {
         var privileges:Object = null;
         this.m_curTeamMemberObj = member;
         if(this.m_curTeamMemberObj == null)
         {
            this.visible = false;
            return;
         }
         this.visible = true;
         var currentLevel:String = CFunctionCommonContainer.GetDisplayLevel(this.m_curTeamMemberObj.level - 1);
         var prestige:uint = uint(this.m_curTeamMemberObj.prestige);
         var wargodScore:uint = uint(this.m_curTeamMemberObj.wargodScore);
         if(this.m_curTeamMemberObj.isMe)
         {
            privileges = CFunctionCommonContainer.GetPlayerPrivileges();
            if(privileges != null)
            {
               this.m_qq_membership = privileges.qq_membership;
               this.m_netcafe = privileges.netcafe;
               this.myPlayerPrivileges.visible = true;
            }
            else
            {
               this.myPlayerPrivileges.visible = false;
            }
         }
         else
         {
            this.m_netcafe = this.m_curTeamMemberObj.netcafe;
            this.m_qq_membership = this.m_curTeamMemberObj.qq_membership;
            this.myPlayerPrivileges.visible = true;
         }
         this.setPlayerCardData(this.m_curTeamMemberObj,currentLevel,prestige,wargodScore);
      }
      
      private function onSelectedMemberMaybeChanged(evt:ParaEvent) : void
      {
         this.selectMember(evt.myPara as RoomMemberObj);
      }
      
      private function onCallsignRefreshHandle(cEvt:ParaEvent) : void
      {
         var callSignObj:Object = cEvt.myPara;
         if(callSignObj != null)
         {
            if(callSignObj.cardTitle != null)
            {
               this.myPlayerCard.setTitle(callSignObj.cardTitle);
            }
            this.myPlayerCard.setBackground(callSignObj.cardBackgroundURL);
            this.myPlayerCard.setEmblem(callSignObj.cardIconURL);
            this.myPlayerCard.setNameplate(callSignObj.cardNameplateColor);
            this.myPlayerCard.setFrame(callSignObj.cardFrameURL);
         }
      }
   }
}

