package codo.views
{
   import codo.component.tutorial.UITourToolTip;
   import codo.constants.BCEvent;
   import codo.constants.MarketMenuData;
   import codo.constants.UITutorialFlags;
   import codo.objects.uitour.UITourToolTipObj;
   import flash.geom.Point;
   
   public class UITutorialPersistentView extends UITutorialBaseView
   {
      
      private var mLoginRewardsTips:Vector.<UITourToolTipObj>;
      
      private var mCareerTips:Vector.<UITourToolTipObj>;
      
      private var mMatchSelectTips:Vector.<UITourToolTipObj>;
      
      private var mMarketTips:Vector.<UITourToolTipObj>;
      
      private var mWarGodTips:Vector.<UITourToolTipObj>;
      
      public function UITutorialPersistentView()
      {
         super();
         this.mLoginRewardsTips = new <UITourToolTipObj>[new UITourToolTipObj(null,UITutorialFlags.NULL,"@UI_TUTORIAL_UI_TOUR_TOOL_TIP_DAILY_LOGIN_REWARDS_TITLE","@UI_TUTORIAL_UI_TOUR_TOOL_TIP_DAILY_LOGIN_REWARDS_DESC",new Point(230,639),true,null,null,null,UITourToolTip.STYLE_1_BTN,UITourToolTip.ARROW_RIGHT),new UITourToolTipObj(null,UITutorialFlags.NULL,"@UI_TUTORIAL_UI_TOUR_TOOL_TIP_DAILY_LOGIN_NEXT_REWARD_TITLE","@UI_TUTORIAL_UI_TOUR_TOOL_TIP_DAILY_LOGIN_NEXT_REWARD_DESC",new Point(144,410),true,null,null,null,UITourToolTip.STYLE_1_BTN,UITourToolTip.ARROW_DOWN)];
         this.mCareerTips = new <UITourToolTipObj>[new UITourToolTipObj(null,UITutorialFlags.NULL,"@UI_TUTORIAL_UI_TOUR_TOOL_TIP_CAREER_XP_TITLE","@UI_TUTORIAL_UI_TOUR_TOOL_TIP_CAREER_XP_DESC",new Point(615,252),true,null,null,null,UITourToolTip.STYLE_1_BTN,UITourToolTip.ARROW_LEFT),new UITourToolTipObj(null,UITutorialFlags.NULL,"@UI_TUTORIAL_UI_TOUR_TOOL_TIP_CAREER_LEVEL_REWARDS_TITLE","@UI_TUTORIAL_UI_TOUR_TOOL_TIP_CAREER_LEVEL_REWARDS_DESC",new Point(410,634),true,null,null,null,UITourToolTip.STYLE_1_BTN,UITourToolTip.ARROW_LEFT)];
         this.mMatchSelectTips = new Vector.<UITourToolTipObj>(0);
         this.mMarketTips = new <UITourToolTipObj>[new UITourToolTipObj(null,UITutorialFlags.NULL,"@UI_TUTORIAL_UI_TOUR_TOOL_TIP_CURRENCY_TITLE","@UI_TUTORIAL_UI_TOUR_TOOL_TIP_CURRENCY_DESC",new Point(1410,118),true,null,null,null,UITourToolTip.STYLE_1_BTN,UITourToolTip.ARROW_UP)];
         this.mWarGodTips = new <UITourToolTipObj>[new UITourToolTipObj(null,UITutorialFlags.NULL,"@UI_TUTORIAL_UI_TOUR_TOOL_TIP_WARGOD_TITLE","@UI_TUTORIAL_UI_TOUR_TOOL_TIP_WARGOD_DESC",new Point(279,418),true,null,null,null,UITourToolTip.STYLE_1_BTN,UITourToolTip.ARROW_UP),new UITourToolTipObj(null,UITutorialFlags.NULL,"@UI_TUTORIAL_UI_TOUR_TOOL_TIP_WARGOD_PROGRESS_TITLE","@UI_TUTORIAL_UI_TOUR_TOOL_TIP_WARGOD_PROGRESS_DESC",new Point(694,137),true,null,null,null,UITourToolTip.STYLE_1_BTN,UITourToolTip.ARROW_DOWN),new UITourToolTipObj(null,UITutorialFlags.NULL,"@UI_TUTORIAL_UI_TOUR_TOOL_TIP_WARGOD_CONFIG_TITLE","@UI_TUTORIAL_UI_TOUR_TOOL_TIP_WARGOD_CONFIG_DESC",new Point(1474,595),true,null,null,null,UITourToolTip.STYLE_1_BTN,UITourToolTip.ARROW_DOWN),new UITourToolTipObj(null,UITutorialFlags.NULL,"@UI_TUTORIAL_UI_TOUR_TOOL_TIP_WARGOD_REWARDS_TITLE","@UI_TUTORIAL_UI_TOUR_TOOL_TIP_WARGOD_REWARDS_DESC",new Point(825,405),true,null,null,null,UITourToolTip.STYLE_1_BTN,UITourToolTip.ARROW_DOWN),new UITourToolTipObj(null
         ,UITutorialFlags.NULL,"@UI_TUTORIAL_UI_TOUR_TOOL_TIP_WARGOD_MARKET_TITLE","@UI_TUTORIAL_UI_TOUR_TOOL_TIP_WARGOD_MARKET_DESC",new Point(1436,405),true,null,null,null,UITourToolTip.STYLE_1_BTN,UITourToolTip.ARROW_DOWN)];
      }
      
      override protected function showView() : void
      {
         super.showView();
      }
      
      override protected function getToolTips() : Vector.<UITourToolTipObj>
      {
         switch(flagID)
         {
            case UITutorialFlags.UI_TOUR_LOGIN_REWARDS:
               return this.mLoginRewardsTips;
            case UITutorialFlags.UI_TOUR_CAREER:
               return this.mCareerTips;
            case UITutorialFlags.UI_TOUR_MATCH_SELECT:
               return this.mMatchSelectTips;
            case UITutorialFlags.UI_TOUR_MARKETPLACE:
               return this.mMarketTips;
            case UITutorialFlags.UI_TOUR_WARGOD:
               return this.mWarGodTips;
            default:
               return super.getToolTips();
         }
      }
      
      override protected function onTourFinished() : void
      {
         if(flagID == UITutorialFlags.UI_TOUR_WARGOD)
         {
            broadcast(BCEvent.EVT_GOTO_MARKET,{"tabIndex":MarketMenuData.TAB_WARGOD});
            return;
         }
         super.onTourFinished();
      }
   }
}

