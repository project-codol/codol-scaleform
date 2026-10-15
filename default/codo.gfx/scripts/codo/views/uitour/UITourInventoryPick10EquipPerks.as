package codo.views.uitour
{
   import codo.component.Button;
   import codo.constants.GameInfo;
   import codo.localization.Dict;
   import codo.localization.DictUITutorial;
   import codo.style.GlobalGuide;
   import codo.style.TextStyle;
   import codo.style.TutorialGuide;
   import flash.display.Sprite;
   
   public class UITourInventoryPick10EquipPerks extends UITutorialTourBase
   {
      
      public var myCancelBtn:Button;
      
      public var myFrame_pick10:Sprite;
      
      public function UITourInventoryPick10EquipPerks()
      {
         super();
         var descStyle:TextStyle = TutorialGuide.styleTextDescriptionMedium;
         descStyle.alignment = TextStyle.HALIGN_RIGHT;
         myDescriptionTF.textStyle = descStyle;
         this.myCancelBtn.label = DictUITutorial.UI_TOUR_PICK10_BUTTON_LABEL_CANCEL;
         myCallToActionButton.label = Dict.QUESTION_NEXT;
         this.myCancelBtn.visible = myDescriptionTF.visible = myCallToActionButton.visible = false;
         myTitleTF.width = myDescriptionTF.width = TEXT_BOX_WITH_DESCRIPTION_WIDTH;
      }
      
      public function equipSlot1() : void
      {
         title = DictUITutorial.UI_TOUR_INVENTORY_PICK10_EQUIP_PERK1_TITLE;
         description = DictUITutorial.UI_TOUR_INVENTORY_PICK10_EQUIP_PERK1_DESCRIPTION;
         gotoAndStop(TUTORIAL_FRAME_FIRST);
         myOverlay.gotoAndStop(TUTORIAL_FRAME_FIRST);
         myOverlayGlow.alpha = 0;
         this.setUpSlotText();
         myTitleTF.x = 311;
         myTitleTF.y = 311;
         this.positionContent();
      }
      
      public function equipSlot2() : void
      {
         this.equipSlot1();
         title = DictUITutorial.UI_TOUR_INVENTORY_PICK10_EQUIP_PERK1_SLOT2_TITLE;
         description = DictUITutorial.UI_TOUR_INVENTORY_PICK10_EQUIP_PERK1_SLOT2_DESCRIPTION;
         gotoAndStop(TUTORIAL_FRAME_THIRD);
         myOverlay.gotoAndStop(TUTORIAL_FRAME_THIRD);
         this.setUpSlotText();
         myTitleTF.x = 311;
         myTitleTF.y = 418;
         this.positionContent();
      }
      
      public function equipSlot1CompleteShowPick10Bar(callback:Function, isWildcardStep:Boolean = false) : void
      {
         this.setTextAlignment(TextStyle.HALIGN_CENTER);
         if(isWildcardStep)
         {
            title = DictUITutorial.UI_TOUR_INVENTORY_PICK10_WILDCARD_EQUIPPED_BAR_TITLE;
            description = DictUITutorial.UI_TOUR_INVENTORY_PICK10_WILDCARD_EQUIPPED_BAR_DESCRIPTION;
         }
         else
         {
            title = DictUITutorial.UI_TOUR_INVENTORY_PICK10_BAR_TITLE;
            description = DictUITutorial.UI_TOUR_INVENTORY_PICK10_BAR_DESCRIPTION;
         }
         gotoAndStop(TUTORIAL_FRAME_SECOND);
         myOverlay.gotoAndStop(TUTORIAL_FRAME_SECOND);
         myOverlayGlow.alpha = 0;
         myTitleTF.x = this.myFrame_pick10.x - (myTitleTF.textWidth - this.myFrame_pick10.width) * 0.5 - CONTENT_PADDING;
         myTitleTF.y = 410;
         this.positionContent();
         myCallToActionButton.x = myTopicArrow.x;
         registerCallToActionEvent(callback);
         show();
      }
      
      public function equipWildcardCompleteShowPick10Bar(callback:Function) : void
      {
         title = DictUITutorial.UI_TOUR_INVENTORY_PICK10_WILDCARD_EQUIPPED_BAR_TITLE;
         description = DictUITutorial.UI_TOUR_INVENTORY_PICK10_WILDCARD_EQUIPPED_BAR_DESCRIPTION;
         gotoAndStop(TUTORIAL_FRAME_SECOND);
         myOverlay.gotoAndStop(TUTORIAL_FRAME_SECOND);
         myOverlayGlow.alpha = 0;
         myTitleTF.x = myTopicArrow.x - (myTopicArrow.width - TEXT_BOX_DEFAULT_WIDTH) * 0.5;
         myTitleTF.y = 420;
         this.setTextAlignment(TextStyle.HALIGN_CENTER);
         registerCallToActionEvent(callback);
         this.positionContent();
         show();
      }
      
      private function setUpSlotText() : void
      {
         myTitleTF.width = myDescriptionTF.width = TEXT_BOX_DEFAULT_WIDTH;
         var style:TextStyle = TutorialGuide.styleTextTitleAlignRight;
         style.fontSize = GlobalGuide.FONT_SIZE_LARGE;
         myTitleTF.textStyle = style;
         this.setTextAlignment(TextStyle.HALIGN_RIGHT);
         this.positionContent();
         show();
      }
      
      public function equipSlotComplete(callback:Function) : void
      {
         myTitleTF.width = myDescriptionTF.width = TEXT_BOX_WITH_DESCRIPTION_WIDTH;
         title = DictUITutorial.UI_TOUR_PICK10_INVENTORY_TOUR_COMPLETE_TITLE;
         description = DictUITutorial.UI_TOUR_PICK10_INVENTORY_TOUR_COMPLETE_DESCRIPTION;
         gotoAndStop(TUTORIAL_FRAME_FOURTH);
         myOverlay.gotoAndStop(TUTORIAL_FRAME_FOURTH);
         myOverlayGlow.alpha = 0;
         myCallToActionButton.label = Dict.FINISH;
         var centerpoint:int = (GameInfo.DEFAULT_WIDTH - TEXT_BOX_WITH_DESCRIPTION_WIDTH) * 0.5;
         myDescriptionTF.x = myTitleTF.x = centerpoint;
         myTitleTF.y = 186;
         this.setTextAlignment(TextStyle.HALIGN_LEFT);
         registerCallToActionEvent(callback);
         this.positionContent();
         myTopicArrow.y = myCallToActionButton.y + myCallToActionButton.height + CONTENT_PADDING;
         myTopicArrow.x = myCallToActionButton.x + myTopicArrow.width - myCallToActionButton.width + 22;
         show();
      }
      
      private function positionContent() : void
      {
         var yPos:uint = myTitleTF.y + myTitleTF.textHeight + CONTENT_PADDING;
         var xPos:uint = myTitleTF.x;
         myDescriptionTF.y = yPos;
         if(myDescriptionTF.visible)
         {
            yPos = myDescriptionTF.y + myDescriptionTF.textHeight + CONTENT_PADDING * 2;
         }
         myDescriptionTF.x = this.myCancelBtn.x = myCallToActionButton.x = xPos;
         myCallToActionButton.y = this.myCancelBtn.y = yPos;
         myCallToActionButton.x = myTitleTF.x + (TEXT_BOX_WITH_DESCRIPTION_WIDTH - myCallToActionButton.width) * 0.5;
         if(this.myCancelBtn.visible)
         {
            myCallToActionButton.x = xPos + this.myCancelBtn.width + CONTENT_PADDING;
         }
      }
      
      override protected function initAnimation() : void
      {
         if(currentFrame == TUTORIAL_FRAME_FOURTH)
         {
            revealText();
         }
         else
         {
            super.initAnimation();
         }
      }
      
      private function setTextAlignment(alignment:String) : void
      {
         var titleStyle:TextStyle = myTitleTF.textStyle;
         var descriptionStyle:TextStyle = myDescriptionTF.textStyle;
         titleStyle.alignment = descriptionStyle.alignment = alignment;
         myTitleTF.textStyle = titleStyle;
         myDescriptionTF.textStyle = descriptionStyle;
      }
      
      override protected function onCalltoActionRevealed() : void
      {
         if(currentFrame == TUTORIAL_FRAME_FOURTH)
         {
            myTopicArrow.active();
            myTopicArrow.animationStartCallback = animateOverlayGlowIn;
         }
         else
         {
            super.onCalltoActionRevealed();
         }
      }
   }
}

