package codo.views.career_parts
{
   import codo.component.ContentContainer;
   import codo.component.MarketplaceGridCheckBox;
   import codo.component.ScrollGrid;
   import codo.component.TextField;
   import codo.component.ViewPanelBase;
   import codo.component.factory.ButtonFactory;
   import codo.component.filter.Filter;
   import codo.component.scrollgrid.parts.ScrollGridSortOrderToggle;
   import codo.cpp.UiCppChallengesView;
   import codo.cpp.UiCppView;
   import codo.localization.DictCareer;
   import codo.localization.DictChallenge;
   import codo.objects.ScrollGridSettings;
   import codo.objects.ScrollListSettings;
   import codo.objects.VetChallengeObj;
   import codo.style.GlobalGuide;
   import codo.utils.DataUtil;
   import codo.utils.LocalizeUtil;
   
   public class CareerChallengesPanel extends ViewPanelBase
   {
      
      private static const ITEM_COUNT_PADDING:Number = 5;
      
      public var myChallengesGrid:ScrollGrid;
      
      public var myGridFrame:ContentContainer;
      
      public var myFilter:Filter;
      
      public var myCompletedCheckbox:MarketplaceGridCheckBox;
      
      public var mySortingOrderSelector:ScrollGridSortOrderToggle;
      
      public var myProgressLabel:TextField;
      
      public var myProgressValue:TextField;
      
      public var myItemCount:TextField;
      
      public var myItemCountLabel:TextField;
      
      public function CareerChallengesPanel()
      {
         super();
         var scrollGridSettings:ScrollGridSettings = new ScrollGridSettings();
         scrollGridSettings.useNavArrows = false;
         scrollGridSettings.autoSizeItems = false;
         scrollGridSettings.orientation = ScrollListSettings.SCROLL_VERTICAL;
         scrollGridSettings.buildGridItemRenderMethod = ButtonFactory.BUILD_HOME_CHALLENGE_LIST_ITEM;
         scrollGridSettings.itemPadding = 6;
         this.myChallengesGrid.initGrid(scrollGridSettings,4,false,2);
         this.myGridFrame.width = 914;
         this.myGridFrame.height = 700;
         this.myProgressLabel.fontSize = GlobalGuide.FONT_SIZE_MEDIUM;
         this.myProgressLabel.width = 1038;
         this.myProgressValue.font = GlobalGuide.FONT_FACE_BOLD;
         this.myProgressValue.fontSize = GlobalGuide.FONT_SIZE_HUGE;
         this.myProgressValue.width = 1038;
         this.myProgressValue.height = 75;
         this.myFilter.singleOptionMode = true;
         this.myItemCountLabel.fontSize = GlobalGuide.FONT_SIZE_SMALL;
         this.myItemCount.fontSize = GlobalGuide.FONT_SIZE_SMALL;
         this.myItemCount.font = GlobalGuide.FONT_FACE_NUMBERS;
         this.myItemCount.fontColor = GlobalGuide.CODO_BLUE_HIGHLIGHT;
         this.myCompletedCheckbox.width = 113;
         this.myCompletedCheckbox.label = LocalizeUtil.localize(DictChallenge.CHALLENGES_COMPLETED);
      }
      
      override protected function makeUiCpp() : UiCppView
      {
         this.myCompletedCheckbox.makeUiCpp();
         return new UiCppChallengesView(this,this.myFilter.getUiCpp(),this.mySortingOrderSelector.getUiCpp(),this.myCompletedCheckbox.getUiCpp());
      }
      
      public function onCategorySelect(label:String, levelsCompleted:uint, levelsTotal:uint) : void
      {
         label = LocalizeUtil.localize(label);
         this.myProgressLabel.text = LocalizeUtil.param(DictChallenge.CHALLENGES_OVERALL_PROGRESS,[label]);
         this.myProgressValue.text = int(levelsCompleted / levelsTotal * 100) + "%";
         this.myProgressValue.x = this.myGridFrame.x + this.myGridFrame.width - GlobalGuide.COMPONENT_PADDING - this.myProgressValue.textWidth;
         this.myProgressLabel.x = this.myProgressValue.x - this.myProgressLabel.textWidth - 5;
      }
      
      public function setChallenges(challenges:Vector.<VetChallengeObj>) : void
      {
         var objs:Vector.<Object> = DataUtil.copyElems(new Vector.<Object>(0),challenges);
         this.myChallengesGrid.addItemsByVector(objs);
         this.myItemCount.text = this.myChallengesGrid.listData.length.toString();
         this.myItemCountLabel.text = LocalizeUtil.localize(DictCareer.CHALLENGES_UNIT);
         this.myItemCountLabel.x = this.myItemCount.x + this.myItemCount.textWidth + ITEM_COUNT_PADDING;
      }
   }
}

