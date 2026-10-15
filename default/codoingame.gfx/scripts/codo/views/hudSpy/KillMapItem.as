package codo.views.hudSpy
{
   import codo.common.CFunctionInGameContainer;
   import codo.component.TextField;
   import codo.component.core.UIInteractiveComponent;
   import codo.constants.SpyModeRoleType;
   import codo.localization.DictSpy;
   import codo.objects.SpyModeKillMapItemObj;
   import codo.style.SpyHudGuide;
   import codo.style.TextStyle;
   import codo.utils.StringUtil;
   import components.fsggamelobby_part.FsgGameLobbyConsts;
   import flash.display.MovieClip;
   import flash.utils.getDefinitionByName;
   import fsg.util.FsgImageHolder;
   
   public class KillMapItem extends UIInteractiveComponent
   {
      
      public static const PADDING:int = 10;
      
      public static const LINK_NICK:String = "codo.shared.hud.HudSpyPlayerNickname";
      
      public var myWeaponHudIcon:FsgImageHolder;
      
      public var myAssists:MovieClip;
      
      public var myVictimName:TextField;
      
      public var myVictimNick:PlayerNickname;
      
      public var myPlusSign:TextField;
      
      public var myKillerName:TextField;
      
      public var myKillerNick:PlayerNickname;
      
      public var myBG:MovieClip;
      
      public var myTime:TextField;
      
      public var myKillstreak:TextField;
      
      public function KillMapItem()
      {
         super();
         this.myTime.textStyle = SpyHudGuide.SpyKillMapItemTime;
         this.myPlusSign.textStyle = SpyHudGuide.SpyKillMapItemNameCivilian;
         this.myPlusSign.text = "+";
         this.myKillstreak.textStyle = SpyHudGuide.SpyKillMapItemKillStreak;
         alpha = 0;
      }
      
      private function getNickFromClientNum(clientNum:int) : String
      {
         return (clientNum + 1).toString();
      }
      
      public function getNameFromClientNum(clientNum:int) : String
      {
         return CFunctionInGameContainer.AS_SpyGetPlayerNameByClientNum(clientNum);
      }
      
      private function changeNicknameIconBackgroundByRole(icon:PlayerNickname, role:int) : void
      {
         icon.gotoAndStop(1);
         if(role == SpyModeRoleType.SPY_ROLE_INVESTIGATOR)
         {
            icon.gotoAndStop(2);
         }
         else if(role == SpyModeRoleType.SPY_ROLE_SPY)
         {
            icon.gotoAndStop(3);
         }
      }
      
      private function isValidClientNum(clientNum:int) : Boolean
      {
         if(clientNum >= FsgGameLobbyConsts.MAX_CLIENTS || clientNum < 0)
         {
            return false;
         }
         return true;
      }
      
      override public function setData(data:*) : void
      {
         var itemObj:SpyModeKillMapItemObj = null;
         var pos:int = 0;
         var assistPos:int = 0;
         var nick:String = null;
         var role:int = 0;
         var cls:Class = null;
         var nickIcon:PlayerNickname = null;
         super.setData(data);
         itemObj = data as SpyModeKillMapItemObj;
         this.myBG.visible = true;
         if(itemObj.index % 2 == 0)
         {
            this.myBG.visible = false;
         }
         this.myTime.text = this.getTimeString(itemObj.time);
         pos = 180;
         var killer:int = itemObj.killer;
         var killerRole:int = itemObj.killerRole;
         if(!this.isValidClientNum(killer))
         {
            killer = itemObj.victim;
            killerRole = itemObj.victimRole;
         }
         this.myKillerNick.nickname = this.getNickFromClientNum(killer);
         this.myKillerNick.x = pos;
         pos += this.myKillerNick.width + PADDING;
         this.changeNicknameIconBackgroundByRole(this.myKillerNick,killerRole);
         this.myKillerName.text = this.getNameFromClientNum(killer);
         this.myKillerName.textStyle = this.getNameTextStyle(killerRole);
         this.myKillerName.x = pos;
         pos += this.myKillerName.textWidth + PADDING;
         this.cleanAssists();
         this.myPlusSign.visible = false;
         if(itemObj.assists.length > 0)
         {
            this.myPlusSign.visible = true;
            this.myPlusSign.x = pos;
            pos += this.myPlusSign.textWidth + PADDING;
         }
         this.myAssists.x = pos;
         assistPos = 0;
         for(var i:int = 0; i < itemObj.assists.length; i++)
         {
            nick = this.getNickFromClientNum(itemObj.assists[i]);
            role = int(itemObj.assistsRole[i]);
            cls = getDefinitionByName(LINK_NICK) as Class;
            nickIcon = new cls();
            this.myAssists.addChild(nickIcon);
            this.changeNicknameIconBackgroundByRole(nickIcon,role);
            nickIcon.x = assistPos;
            nickIcon.nickname = nick;
            assistPos += nickIcon.width + PADDING;
         }
         pos += assistPos;
         this.myWeaponHudIcon.setImage(CFunctionInGameContainer.AS_GetWeaponIconByWeaponIndexAndKillMod(itemObj.weapon,itemObj.killmod));
         this.myWeaponHudIcon.x = pos;
         pos += this.myWeaponHudIcon.width + PADDING;
         if(itemObj.victim >= 0)
         {
            this.myVictimNick.nickname = this.getNickFromClientNum(itemObj.victim);
            this.myVictimNick.x = pos;
            pos += this.myVictimNick.width + PADDING;
            this.changeNicknameIconBackgroundByRole(this.myVictimNick,itemObj.victimRole);
            this.myVictimName.text = this.getNameFromClientNum(itemObj.victim);
            this.myVictimName.textStyle = this.getNameTextStyle(itemObj.victimRole);
            this.myVictimName.x = pos;
         }
         var killStreakString:String = this.getKillStreakString(itemObj.killstreak);
         if(killStreakString == null)
         {
            this.myKillstreak.visible = false;
         }
         else
         {
            this.myKillstreak.visible = true;
            this.myKillstreak.text = killStreakString;
         }
      }
      
      private function getTimeString(time:int) : String
      {
         var min:int = time / 60;
         var sec:int = time % 60;
         return StringUtil.addZero(min.toString()) + ":" + StringUtil.addZero(sec.toString());
      }
      
      private function getNameTextStyle(role:int) : TextStyle
      {
         switch(role)
         {
            case SpyModeRoleType.SPY_ROLE_SPY:
               return SpyHudGuide.SpyKillMapItemNameSpy;
            case SpyModeRoleType.SPY_ROLE_INVESTIGATOR:
               return SpyHudGuide.SpyKillMapItemNameInvestigater;
            default:
               return SpyHudGuide.SpyKillMapItemNameCivilian;
         }
      }
      
      private function cleanAssists() : void
      {
         while(Boolean(this.myAssists.numChildren))
         {
            this.myAssists.removeChildAt(0);
         }
      }
      
      private function getKillStreakString(killstreak:int) : String
      {
         if(killstreak >= 10)
         {
            return DictSpy.KILLMAP_HOLLY_SHIT;
         }
         if(killstreak >= 9)
         {
            return DictSpy.KILLMAP_GODLIKE;
         }
         if(killstreak >= 8)
         {
            return DictSpy.KILLMAP_MONSTER_KILL;
         }
         if(killstreak >= 7)
         {
            return DictSpy.KILLMAP_METAMORPHOSIS;
         }
         if(killstreak >= 6)
         {
            return DictSpy.KILLMAP_UNSTOPPABLE;
         }
         if(killstreak >= 5)
         {
            return DictSpy.KILLMAP_MEGA_KILL;
         }
         if(killstreak >= 4)
         {
            return DictSpy.KILLMAP_DOMINATING;
         }
         if(killstreak >= 3)
         {
            return DictSpy.KILLMAP_KILLING_SPREE;
         }
         return null;
      }
   }
}

