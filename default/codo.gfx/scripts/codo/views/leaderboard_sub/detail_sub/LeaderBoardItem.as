package codo.views.leaderboard_sub.detail_sub
{
   import codo.component.PlayerName;
   import codo.component.TextField;
   import codo.component.social.LevelWidget;
   import codo.component.social.PageListBaseRender;
   import codo.component.social.SocialHamburgerButton;
   import codo.constants.RightClickMenuType;
   import codo.localization.DictLeaderBoard;
   import codo.objects.PlayerNameSettings;
   import codo.objects.UserObj;
   import codo.style.GlobalGuide;
   import codo.style.LeaderBoardGuide;
   import codo.style.SocialGuide;
   import codo.style.TextStyle;
   import codo.utils.WarGodUtility;
   import flash.display.MovieClip;
   
   public class LeaderBoardItem extends PageListBaseRender
   {
      
      private static var mShowHamburgerButtonClickedHandler:Function;
      
      public var myIcon:MovieClip;
      
      public var myRank:TextField;
      
      public var myLevel:LevelWidget;
      
      public var myName:PlayerName;
      
      public var myValue:TextField;
      
      public var myWargodTierName:TextField;
      
      public var myWargodTier:MovieClip;
      
      public var myHamburgerBtn:SocialHamburgerButton;
      
      public function LeaderBoardItem()
      {
         super();
         isInteractiveEnabled = true;
         this.myRank.textStyle = LeaderBoardGuide.styleRankNumberRender;
         var nameSetting:PlayerNameSettings = new PlayerNameSettings();
         nameSetting.mode = PlayerNameSettings.MODE_DIRECT;
         nameSetting.fontSize = GlobalGuide.FONT_SIZE_EXTRA_SMALL;
         nameSetting.textWidth = 200;
         nameSetting.textHeight = 22;
         nameSetting.textColor = GlobalGuide.WHITE;
         nameSetting.fitSizeMethod = PlayerNameSettings.FIT_SIZE_METHOD_EXTEND;
         nameSetting.rightClickType = RightClickMenuType.DETAIL_ONLY;
         this.myName.settings = nameSetting;
         this.myWargodTierName.textStyle = LeaderBoardGuide.styleItemRender;
         this.myValue.textStyle = LeaderBoardGuide.styleItemNumberRender;
      }
      
      public static function setShowHamburgerButtonClickedHandler(handler:Function) : void
      {
         mShowHamburgerButtonClickedHandler = handler;
      }
      
      override public function setData(data:*) : void
      {
         super.setData(data);
         if(data == null)
         {
            return;
         }
         this.myRank.textStyle = LeaderBoardGuide.styleRankNumberRender;
         this.myRank.text = data.rank;
         if(data.rank == 0)
         {
            this.myRank.textStyle = LeaderBoardGuide.styleRankNumberRender;
            this.myRank.text = DictLeaderBoard.NOT_HAVE_RANK;
         }
         if(data.rank >= 1 && data.rank <= 3)
         {
            this.myRank.visible = false;
            this.myIcon.visible = true;
            this.myIcon.gotoAndStop(data.rank);
         }
         else
         {
            this.myRank.visible = true;
            this.myIcon.visible = false;
         }
         this.myName.setData(data.entityName,data.entityID);
         this.myValue.text = data.value;
         if(data.level == null || data.prestige == null)
         {
            this.myLevel.setRank(-1);
         }
         else
         {
            this.myLevel.setRank(data.level - 1,data.prestige);
         }
         WarGodUtility.setWargodTierIcon(this,data);
         this.myHamburgerBtn.setData(new UserObj({
            "id":data.entityID,
            "name":data.entityName
         }));
         this.myHamburgerBtn.setShowHamburgerButtonClickedHandler(mShowHamburgerButtonClickedHandler);
      }
      
      public function onHamburgerButtonClickedHandler(data:*) : void
      {
         this.myHamburgerBtn.selected = true;
      }
      
      public function isSelfMode(value:Boolean) : void
      {
         isInteractiveEnabled = !value;
         this.myRank.fontColor = value ? LeaderBoardGuide.SELF_COLOR : GlobalGuide.WHITE;
         this.myName.myTextField.fontColor = value ? LeaderBoardGuide.SELF_COLOR : GlobalGuide.WHITE;
         this.myValue.fontColor = value ? LeaderBoardGuide.SELF_COLOR : GlobalGuide.WHITE;
         this.myLevel.setTextStyle(value ? SocialGuide.styleSelfLevelWidget : SocialGuide.styleLevelWidget);
      }
   }
}

