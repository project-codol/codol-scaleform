package codo.views
{
   import codo.component.tutorial.UITourToolTip;
   import codo.constants.UITutorialFlags;
   import codo.objects.uitour.UITourToolTipObj;
   import flash.geom.Point;
   
   public class UITutorialMarketDetailsView extends UITutorialBaseView
   {
      
      private var mInventoryTips:Vector.<UITourToolTipObj>;
      
      public function UITutorialMarketDetailsView()
      {
         super();
         this.mInventoryTips = new <UITourToolTipObj>[new UITourToolTipObj(null,UITutorialFlags.NULL,"@UI_TUTORIAL_UI_TOUR_TOOL_TIP_MARKET_DETAILS_LEVEL_TITLE","@UI_TUTORIAL_UI_TOUR_TOOL_TIP_MARKET_DETAILS_LEVEL_DESC",new Point(1416,262),true,null,null,null,UITourToolTip.STYLE_1_BTN,UITourToolTip.ARROW_UP),new UITourToolTipObj(null,UITutorialFlags.NULL,"@UI_TUTORIAL_UI_TOUR_TOOL_TIP_SELECT_ATTACHMENT_TITLE","@UI_TUTORIAL_UI_TOUR_TOOL_TIP_SELECT_ATTACHMENT_DESC",new Point(364,406),true,null,null,null,UITourToolTip.STYLE_0_BTN)];
      }
      
      override protected function getToolTips() : Vector.<UITourToolTipObj>
      {
         switch(flagID)
         {
            case UITutorialFlags.UI_TOUR_INVENTORY_SELECT_ATTACHMENT:
               return this.mInventoryTips;
            default:
               return super.getToolTips();
         }
      }
   }
}

