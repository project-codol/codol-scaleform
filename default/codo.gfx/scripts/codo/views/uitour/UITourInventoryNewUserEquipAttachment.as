package codo.views.uitour
{
   import codo.constants.UITourVOSoundAliases;
   import codo.localization.DictUITutorial;
   import codo.style.TutorialGuide;
   
   public class UITourInventoryNewUserEquipAttachment extends UITutorialTourBase
   {
      
      public function UITourInventoryNewUserEquipAttachment()
      {
         super();
         myTitleTF.textStyle = TutorialGuide.styleTextTitle;
         myDescriptionTF.textStyle = TutorialGuide.styleTextDescriptionMedium;
         myTitleTF.width = myDescriptionTF.width = 445;
      }
      
      public function setCallToActionToSecondAttachment(isSecondAttachment:Boolean = true) : void
      {
         if(!isSecondAttachment)
         {
            playSound(UITourVOSoundAliases.INVENTORY_CLICK_FIRST_ATTACHMENT_SLOT);
            gotoAndStop(TUTORIAL_FRAME_FIRST);
            myOverlay.gotoAndStop(TUTORIAL_FRAME_FIRST);
            title = DictUITutorial.ONBOARDING_UI_TOUR_INVENTORY_EQUIP_FIRST_ATTATCHMENT_TITLE;
            description = DictUITutorial.ONBOARDING_UI_TOUR_INVENTORY_EQUIP_FIRST_ATTATCHMENT_DESCRIPTION;
         }
         else
         {
            myTitleTF.y = 421;
            playSound(UITourVOSoundAliases.INVENTORY_CLICK_SECOND_ATTACHMENT_SLOT);
            gotoAndStop(TUTORIAL_FRAME_SECOND);
            myOverlay.gotoAndStop(TUTORIAL_FRAME_SECOND);
            title = DictUITutorial.ONBOARDING_UI_TOUR_INVENTORY_EQUIP_SECOND_ATTATCHMENT_TITLE;
            description = DictUITutorial.ONBOARDING_UI_TOUR_INVENTORY_EQUIP_SECOND_ATTATCHMENT_DESCRIPTION;
         }
         myDescriptionTF.y = myTitleTF.y + myTitleTF.textHeight + CONTENT_PADDING;
         show();
      }
   }
}

