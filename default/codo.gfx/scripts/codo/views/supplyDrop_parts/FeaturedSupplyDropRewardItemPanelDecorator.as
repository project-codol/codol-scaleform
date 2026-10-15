package codo.views.supplyDrop_parts
{
   import codo.common.CFunctionCommonContainer;
   import codo.common.CFunctionContainer;
   import codo.constants.MarketMenuData;
   import codo.localization.Dict;
   import codo.localization.DictMarket;
   import codo.utils.LocalizeUtil;
   import flash.geom.Point;
   
   public class FeaturedSupplyDropRewardItemPanelDecorator extends BaseSupplyDropRewardPanelDecorator
   {
      
      public function FeaturedSupplyDropRewardItemPanelDecorator(panel:SupplyDropRewardItemPanel)
      {
         super(panel);
      }
      
      override public function decorate() : void
      {
         var RADIUS:Number = NaN;
         var center:Point = null;
         mPanel.myHeaderTF.text = isDebugMode ? "特色" : LocalizeUtil.localize(Dict.GUARANTEED).toUpperCase();
         var perc:Number = CFunctionContainer.AS_GetSupplyDropFeaturedItemProgress(MarketMenuData.SUPPLY_DROP_ADVANCED);
         var percComplete:String = Math.ceil(perc * 100).toString().concat("%");
         mPanel.myContentHeaderTF.text = isDebugMode ? "YOU\'RE ALWAYS A WINNER" : LocalizeUtil.localize(DictMarket.SUPPLY_DROPS_GUARANTEED_TITLE);
         if(!CFunctionCommonContainer.SupplyDropHideFeatureItemProgress())
         {
            mPanel.myContentDescriptionTF.htmlText = isDebugMode ? "Guaranteed items are earned by opening ADVANCED SUPPLY DROPS. YOU HAVE A <font color=\'#f98521\' face=\'$font_3\' >25%</font> CHANCE THAT ONE OF the items you see on the left will appear in THE NEXT crate." : "<font color=\"#FFFFFF\">" + LocalizeUtil.param(LocalizeUtil.localize(DictMarket.SUPPLY_DROPS_GUARANTEED_DESCRIPTION),[percComplete]) + "</font>";
         }
         else
         {
            mPanel.myContentDescriptionTF.htmlText = isDebugMode ? "Guaranteed items are earned by opening ADVANCED SUPPLY DROPS. YOU HAVE A <font color=\'#f98521\' face=\'$font_3\' >25%</font> CHANCE THAT ONE OF the items you see on the left will appear in THE NEXT crate." : "<font color=\"#FFFFFF\">" + LocalizeUtil.localize(DictMarket.SUPPLY_DROPS_GUARANTEED_HIDE_PROGRESS_DESCRIPTION) + "</font>";
         }
         mPanel.myCallToActionBtn.label = isDebugMode ? "VIEW GUARANTEED ITEMS" : LocalizeUtil.localize(DictMarket.SUPPLY_DROPS_GUARANTEED_BUTTON_LABEL);
         if(!CFunctionCommonContainer.SupplyDropHideFeatureItemProgress())
         {
            RADIUS = 15;
            center = new Point(RADIUS,RADIUS);
            mPanel.myProgressCircleLarge.setFillColor(16352545);
            mPanel.myProgressCircleLarge.setParams(100,83,center);
            mPanel.myProgressCircleLarge.visible = true;
         }
         else
         {
            mPanel.myProgressCircleLarge.visible = false;
         }
         mPanel.registerCalltoActionBtnClickedCallback(this.openItemsToWinPopup);
         mPanel.registerRefreshUIAfterInventoryChangeCallback(this.refreshProgressBar);
         mPanel.myFlash.gotoAndStop(2);
      }
      
      private function openItemsToWinPopup() : void
      {
         mPanel.openItemsToWinPopup(true);
      }
      
      private function refreshProgressBar() : void
      {
         var perc:Number = NaN;
         var percComplete:String = null;
         if(!CFunctionCommonContainer.SupplyDropHideFeatureItemProgress())
         {
            perc = CFunctionContainer.AS_GetSupplyDropFeaturedItemProgress(MarketMenuData.SUPPLY_DROP_ADVANCED);
            percComplete = Math.round(perc * 100).toString().concat("%");
            mPanel.myContentDescriptionTF.htmlText = isDebugMode ? "Guaranteed items are earned by opening ADVANCED SUPPLY DROPS. YOU HAVE A <font color=\'#f98521\' face=\'$font_3\' >25%</font> CHANCE THAT ONE OF the items you see on the left will appear in THE NEXT crate." : "<font color=\"#FFFFFF\">" + LocalizeUtil.param(LocalizeUtil.localize(DictMarket.SUPPLY_DROPS_GUARANTEED_DESCRIPTION),[percComplete]) + "</font>";
            mPanel.myProgressCircleLarge.setFillAmount(perc * 100,100);
            mPanel.myProgressCircleLarge.playAnimation();
         }
      }
   }
}

