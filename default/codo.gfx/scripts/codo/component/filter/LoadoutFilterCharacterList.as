package codo.component.filter
{
   import codo.common.CFunctionCommonContainer;
   import codo.component.Button;
   import codo.component.core.UIInteractiveComponent;
   import codo.constants.BCEvent;
   import codo.constants.DataID;
   import codo.localization.Dict;
   import codo.manager.DataManager;
   import codo.manager.EventManager;
   import codo.objects.CharacterObj;
   import codo.objects.ProductObj;
   import codo.services.CharacterLoadoutService;
   import codo.utils.SoundUtil;
   import com.greensock.TimelineLite;
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.utils.getDefinitionByName;
   
   public class LoadoutFilterCharacterList extends MovieClip
   {
      
      private static const LIST_MARGIN:Number = 20;
      
      private static const SLIDE_DURATION:Number = 0.1;
      
      private static const HIGHLIGHT_SCALE_DURATION:Number = 0.1;
      
      private static const BACKGROUND_GROW_DURATION:Number = 0.2;
      
      private static const BLUE_HIGHLIGHT_WIDTH:Number = 54;
      
      private static const HIGHLIGHT_GLOW_FOCUS_ALPHA:Number = 0.5;
      
      private static const HIGHLIGHT_GLOW_OFFSET_X:Number = 22;
      
      private static const HIGHLIGHT_GLOW_OFFSET_Y:Number = 16;
      
      private static const MAX_CHARACTERS:Number = 12;
      
      private static const MANAGE_BUTTON_PADDING:Number = 15;
      
      private static const NULL_ID:int = -1;
      
      public var myItemMount:MovieClip;
      
      public var myListBackground:MovieClip;
      
      public var myBlueHighlight:Sprite;
      
      public var myGlow:Sprite;
      
      public var myHighlightGlow:Sprite;
      
      public var myManageButton:Button;
      
      private var mItems:Vector.<UIInteractiveComponent>;
      
      private var mCharacterSelectedCallback:Function;
      
      private var mCharactersUpdatedCallback:Function;
      
      private var mCurrentCharacterIndex:int = 0;
      
      private var mToggleAnimTimeline:TimelineLite;
      
      private var mListHeight:Number = 0;
      
      private var mCharacters:Vector.<CharacterObj>;
      
      private var mCurCharID:int = -1;
      
      private var mShown:Boolean = false;
      
      public function LoadoutFilterCharacterList()
      {
         super();
         this.myListBackground.width = 260;
         this.myListBackground.alpha = 0;
         this.myListBackground.height = 10;
         this.myGlow.height = 10;
         this.myItemMount.alpha = 0;
         this.myBlueHighlight.width = 0;
         this.myGlow.alpha = 0;
         this.myHighlightGlow.alpha = 0;
         var halfWidth:Number = this.myListBackground.width * 0.5;
         this.myBlueHighlight.x = halfWidth - BLUE_HIGHLIGHT_WIDTH * 0.5;
         this.myHighlightGlow.x = this.myBlueHighlight.x - HIGHLIGHT_GLOW_OFFSET_X;
         this.myHighlightGlow.y = this.myBlueHighlight.y - HIGHLIGHT_GLOW_OFFSET_Y;
         this.myManageButton.visible = false;
         this.myManageButton.label = Dict.MANAGE_ROSTER;
         this.myManageButton.width = this.myListBackground.width;
         this.myManageButton.alpha = 0;
         this.hideListBackground();
         DataManager.getInstance().bind(DataID.CHARACTERLOADOUT_CHARACTERS,this.bindCharacters);
         DataManager.getInstance().bind(DataID.CHARACTERLOADOUT_CHARACTERS_CURRENT_SHOWN_ID,this.bindCurChar);
      }
      
      public function setCustomCharacters(chars:Vector.<CharacterObj>) : void
      {
         DataManager.getInstance().unbind(DataID.CHARACTERLOADOUT_CHARACTERS,this.bindCharacters);
         DataManager.getInstance().unbind(DataID.CHARACTERLOADOUT_CHARACTERS_CURRENT_SHOWN_ID,this.bindCurChar);
         this.mCurCharID = NULL_ID;
         this.setCharacters(chars);
         this.mCurrentCharacterIndex = -1;
      }
      
      protected function bindCharacters(cResult:Object) : void
      {
         this.setCharacters(cResult.data);
      }
      
      private function setCharacters(chars:Vector.<CharacterObj>) : void
      {
         this.mCharacters = chars;
         this.mCurrentCharacterIndex = this.findCharIdx(this.mCurCharID);
         this.clearItems();
         if(this.mShown)
         {
            this.buildList();
            this.updateToggles();
         }
         if(this.mCharactersUpdatedCallback != null)
         {
            this.mCharactersUpdatedCallback();
         }
         if(this.mCurCharID != NULL_ID && this.mCharacters != null && this.mCharacters.length > this.mCurrentCharacterIndex)
         {
            if(this.mCurCharID != this.mCharacters[this.mCurrentCharacterIndex].id)
            {
               this.mCurCharID = this.mCharacters[this.mCurrentCharacterIndex].id;
               this.broadcastCharSelect();
            }
         }
      }
      
      private function buildList() : void
      {
         var item:UIInteractiveComponent = null;
         this.mItems = new Vector.<UIInteractiveComponent>();
         var curY:Number = 0;
         var len:int = int(this.mCharacters.length);
         for(var i:int = 0; i < len; i++)
         {
            item = this.addOption(this.mCharacters[i],i,curY);
            curY += item.height;
         }
         this.mListHeight = curY + LIST_MARGIN;
         this.myManageButton.y = this.myItemMount.y + curY + MANAGE_BUTTON_PADDING;
      }
      
      public function get characters() : Vector.<CharacterObj>
      {
         return this.mCharacters;
      }
      
      private function addOption(charData:CharacterObj, idx:int, yPos:Number) : UIInteractiveComponent
      {
         var option:LoadoutFilterCharacterListOption = null;
         var optionClass:Class = getDefinitionByName("codo.shared.filter.LoadoutFilterCharacterListOption") as Class;
         option = new optionClass();
         option.width = this.myListBackground.width;
         option.label = charData.name;
         option.index = idx;
         option.isNew = charData.showBreadcrumb;
         option.id = charData.id;
         if(null != charData.imageURL && "" != charData.imageURL)
         {
            option.image = charData.imageURL;
         }
         option.registerClickEvent(this.onCharacterSelected,{"index":idx});
         option.registerFocusEvent(this.onCharacterFocused,{"index":idx});
         option.registerUnfocusEvent(this.onCharacterUnfocused);
         this.myItemMount.addChild(option);
         this.mItems.push(option);
         option.y = yPos;
         return option;
      }
      
      public function get isShowing() : Boolean
      {
         return this.mShown;
      }
      
      public function show() : void
      {
         if(true == this.mShown)
         {
            return;
         }
         this.mShown = true;
         this.clearAnimation();
         if(this.mItems == null)
         {
            this.buildList();
         }
         this.updateToggles();
         this.myItemMount.visible = true;
         this.myListBackground.visible = true;
         this.myGlow.visible = true;
         this.myHighlightGlow.visible = true;
         this.myManageButton.registerClickEvent(this.onManageClicked);
         this.mToggleAnimTimeline.append(new TweenLite(this.myBlueHighlight,HIGHLIGHT_SCALE_DURATION,{"width":BLUE_HIGHLIGHT_WIDTH}));
         this.mToggleAnimTimeline.append(new TweenLite(this.myHighlightGlow,SLIDE_DURATION,{"alpha":HIGHLIGHT_GLOW_FOCUS_ALPHA}));
         this.mToggleAnimTimeline.append(new TweenLite(this.myListBackground,BACKGROUND_GROW_DURATION,{
            "height":this.mListHeight,
            "alpha":1
         }));
         this.mToggleAnimTimeline.append(new TweenLite(this.myItemMount,SLIDE_DURATION,{"alpha":1}));
         this.mToggleAnimTimeline.append(new TweenLite(this.myGlow,SLIDE_DURATION,{
            "height":this.mListHeight,
            "alpha":1
         }));
         this.mToggleAnimTimeline.append(new TweenLite(this.myManageButton,SLIDE_DURATION,{
            "alpha":1,
            "onComplete":this.listenForClick
         }));
         this.mToggleAnimTimeline.play();
         SoundUtil.getInstance().playSound("ui_roster_click_dropdown_01");
      }
      
      public function hide() : void
      {
         if(false == this.mShown)
         {
            return;
         }
         this.mShown = false;
         this.clearAnimation();
         this.mToggleAnimTimeline.append(new TweenLite(this.myManageButton,SLIDE_DURATION,{"alpha":0}));
         this.mToggleAnimTimeline.append(new TweenLite(this.myGlow,SLIDE_DURATION,{
            "height":10,
            "alpha":0
         }));
         this.mToggleAnimTimeline.append(new TweenLite(this.myItemMount,SLIDE_DURATION,{"alpha":0}));
         this.mToggleAnimTimeline.append(new TweenLite(this.myListBackground,BACKGROUND_GROW_DURATION,{
            "height":10,
            "alpha":0
         }));
         this.mToggleAnimTimeline.append(new TweenLite(this.myHighlightGlow,SLIDE_DURATION,{"alpha":0}));
         this.mToggleAnimTimeline.append(new TweenLite(this.myBlueHighlight,HIGHLIGHT_SCALE_DURATION,{
            "width":0,
            "onComplete":this.hideListBackground
         }));
         this.mToggleAnimTimeline.play();
         if(this.stage != null)
         {
            stage.removeEventListener(MouseEvent.CLICK,this.onStageClickHandle);
         }
         SoundUtil.getInstance().playSound("ui_roster_click_close_01");
      }
      
      override public function get height() : Number
      {
         return this.mListHeight;
      }
      
      private function listenForClick() : void
      {
         stage.addEventListener(MouseEvent.CLICK,this.onStageClickHandle);
      }
      
      private function onStageClickHandle(cEvt:MouseEvent) : void
      {
         if(this.hitTestPoint(stage.mouseX,stage.mouseY) == false)
         {
            this.hide();
         }
      }
      
      public function get currentCharacterIndex() : int
      {
         return this.mCurrentCharacterIndex;
      }
      
      public function get currentCharacter() : CharacterObj
      {
         return this.mCharacters[this.mCurrentCharacterIndex];
      }
      
      public function addOnCharacterSelectedCallback(cb:Function) : void
      {
         this.mCharacterSelectedCallback = cb;
      }
      
      public function addOnCharactersUpdatedCallback(cb:Function) : void
      {
         this.mCharactersUpdatedCallback = cb;
      }
      
      private function hideListBackground() : void
      {
         this.myItemMount.visible = false;
         this.myListBackground.visible = false;
         this.myGlow.visible = false;
         this.myManageButton.visible = false;
         this.myManageButton.unRegisterClickEvent(this.onManageClicked);
         this.myHighlightGlow.visible = false;
      }
      
      private function onCharacterSelected(dat:Object) : void
      {
         this.selectIndex(dat.index);
      }
      
      private function onCharacterFocused(dat:Object) : void
      {
         var productObj:ProductObj = CFunctionCommonContainer.GetItemInfo(this.mCharacters[dat.index].id);
         EventManager.getInstance().broadcast(BCEvent.EVT_SHOW_ITEM_INFO_PREVIEW,{
            "product":productObj,
            "compare":false
         });
      }
      
      private function onCharacterUnfocused() : void
      {
         EventManager.getInstance().broadcast(BCEvent.EVT_HIDE_ITEM_INFO_PREVIEW);
      }
      
      public function selectIndex(index:int) : void
      {
         this.mCurCharID = this.mCharacters[index].id;
         this.selectCharacter(index,false);
      }
      
      private function selectCharacter(index:int, externalSource:Boolean) : void
      {
         if(index == this.mCurrentCharacterIndex)
         {
            return;
         }
         this.mCurrentCharacterIndex = index;
         if(this.mShown)
         {
            this.updateToggles();
         }
         if(!externalSource)
         {
            this.hide();
            this.broadcastCharSelect();
         }
         if(null != this.mCharacterSelectedCallback)
         {
            this.mCharacterSelectedCallback();
         }
      }
      
      private function broadcastCharSelect() : void
      {
         EventManager.getInstance().broadcast(BCEvent.EVT_CHARACTERLOADOUT_CHANGED,this.currentCharacter);
         EventManager.getInstance().broadcast(BCEvent.EVT_SET_DEFAULT_CHARACTER,{"character":this.currentCharacter});
      }
      
      protected function bindCurChar(cResult:Object) : void
      {
         this.mCurCharID = cResult.data;
         var newIdx:uint = this.findCharIdx(this.mCurCharID);
         this.selectCharacter(newIdx,true);
      }
      
      private function findCharIdx(charID:int) : uint
      {
         var i:uint = 0;
         if(this.mCharacters != null)
         {
            for(i = 0; i < this.mCharacters.length; i++)
            {
               if(this.mCharacters[i].id == charID)
               {
                  return i;
               }
            }
         }
         return 0;
      }
      
      private function updateToggles() : void
      {
         var item:LoadoutFilterCharacterListOption = null;
         var len:int = int(this.mItems.length);
         for(var i:int = 0; i < len; i++)
         {
            item = this.mItems[i] as LoadoutFilterCharacterListOption;
            item.toggled = item.index == this.mCurrentCharacterIndex;
         }
         var numCharsOwned:int = CharacterLoadoutService.getInstance().getTotalCharsOwned();
         this.myManageButton.visible = numCharsOwned > MAX_CHARACTERS;
      }
      
      private function onManageClicked() : void
      {
         this.hide();
         EventManager.getInstance().broadcast(BCEvent.EVT_GOTO_MANAGE_CHARACTER_ROSTER);
      }
      
      private function clearItems() : void
      {
         while(this.myItemMount.numChildren > 0)
         {
            this.myItemMount.removeChildAt(0);
         }
         this.mItems = null;
      }
      
      private function clearAnimation() : void
      {
         if(null == this.mToggleAnimTimeline)
         {
            this.mToggleAnimTimeline = new TimelineLite();
         }
         else
         {
            this.mToggleAnimTimeline.kill();
            this.mToggleAnimTimeline = new TimelineLite();
         }
      }
   }
}

