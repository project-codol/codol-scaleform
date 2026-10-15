package components.fsgmatchresult_part.panels
{
   import codo.component.ScrollGrid;
   import codo.objects.ScrollGridSettings;
   import codo.objects.ScrollListSettings;
   import codo.objects.UnlockItemObj;
   import codo.utils.DataUtil;
   import components.fsgmatchresult_part.FsgMatchResultPopupPanelBase;
   
   public class MatchResultMissionAwardsPanel extends FsgMatchResultPopupPanelBase
   {
      
      public var myScrollGrid:ScrollGrid;
      
      public function MatchResultMissionAwardsPanel()
      {
         super();
         this.setScrollListSettings();
         deactive();
      }
      
      public function setAwards(awards:Vector.<UnlockItemObj>) : void
      {
         this.myScrollGrid.addItemsByVector(DataUtil.copyElems(new Vector.<Object>(0),awards));
      }
      
      private function setScrollListSettings() : void
      {
         var listSettings:ScrollGridSettings = new ScrollGridSettings();
         this.myScrollGrid.width = 904;
         this.myScrollGrid.height = 662;
         listSettings.orientation = ScrollListSettings.SCROLL_VERTICAL;
         listSettings.itemLinkage = "codo.shared.matchresult.AccoladeItem";
         listSettings.useNavArrows = false;
         this.myScrollGrid.initGrid(listSettings,3,false,4);
      }
   }
}

