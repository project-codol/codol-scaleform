package codo.views.wargod_parts
{
   import codo.base.BaseSubElement;
   import codo.common.CFunctionCommonContainer;
   import codo.common.CFunctionContainer;
   import codo.component.PlayerCard;
   import codo.component.TextField;
   import codo.constants.DataID;
   import codo.localization.DictWarGod;
   import codo.objects.PlayerBasicInfoObj;
   import codo.objects.ProductObj;
   import codo.objects.TimeObj;
   import codo.objects.WarGodGlobalSettingObj;
   import codo.objects.WarGodPlayerObj;
   import codo.objects.WarGodSeasonObj;
   import codo.style.WarGodGuide;
   import codo.utils.LocalizeUtil;
   import codo.utils.PlayerBasicInfoQueryUtil;
   import flash.display.MovieClip;
   import fsg.util.FsgUtil;
   
   public class WarGodSeasonEndPanel extends BaseSubElement implements IWarGodUIElement
   {
      
      public static var MAX_TOP_PLAYER_NUM:int = 10;
      
      public var myTitle:TextField;
      
      public var myContent:TextField;
      
      public var myTopWarGodLabel:TextField;
      
      public var myBg:MovieClip;
      
      public var myPC0:PlayerCard;
      
      public var myPC1:PlayerCard;
      
      public var myPC2:PlayerCard;
      
      public var myPC3:PlayerCard;
      
      public var myPC4:PlayerCard;
      
      public var myPC5:PlayerCard;
      
      public var myPC6:PlayerCard;
      
      public var myPC7:PlayerCard;
      
      public var myPC8:PlayerCard;
      
      public var myPC9:PlayerCard;
      
      private var mSeasonEnd:Boolean = false;
      
      private var mTopPlayer:Vector.<PlayerCardData>;
      
      private var mPlayerCards:Array;
      
      private var mCanShowTopPlayer:Boolean = false;
      
      private var mTopPlayerDataReady:Boolean = false;
      
      private var mTopPlayerBasicInfoQueryUtil:PlayerBasicInfoQueryUtil;
      
      public function WarGodSeasonEndPanel()
      {
         super();
         this.myTitle.textStyle = WarGodGuide.styleSeasonEndTitle;
         this.myTitle.width = 1234;
         this.myTitle.height = 58;
         this.myContent.textStyle = WarGodGuide.styleSeasonEndContent;
         this.myContent.width = 1234;
         this.myContent.height = 71;
         this.myTopWarGodLabel.textStyle = WarGodGuide.styleTopWarGodLabel;
         this.myTopWarGodLabel.width = 1234;
         this.myTopWarGodLabel.height = 45;
         this.myTopWarGodLabel.text = DictWarGod.TOP_WARGOD_LABEL;
         this.mPlayerCards = [this.myPC0,this.myPC1,this.myPC2,this.myPC3,this.myPC4,this.myPC5,this.myPC6,this.myPC7,this.myPC8,this.myPC9];
         this.mTopPlayerBasicInfoQueryUtil = new PlayerBasicInfoQueryUtil();
         this.mTopPlayerBasicInfoQueryUtil.registerPlayerBasicInfoHandler(this.onPlayerBasicInfo);
         this.mTopPlayerBasicInfoQueryUtil.registerCompleteHandler(this.onPlayerBasicInfoComplete);
      }
      
      public function setData(seasonObj:WarGodSeasonObj, playerObj:WarGodPlayerObj, globalSetting:WarGodGlobalSettingObj) : void
      {
         var blockDuration:int = 0;
         var timeObj:TimeObj = null;
         var state:int = getDP(DataID.WARGOD_OPENING_STATE);
         this.mSeasonEnd = true;
         switch(state)
         {
            case WarGodSeasonObj.STATE_CLOSE_LOCK:
               this.myTitle.text = DictWarGod.SEASON_CLOSED_WITHOUT_REASON;
               this.myContent.text = "";
               this.switchSeasonTop10(false);
               break;
            case WarGodSeasonObj.STATE_CLOSE_LEVEL:
               this.myTitle.text = DictWarGod.SEASON_LEVEL_LIMIT;
               this.myContent.text = LocalizeUtil.param(DictWarGod.SEASON_LEVEL_LIMIT_CONTENT,[globalSetting.levelRestriction]);
               this.switchSeasonTop10(true);
               break;
            case WarGodSeasonObj.STATE_CLOSE_PRIMARY_WEAPON:
               this.myTitle.text = DictWarGod.SEASON_PRIMARY_WEAPON_LIMIT;
               this.myContent.text = LocalizeUtil.param(DictWarGod.SEASON_PRIMARY_WEAPON_LIMIT_CONTENT,[globalSetting.primaryWeaponRequirement]);
               this.switchSeasonTop10(true);
               break;
            case WarGodSeasonObj.STATE_CLOSE_SEASON_NOT_START:
               this.myTitle.text = DictWarGod.SEASON_OPENING_SOON;
               this.myContent.text = seasonObj.timeForShow;
               this.switchSeasonTop10(true);
               break;
            case WarGodSeasonObj.STATE_CLOSE_SEASON_END:
               this.myTitle.text = DictWarGod.SEASON_END;
               this.myContent.text = DictWarGod.SEASON_CLOSE_SEASON_END_CONTENT;
               this.switchSeasonTop10(true);
               break;
            case WarGodSeasonObj.STATE_CLOSE_CREDIT_RATING:
               this.myTitle.text = DictWarGod.CREDIT_RISK;
               this.myContent.text = CFunctionContainer.AS_GetCreditRatingInfo();
               this.switchSeasonTop10(true);
               break;
            case WarGodSeasonObj.STATE_BLOCKED:
               this.myTitle.text = DictWarGod.MATCH_BLOCKED;
               blockDuration = getDP(DataID.WARGOD_BLOCK_DURATION);
               if(blockDuration == WarGodPlayerObj.PLAYER_BLOCKED_PERMANENTLY)
               {
                  this.myContent.text = DictWarGod.MATCH_BLOCKED_DETAIL;
               }
               else
               {
                  timeObj = CFunctionCommonContainer.GetFormatTimeByTimeStamp(blockDuration);
                  this.myContent.text = LocalizeUtil.param(DictWarGod.MATCH_BLOCKED_DURATION_DETAIL,[timeObj.year,timeObj.month,timeObj.day]);
               }
               this.switchSeasonTop10(true);
               break;
            case WarGodSeasonObj.STATE_PAUSE:
            case WarGodSeasonObj.STATE_OPEN:
               this.mSeasonEnd = false;
         }
      }
      
      public function isSeasonClosed() : Boolean
      {
         return this.mSeasonEnd;
      }
      
      private function switchSeasonTop10(show:Boolean) : void
      {
         this.mCanShowTopPlayer = show;
         this.myTopWarGodLabel.visible = false;
         this.myBg.visible = false;
         for(var i:int = 0; i < this.mPlayerCards.length; i++)
         {
            this.mPlayerCards[i].visible = false;
         }
         if(this.mTopPlayerDataReady && this.mCanShowTopPlayer)
         {
            this.realShowTopPlayer();
         }
      }
      
      private function realShowTopPlayer() : void
      {
         var i:int = 0;
         if(!this.mCanShowTopPlayer)
         {
            this.myTopWarGodLabel.visible = false;
            this.myBg.visible = false;
            for(i = 0; i < this.mPlayerCards.length; i++)
            {
               this.mPlayerCards[i].visible = false;
            }
            return;
         }
         this.myTopWarGodLabel.visible = true;
         this.myBg.visible = true;
         var pcIndex:int = 0;
         for(i = 0; i < this.mTopPlayer.length; i++)
         {
            if(this.mTopPlayer[i].valid)
            {
               this.SetPlayerCard(this.mPlayerCards[pcIndex],this.mTopPlayer[i]);
               this.mPlayerCards[pcIndex].visible = true;
               pcIndex++;
            }
         }
         for(i = pcIndex; i < this.mPlayerCards.length; i++)
         {
            this.mPlayerCards[i].visible = false;
         }
      }
      
      public function setTopPlayerState(stats:Object) : void
      {
         var stat:Object = null;
         var player:PlayerCardData = null;
         if(!(stats is Array))
         {
            return;
         }
         this.mTopPlayer = new Vector.<PlayerCardData>();
         var playersIdArray:Array = new Array();
         for(var i:int = 0; i < stats.length; i++)
         {
            if(i >= MAX_TOP_PLAYER_NUM)
            {
               break;
            }
            stat = stats[i];
            player = new PlayerCardData();
            player.id = stat.entityID;
            player.name = stat.entityName;
            player.valid = false;
            this.mTopPlayer.push(player);
            playersIdArray.push(player.id);
         }
         this.mTopPlayerBasicInfoQueryUtil.queryPlayerBasicInfo(playersIdArray);
      }
      
      private function SetPlayerCard(playerCard:PlayerCard, data:PlayerCardData) : void
      {
         var prod:ProductObj = null;
         playerCard.setName(data.name);
         playerCard.setClanName(data.clanName);
         playerCard.setRank(String(data.level));
         playerCard.setPrestige(String(data.prestige > 0 ? data.prestige : ""));
         playerCard.setPrestigeIcon(FsgUtil.getPrestigeIcon(data.prestige));
         prod = CFunctionCommonContainer.GetItemInfo(data.pcb);
         playerCard.setBackground(prod.imageURL);
         prod = CFunctionCommonContainer.GetItemInfo(data.pct);
         playerCard.setTitle(prod.name);
         prod = CFunctionCommonContainer.GetItemInfo(data.badge);
         playerCard.setEmblem(prod.imageURL);
         prod = CFunctionCommonContainer.GetItemInfo(data.pcn);
         playerCard.setNameplate(prod.color);
         prod = CFunctionCommonContainer.GetItemInfo(data.pcf);
         playerCard.setFrame(prod.imageURL);
      }
      
      public function onPlayerBasicInfo(info:PlayerBasicInfoObj) : void
      {
         for(var i:int = 0; i < this.mTopPlayer.length; i++)
         {
            if(this.mTopPlayer[i].id == info.entityID)
            {
               this.mTopPlayer[i].level = info.level;
               this.mTopPlayer[i].prestige = info.prestige;
               this.mTopPlayer[i].clanName = info.clanName;
               this.mTopPlayer[i].pcb = info.playerCardBackground;
               this.mTopPlayer[i].pct = info.playerCardTitle;
               this.mTopPlayer[i].badge = info.playerCardBadge;
               this.mTopPlayer[i].pcn = info.playerCardNameplate;
               this.mTopPlayer[i].pcf = info.playerCardFrame;
               this.mTopPlayer[i].valid = true;
               break;
            }
         }
      }
      
      public function onPlayerBasicInfoComplete() : void
      {
         this.mTopPlayerDataReady = true;
         this.realShowTopPlayer();
      }
   }
}

class PlayerCardData
{
   
   public var id:String;
   
   public var name:String;
   
   public var level:int;
   
   public var prestige:int;
   
   public var clanName:String;
   
   public var pcb:int;
   
   public var pct:int;
   
   public var badge:int;
   
   public var pcn:int;
   
   public var pcf:int;
   
   public var valid:Boolean;
   
   public function PlayerCardData()
   {
      super();
   }
}
