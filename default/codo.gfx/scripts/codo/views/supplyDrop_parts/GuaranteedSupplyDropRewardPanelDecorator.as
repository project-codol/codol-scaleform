package codo.views.supplyDrop_parts
{
   import codo.localization.Dict;
   import codo.localization.DictMarket;
   import codo.utils.LocalizeUtil;
   
   public class GuaranteedSupplyDropRewardPanelDecorator extends BaseSupplyDropRewardPanelDecorator
   {
      
      public function GuaranteedSupplyDropRewardPanelDecorator(panel:SupplyDropRewardItemPanel)
      {
         super(panel);
      }
      
      override public function decorate() : void
      {
         mPanel.myHeaderTF.text = isDebugMode ? "新品" : LocalizeUtil.localize(Dict.LANDING_CHALLENGES_SORT_FEATURED);
         mPanel.myContentHeaderTF.text = isDebugMode ? "THE BEST CAN BE YOURS!" : LocalizeUtil.localize(DictMarket.SUPPLY_DROPS_REWARD_TITLE);
         mPanel.myContentDescriptionTF.htmlText = isDebugMode ? "Advanced Supply Drops give you a better chance to win an EPIC or LEGENDARY item like those shown to the left." : "<font color=\"#42C3FC\">" + LocalizeUtil.localize(DictMarket.SUPPLY_DROPS_REWARD_DESCRIPTION) + "<font>";
         mPanel.myContentDescriptionTF.alpha = 1;
         mPanel.registerCalltoActionBtnClickedCallback(this.openItemsToWinPopup);
         mPanel.myCallToActionBtn.label = isDebugMode ? "VIEW FEATUED ITEMS" : LocalizeUtil.localize(DictMarket.SUPPLY_DROPS_REWARD_BUTTON_LABEL);
      }
      
      private function openItemsToWinPopup() : void
      {
         mPanel.openItemsToWinPopup(false);
      }
   }
}

