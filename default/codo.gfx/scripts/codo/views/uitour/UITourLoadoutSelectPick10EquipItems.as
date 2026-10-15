package codo.views.uitour
{
   import codo.localization.DictUITutorial;
   import codo.style.TutorialGuide;
   
   public class UITourLoadoutSelectPick10EquipItems extends UITutorialTourBase
   {
      
      public function UITourLoadoutSelectPick10EquipItems()
      {
         super();
         myDescriptionTF.textStyle = TutorialGuide.styleTextDescriptionMedium;
         myTitleTF.width = myDescriptionTF.width = TEXT_BOX_DEFAULT_WIDTH;
      }
      
      public function showSlot1() : void
      {
         title = DictUITutorial.UI_TOUR_PICK10_LOADOUT_SELECT_CLICK_TO_EQUIP_PERK_1_TITLE;
         description = DictUITutorial.UI_TOUR_PICK10_LOADOUT_SELECT_CLICK_TO_EQUIP_PERK_1_DESCRIPTION;
         gotoAndStop(TUTORIAL_FRAME_FIRST);
         myOverlay.gotoAndStop(TUTORIAL_FRAME_FIRST);
         this.positionContentAndShow();
      }
      
      public function showWildcard() : void
      {
         title = DictUITutorial.UI_TOUR_PICK10_LOADOUT_SELECT_CLICK_TO_EQUIP_WILDCARD_TITLE;
         description = DictUITutorial.UI_TOUR_PICK10_LOADOUT_SELECT_CLICK_TO_EQUIP_WILDCARD_DESCRIPTION;
         this.positionContentAndShow();
      }
      
      public function showSlot2() : void
      {
         title = DictUITutorial.UI_TOUR_PICK10_LOADOUT_SELECT_CLICK_TO_EQUIP_PERK_1_SLOT_2_TITLE;
         description = DictUITutorial.UI_TOUR_PICK10_LOADOUT_SELECT_CLICK_TO_EQUIP_PERK_1_SLOT_2_DESCRIPTION;
         gotoAndStop(TUTORIAL_FRAME_SECOND);
         myOverlay.gotoAndStop(TUTORIAL_FRAME_SECOND);
         myTitleTF.x = 777;
         myTitleTF.y = 558;
         this.positionContentAndShow();
      }
      
      private function positionContentAndShow() : void
      {
         myDescriptionTF.x = myTitleTF.x;
         myDescriptionTF.y = myTitleTF.y + myTitleTF.textHeight + CONTENT_PADDING;
         show();
      }
   }
}

