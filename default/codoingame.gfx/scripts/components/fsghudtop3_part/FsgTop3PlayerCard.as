package components.fsghudtop3_part
{
   import codo.common.CFunctionCommonContainer;
   import codo.component.PlayerCard;
   import codo.objects.UserObj;
   import codo.utils.LocalizeUtil;
   import codo.utils.TextUtil;
   import codo.views.fsgHudTop3PlayerView_parts.FsgHudTop3PlayersViewRankIcon;
   import flash.display.MovieClip;
   import fsg.util.FsgUtil;
   
   public class FsgTop3PlayerCard extends MovieClip
   {
      
      private const CARD_FRAME_INDEX_DEFAULT:int = 1;
      
      private const CARD_FRAME_INDEX_TD:int = 2;
      
      private const CARD_FRAME_INDEX_TD_NO_BOX:int = 3;
      
      private const TD_MODE_BOX_MAX_NUM:int = 5;
      
      private const DETAIL_FRAME_INDEX_COMMON:int = 1;
      
      private const DETAIL_FRAME_INDEX_ROBBERY:int = 2;
      
      private const DETAIL_FRAME_INDEX_TD:int = 3;
      
      public var myPlayerCard:PlayerCard;
      
      public var myDetail:MovieClip;
      
      public var myRank:FsgHudTop3PlayersViewRankIcon;
      
      public function FsgTop3PlayerCard()
      {
         super();
      }
      
      public function setData(data:UserObj, gametype:String) : void
      {
         var tdRewards:Array = null;
         var rewardStartIndex:int = 0;
         var i:int = 0;
         var box:FsgTdTop3RewardBox = null;
         var frameIndex:int = this.CARD_FRAME_INDEX_DEFAULT;
         if(gametype == "td")
         {
            tdRewards = data["rewards"] != null ? data["rewards"] : [];
            if(tdRewards.length > 0)
            {
               frameIndex = this.CARD_FRAME_INDEX_TD;
            }
            else
            {
               frameIndex = this.CARD_FRAME_INDEX_TD_NO_BOX;
            }
         }
         gotoAndStop(frameIndex);
         this.truncateName(data.name);
         this.myPlayerCard.setClanName(data.clanName);
         var prestigeLvl:uint = uint(data.prestige);
         this.myPlayerCard.setPrestige(prestigeLvl == 0 ? "" : prestigeLvl.toString());
         this.myPlayerCard.setRank(CFunctionCommonContainer.GetDisplayLevel(data.level));
         this.myPlayerCard.setTitle(LocalizeUtil.localize("@" + data.callSignObj.cardTitle));
         this.myPlayerCard.setEmblem(data.callSignObj.cardIconURL);
         this.myPlayerCard.setBackground(data.callSignObj.cardBackgroundURL);
         this.myPlayerCard.setNameplate(data.callSignObj.cardNameplateColor);
         this.myPlayerCard.setFrame(data.callSignObj.cardFrameURL);
         this.myRank.rank = data["score"].rank;
         if(data.prestige > 0)
         {
            this.myPlayerCard.setPrestigeIcon(FsgUtil.getPrestigeIcon(data.prestige));
         }
         else
         {
            this.myPlayerCard.setPrestigeIcon("");
         }
         if(gametype == "robbery")
         {
            this.myDetail.gotoAndStop(this.DETAIL_FRAME_INDEX_ROBBERY);
            this.myDetail.myRobberyDetail.myKillsValue.text = data["score"].kills;
            this.myDetail.myRobberyDetail.myGoldsValue.text = data["score"].objectives >> 16 & 0xFFFF;
            this.myDetail.myWeapon.setImage(data["score"].weaponHudIcon);
         }
         else if(gametype == "td")
         {
            this.myDetail.gotoAndStop(this.DETAIL_FRAME_INDEX_TD);
            this.myDetail.myKills.text = data["score"].kills;
            rewardStartIndex = this.TD_MODE_BOX_MAX_NUM - tdRewards.length;
            for(i = 0; i < this.TD_MODE_BOX_MAX_NUM; i++)
            {
               box = this.myDetail.getChildByName("myTDItem" + i) as FsgTdTop3RewardBox;
               if(i < tdRewards.length)
               {
                  box.visible = true;
                  box.setData(i,i + rewardStartIndex,tdRewards[i]);
               }
               else
               {
                  box.visible = false;
               }
            }
         }
         else
         {
            this.myDetail.gotoAndStop(this.DETAIL_FRAME_INDEX_COMMON);
            this.myDetail.myKillsAndDeaths.kills = data["score"].kills;
            this.myDetail.myKillsAndDeaths.deaths = data["score"].deaths;
            this.myDetail.myWeapon.setImage(data["score"].weaponHudIcon);
         }
         this.myDetail.myScore.text = String(data["score"].score);
         TextUtil.resizeTextToFitWidth(this.myDetail.myScore);
      }
      
      private function truncateName(txt:String) : void
      {
         this.myPlayerCard.setName(txt);
         var offset:int = 4;
         if(this.myPlayerCard.myName.textWidth > this.myPlayerCard.myName.width - offset)
         {
            while(this.myPlayerCard.myName.textWidth > this.myPlayerCard.myName.width)
            {
               txt = txt.substring(0,txt.length - 1);
               this.myPlayerCard.setName(txt + "...");
            }
         }
      }
   }
}

