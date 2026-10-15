package codo.views
{
   import codo.common.CFunctionCommonContainer;
   import codo.component.Button;
   import codo.component.factory.ButtonFactory;
   import codo.component.onboarding.CharacterSelectSwitchModule;
   import codo.constants.GameInfo;
   import codo.constants.ItemType;
   import codo.cpp.UiCppOnboarding;
   import codo.localization.Dict;
   import codo.objects.CharacterObj;
   import codo.objects.OnboardCharacterOptionObj;
   import codo.objects.ProductObj;
   import codo.style.GlobalGuide;
   import codo.style.OnboardingGuide;
   import codo.style.TextStyle;
   
   public class CharacterSelectDetailsView extends ItemDetailsBaseView
   {
      
      private var mCharacterOptions:Vector.<OnboardCharacterOptionObj>;
      
      public var myCharacterSwitchModule:CharacterSelectSwitchModule;
      
      public function CharacterSelectDetailsView()
      {
         super();
         myBackButton.visible = false;
         myCharacterModule.myItemName.alignment = TextStyle.HALIGN_RIGHT;
         var txtStyle:TextStyle = myCharacterModule.myItemDescription.myText.textStyle;
         txtStyle.fontSize = GlobalGuide.FONT_SIZE_EXTRA_SMALL;
         myCharacterModule.myItemDescription.myText.textStyle = txtStyle;
      }
      
      override public function set routeData(data:*) : void
      {
         super.routeData = data;
         if(this.mCharacterOptions == null)
         {
            this.mCharacterOptions = data.characterSelectOptions;
            this.myCharacterSwitchModule.myCharacterList.setCustomCharacters(this.parseOnboardDataToCharacterObjs());
            this.myCharacterSwitchModule.registerCharacterChangeCallback(this.setCharacter);
         }
         this.myCharacterSwitchModule.myCharacterList.selectIndex(data.selectedCharacterIndex);
         this.myCharacterSwitchModule.show();
      }
      
      private function setCharacter() : void
      {
         var selectedCharIdx:int = this.myCharacterSwitchModule.myCharacterList.currentCharacterIndex;
         var charProductObject:ProductObj = new ProductObj();
         var charObj:OnboardCharacterOptionObj = this.mCharacterOptions[selectedCharIdx];
         CFunctionCommonContainer.AS_UIViewerSetItemDetailsID(charObj.characterItemSKU);
         charProductObject.id = charObj.characterItemSKU;
         charProductObject.name = charObj.characterName;
         charProductObject.description = charObj.characterBio;
         charProductObject.type = ItemType.CHA;
         charProductObject.imageURL = charObj.characterImageURL;
         charProductObject.SKUs = [];
         myCharacterModule.setData(charProductObject);
         myCharacterModule.setCharBioStats(this.mCharacterOptions[selectedCharIdx]);
      }
      
      private function parseOnboardDataToCharacterObjs() : Vector.<CharacterObj>
      {
         var charObj:CharacterObj = null;
         var onboardObj:OnboardCharacterOptionObj = null;
         var charObjs:Vector.<CharacterObj> = new Vector.<CharacterObj>(0);
         for each(onboardObj in this.mCharacterOptions)
         {
            charObj = new CharacterObj();
            charObj.id = onboardObj.characterItemSKU;
            charObj.imageURL = onboardObj.characterImageURL;
            charObj.loadoutIdx = onboardObj.index;
            charObj.name = onboardObj.characterName;
            charObjs.push(charObj);
         }
         return charObjs;
      }
      
      override protected function initStage() : void
      {
         super.initStage();
         this.setupCharacterConfirmButton();
      }
      
      private function setupCharacterConfirmButton() : void
      {
         var confirmButton:Button = null;
         var cancelButton:Button = null;
         confirmButton = addChild(ButtonFactory.BUILD_CALL_TO_ACTION_BUTTON()) as Button;
         confirmButton.setClickCallback(this.onCharacterSelected);
         confirmButton.label = Dict.CONFIRM;
         confirmButton.myLabel.textStyle = OnboardingGuide.styleSelectCharacterCallToAction;
         confirmButton.height = 60;
         confirmButton.width = 160;
         confirmButton.x = GameInfo.DEFAULT_WIDTH - (confirmButton.width + 50);
         confirmButton.y = GameInfo.DEFAULT_HEIGHT - (confirmButton.height + 100);
         cancelButton = addChild(ButtonFactory.BUILD_GENERIC_BUTTON()) as Button;
         cancelButton.setClickCallback(onBackButtonClicked);
         cancelButton.label = Dict.CANCEL;
         cancelButton.myLabel.textStyle = OnboardingGuide.styleSelectCharacterCallToAction;
         cancelButton.height = 60;
         cancelButton.width = 160;
         cancelButton.x = confirmButton.x - cancelButton.width - GlobalGuide.COMPONENT_PADDING;
         cancelButton.y = confirmButton.y;
      }
      
      private function onCharacterSelected() : void
      {
         var selectedCharIdx:int = this.myCharacterSwitchModule.myCharacterList.currentCharacterIndex;
         var characterItemID:int = this.mCharacterOptions[selectedCharIdx].characterItemSKU;
         UiCppOnboarding.instance.FinishCharacterStep(characterItemID);
      }
   }
}

