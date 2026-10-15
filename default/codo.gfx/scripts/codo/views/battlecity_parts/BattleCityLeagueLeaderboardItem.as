package codo.views.battlecity_parts
{
   import codo.component.social.LevelWidget;
   import codo.component.social.PageListBaseRender;
   import codo.style.GlobalGuide;
   import flash.text.TextField;
   
   public class BattleCityLeagueLeaderboardItem extends PageListBaseRender
   {
      
      public var myRank:TextField;
      
      public var myName:TextField;
      
      public var myClan:TextField;
      
      public var myChampionPoints:TextField;
      
      public var myLevelWidget:LevelWidget;
      
      public function BattleCityLeagueLeaderboardItem()
      {
         super();
      }
      
      override public function setData(data:*) : void
      {
         super.setData(data);
         this.myRank.text = data.rank;
         this.myName.text = data.entityName;
         this.myClan.text = Boolean(data.clanName) ? data.clanName : "";
         this.myChampionPoints.text = data.value;
         if(data.level == null)
         {
            this.myLevelWidget.setRank(-1);
         }
         else
         {
            this.myLevelWidget.setRank(data.level.level - 1,data.level.prestige);
         }
         if(Boolean(data.isMe))
         {
            this.myRank.textColor = GlobalGuide.CODO_YELLOW;
            this.myName.textColor = GlobalGuide.CODO_YELLOW;
            this.myClan.textColor = GlobalGuide.CODO_YELLOW;
            this.myChampionPoints.textColor = GlobalGuide.CODO_YELLOW;
         }
         else
         {
            this.myRank.textColor = GlobalGuide.WHITE;
            this.myName.textColor = GlobalGuide.WHITE;
            this.myClan.textColor = GlobalGuide.WHITE;
            this.myChampionPoints.textColor = GlobalGuide.WHITE;
         }
      }
   }
}

