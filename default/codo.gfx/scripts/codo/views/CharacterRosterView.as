package codo.views
{
   import codo.base.BaseView;
   import codo.common.CFunctionContainer;
   import codo.component.Button;
   import codo.component.CharacterRosterGridItem;
   import codo.component.ContentContainer;
   import codo.component.ScrollGrid;
   import codo.component.TextField;
   import codo.component.factory.ButtonFactory;
   import codo.constants.BCEvent;
   import codo.constants.DataID;
   import codo.localization.Dict;
   import codo.localization.DictSystem;
   import codo.objects.CharacterObj;
   import codo.objects.ScrollGridSettings;
   import codo.objects.ScrollListSettings;
   import codo.services.CharacterLoadoutService;
   import codo.style.GlobalGuide;
   import codo.style.TextStyle;
   import codo.utils.LocalizeUtil;
   import flash.events.KeyboardEvent;
   import flash.ui.Keyboard;
   
   public class CharacterRosterView extends BaseView
   {
      
      private static const CONTAINER_WIDTH:Number = 893;
      
      private static const CONTAINER_HEIGHT:Number = 678;
      
      private static const CONTAINER_PADDING:Number = 20;
      
      private static const ITEM_COUNT_PADDING:Number = 5;
      
      private static const ITEM_PADDING:Number = 3;
      
      private static const MAX_ACTIVE_CHARACTERS:Number = 12;
      
      public var myScrollGrid:ScrollGrid;
      
      public var myItemCount:TextField;
      
      public var myItemCountLabel:TextField;
      
      public var myErrorMessageLabel:TextField;
      
      public var myInstructions:TextField;
      
      public var myFrame:ContentContainer;
      
      public var myConfirmButton:Button;
      
      public var myCancelButton:Button;
      
      private var mCharacterData:Vector.<Object>;
      
      private var mNumCharactersSelected:int = 0;
      
      private var mNumInactiveChars:int = 0;
      
      public function CharacterRosterView()
      {
         super();
         this.initStage();
      }
      
      private function initStage() : void
      {
         var settings:ScrollGridSettings = new ScrollGridSettings();
         settings.buildGridItemRenderMethod = ButtonFactory.BUILD_CHARACTER_ROSTER_GRID_ITEM;
         settings.orientation = ScrollListSettings.SCROLL_VERTICAL;
         settings.itemPadding = ITEM_PADDING;
         settings.useNavArrows = false;
         this.myScrollGrid.initGrid(settings,4,false,6);
         this.myFrame.width = CONTAINER_WIDTH;
         this.myFrame.height = CONTAINER_HEIGHT;
         this.myItemCountLabel.fontSize = GlobalGuide.FONT_SIZE_EXTRA_SMALL;
         this.myItemCountLabel.fontColor = GlobalGuide.CODO_BLUE_DARK;
         this.myItemCount.fontColor = GlobalGuide.CODO_BLUE_DARK;
         this.myItemCount.fontSize = GlobalGuide.FONT_SIZE_SMALL;
         this.myItemCount.font = GlobalGuide.FONT_FACE_NUMBERS;
         this.myItemCount.alignment = TextStyle.HALIGN_RIGHT;
         this.myItemCountLabel.alignment = TextStyle.HALIGN_RIGHT;
         this.myItemCountLabel.text = LocalizeUtil.localize(Dict.ROSTER_ITEM_COUNT);
         this.myErrorMessageLabel.width = CONTAINER_WIDTH - CONTAINER_PADDING;
         this.myErrorMessageLabel.fontSize = GlobalGuide.FONT_SIZE_SMALL;
         this.myErrorMessageLabel.fontColor = GlobalGuide.CODO_RED;
         this.myErrorMessageLabel.alignment = TextStyle.HALIGN_RIGHT;
         this.myErrorMessageLabel.text = LocalizeUtil.localize(Dict.ROSTER_EMPTY_SLOTS_ERROR);
         this.myInstructions.width = CONTAINER_WIDTH - CONTAINER_PADDING;
         this.myInstructions.fontSize = GlobalGuide.FONT_SIZE_EXTRA_SMALL;
         this.myInstructions.fontColor = GlobalGuide.CODO_BLUE_DARK;
         this.myInstructions.text = LocalizeUtil.localize(Dict.CHARACTER_ROSTER_INSTRUCTIONS).toUpperCase();
         this.myConfirmButton.label = LocalizeUtil.localize(DictSystem.CONFIRM);
         this.myCancelButton.label = LocalizeUtil.localize(DictSystem.CANCEL);
         this.myConfirmButton.registerClickEvent(this.onConfirmClicked);
         this.myCancelButton.registerClickEvent(this.onCancelClicked);
         this.myConfirmButton.x = this.myFrame.x + this.myFrame.width - this.myConfirmButton.width - CONTAINER_PADDING;
         this.myCancelButton.x = this.myConfirmButton.x - this.myCancelButton.width;
         this.myCancelButton.y = this.myConfirmButton.y = this.myFrame.y + this.myFrame.height + GlobalGuide.COMPONENT_PADDING - CONTAINER_PADDING;
         this.myErrorMessageLabel.y = this.myConfirmButton.y - this.myConfirmButton.height - 10;
      }
      
      override protected function enableData() : void
      {
         var charData:CharacterObj = null;
         var data:Object = null;
         super.enableData();
         this.mCharacterData = new Vector.<Object>();
         var assignedCharacters:Vector.<CharacterObj> = CharacterLoadoutService.getInstance().getAssignedCharacterArray();
         this.mNumCharactersSelected = assignedCharacters.length;
         var unassignedCharacters:Vector.<CharacterObj> = CharacterLoadoutService.getInstance().getUnassignedCharacterArray();
         this.mNumInactiveChars = unassignedCharacters.length;
         var characters:Vector.<CharacterObj> = assignedCharacters.concat(unassignedCharacters);
         var len:int = int(characters.length);
         for(var i:int = 0; i < len; i++)
         {
            charData = characters[i];
            data = {};
            data.label = charData.name;
            data.id = charData.id;
            data.isActive = charData.isActive;
            data.loadoutIdx = charData.loadoutIdx;
            data.index = i;
            data.imageURL = charData.imageURL;
            data.clickEvent = this.onItemClicked;
            data.checked = charData.isActive;
            this.mCharacterData.push(data);
         }
         this.myScrollGrid.addItemsByVector(this.mCharacterData);
         this.myErrorMessageLabel.visible = false;
         this.updateCharacterCount();
      }
      
      private function updateCharacterCount() : void
      {
         this.myItemCount.text = LocalizeUtil.param(Dict.CHARACTER_ROSTER_COUNT,[this.mNumCharactersSelected.toString(),MAX_ACTIVE_CHARACTERS]);
         this.myItemCountLabel.x = this.myItemCount.x - this.myItemCount.textWidth - ITEM_COUNT_PADDING;
      }
      
      override protected function showView() : void
      {
         super.showView();
         stage.addEventListener(KeyboardEvent.KEY_UP,this.onStageKeyHandle);
      }
      
      override protected function hideView() : void
      {
         super.hideView();
         stage.removeEventListener(KeyboardEvent.KEY_UP,this.onStageKeyHandle);
      }
      
      private function onStageKeyHandle(e:KeyboardEvent) : void
      {
         if(e.type == KeyboardEvent.KEY_UP)
         {
            switch(e.keyCode)
            {
               case Keyboard.ESCAPE:
                  this.closePopupView();
            }
         }
      }
      
      private function onItemClicked(item:CharacterRosterGridItem) : void
      {
         if(!item.checked && this.mNumCharactersSelected < MAX_ACTIVE_CHARACTERS)
         {
            ++this.mNumCharactersSelected;
            item.checked = true;
         }
         else if(item.checked && this.mNumCharactersSelected > MAX_ACTIVE_CHARACTERS - this.mNumInactiveChars)
         {
            --this.mNumCharactersSelected;
            item.checked = false;
         }
         this.mCharacterData[item.index].checked = item.checked;
         this.updateCharacterCount();
      }
      
      private function onConfirmClicked() : void
      {
         var slotsState:uint = 0;
         var slotIndex:int = 0;
         var chaIndex:int = 0;
         if(this.mNumCharactersSelected == MAX_ACTIVE_CHARACTERS)
         {
            slotsState = 0;
            slotIndex = 0;
            chaIndex = 0;
            for(chaIndex = 0; chaIndex < this.mCharacterData.length; chaIndex++)
            {
               if(Boolean(this.mCharacterData[chaIndex].checked) && Boolean(this.mCharacterData[chaIndex].isActive))
               {
                  slotsState |= 1 << this.mCharacterData[chaIndex].loadoutIdx;
               }
            }
            for(chaIndex = 0; chaIndex < this.mCharacterData.length; chaIndex++)
            {
               if(Boolean(this.mCharacterData[chaIndex].checked) && !this.mCharacterData[chaIndex].isActive)
               {
                  while(slotIndex < MAX_ACTIVE_CHARACTERS)
                  {
                     if((slotsState & 1 << slotIndex) == 0)
                     {
                        break;
                     }
                     slotIndex++;
                  }
                  CFunctionContainer.CL_SetSlotCharacter(this.mCharacterData[chaIndex].id,slotIndex);
                  slotIndex++;
                  if(slotIndex >= MAX_ACTIVE_CHARACTERS)
                  {
                     break;
                  }
               }
            }
            DataManager.request(DataID.CHARACTERLOADOUT_CHARACTERS);
            this.closePopupView();
         }
         else
         {
            this.myErrorMessageLabel.visible = true;
         }
      }
      
      private function onCancelClicked() : void
      {
         this.closePopupView();
      }
      
      private function closePopupView() : void
      {
         broadcast(BCEvent.EVT_CLOSE_POPUP_PAGE,{"pageID":_pageID});
      }
   }
}

