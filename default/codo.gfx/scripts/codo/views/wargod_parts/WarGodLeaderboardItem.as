package codo.views.wargod_parts
{
   import codo.component.TextField;
   import codo.component.social.LevelWidget;
   import codo.component.social.PageListBaseRender;
   import codo.component.social.SocialHamburgerButton;
   import codo.style.TextStyle;
   import codo.style.WarGodGuide;
   
   public class WarGodLeaderboardItem extends PageListBaseRender
   {
      
      public var myRank:TextField;
      
      public var myName:TextField;
      
      public var myRankMeter:LeaderBoardRankMeter;
      
      public var myLevel:LevelWidget;
      
      public var myClanName:TextField;
      
      public var myHamburgerBtn:SocialHamburgerButton;
      
      private var mSelfStyle:TextStyle;
      
      private var mDefaultStyle:TextStyle;
      
      private var mEntityID:String;
      
      public function WarGodLeaderboardItem()
      {
         super();
         this.myName.width = 180;
         this.myName.enableTruncate(true);
         this.myClanName.width = 230;
         this.myClanName.enableTruncate(true);
         this.mSelfStyle = WarGodGuide.styleWarGodLeaderboardItemForSelf;
         this.mDefaultStyle = WarGodGuide.styleWarGodLeaderboardItem;
      }
      
      override public function setData(data:*) : void
      {
         super.setData(data);
         this.isSelfMode(false);
         this.mEntityID = data.entityID;
         this.myRank.text = data.rank;
         this.myName.text = data.entityName;
         this.myRankMeter.setData(data.value);
         if(data.level == null)
         {
            this.myLevel.setRank(-1);
         }
         else
         {
            this.myLevel.setRank(data.level - 1,data.prestige);
         }
         if(data.clanName == null)
         {
            this.myClanName.text = "";
         }
         else
         {
            this.myClanName.text = data.clanName;
         }
         this.myHamburgerBtn.visible = false;
      }
      
      public function isSelfMode(isSelf:Boolean) : void
      {
         if(isSelf)
         {
            this.myRank.textStyle = this.mSelfStyle;
            this.myName.textStyle = this.mSelfStyle;
            this.myClanName.textStyle = this.mSelfStyle;
            this.myLevel.setTextStyle(this.mSelfStyle);
         }
         else
         {
            this.myRank.textStyle = this.mDefaultStyle;
            this.myName.textStyle = this.mDefaultStyle;
            this.myClanName.textStyle = this.mDefaultStyle;
            this.myLevel.setTextStyle(this.mDefaultStyle);
         }
         this.myLevel.myRankName.width = 150;
      }
   }
}

