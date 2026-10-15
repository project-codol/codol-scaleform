package codo.views
{
   import codo.component.tutorial.UITourToolTip;
   import codo.constants.UITutorialFlags;
   import codo.objects.uitour.UITourToolTipObj;
   import flash.geom.Point;
   
   public class UITutorialSocialView extends UITutorialBaseView
   {
      
      private var mFriendsTips:Vector.<UITourToolTipObj>;
      
      private var mPartyTips:Vector.<UITourToolTipObj>;
      
      private var mLeaderboardsTips:Vector.<UITourToolTipObj>;
      
      public function UITutorialSocialView()
      {
         super();
         this.mFriendsTips = new <UITourToolTipObj>[new UITourToolTipObj(null,UITutorialFlags.NULL,"@UI_TUTORIAL_UI_TOUR_TOOL_TIP_FRIENDS_INVITE_TITLE","@UI_TUTORIAL_UI_TOUR_TOOL_TIP_FRIENDS_INVITE_DESC",new Point(260,30),true,null,null,null,UITourToolTip.STYLE_1_BTN,UITourToolTip.ARROW_DOWN)];
         this.mPartyTips = new <UITourToolTipObj>[new UITourToolTipObj(null,UITutorialFlags.NULL,"@UI_TUTORIAL_UI_TOUR_TOOL_TIP_PARTY_CREATE_TITLE","@UI_TUTORIAL_UI_TOUR_TOOL_TIP_PARTY_CREATE_DESC",new Point(690,380),true,null,null,null,UITourToolTip.STYLE_1_BTN)];
         this.mLeaderboardsTips = new <UITourToolTipObj>[new UITourToolTipObj(null,UITutorialFlags.NULL,"@UI_TUTORIAL_UI_TOUR_TOOL_TIP_LEADERBOARD_CATEG_TITLE","@UI_TUTORIAL_UI_TOUR_TOOL_TIP_LEADERBOARD_CATEG_DESC",new Point(400,0),true,null,null,null,UITourToolTip.STYLE_1_BTN,UITourToolTip.ARROW_DOWN)];
      }
      
      override protected function getToolTips() : Vector.<UITourToolTipObj>
      {
         switch(flagID)
         {
            case UITutorialFlags.UI_TOUR_FRIENDS:
               return this.mFriendsTips;
            case UITutorialFlags.UI_TOUR_PARTY:
               return this.mPartyTips;
            case UITutorialFlags.UI_TOUR_LEADERBOARD:
               return this.mLeaderboardsTips;
            default:
               return super.getToolTips();
         }
      }
   }
}

