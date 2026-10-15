package codo.component
{
   import codo.common.CFunctionCommonContainer;
   import codo.component.filter.LoadoutFilterCharacterList;
   import codo.constants.BCEvent;
   import codo.constants.ButtonTLog;
   import codo.constants.Common;
   import codo.constants.DataID;
   import codo.constants.SE_ID;
   import codo.localization.DictMarket;
   import codo.manager.DataManager;
   import codo.manager.EventManager;
   import codo.objects.CharacterObj;
   import codo.objects.ProductObj;
   import codo.services.CharacterLoadoutService;
   import codo.style.GlobalGuide;
   import codo.style.TextStyle;
   import codo.utils.CursorUtil;
   import codo.utils.LocalizeUtil;
   import codo.utils.SoundUtil;
   import codo.utils.TLogUtil;
   import codo.utils.TimeUtil;
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.filters.ColorMatrixFilter;
   import fsg.shared.BehaviourAudio;
   import fsg.shared.BehaviourClickable;
   import fsg.util.FsgImageHolder;
   
   public class CharacterSwitchModule extends MovieClip
   {
      
      private static const FADE_DURATION:Number = 0.15;
      
      private static const ARROW_FADE_DURATION:Number = 0.25;
      
      public var myNextArrow:CharacterSwitchModuleArrow;
      
      public var myPrevArrow:CharacterSwitchModuleArrow;
      
      public var myNextLoadoutArrow:CharacterSwitchModuleArrow;
      
      public var myPrevLoadoutArrow:CharacterSwitchModuleArrow;
      
      public var mySwapHighlight:Sprite;
      
      public var myLockIcon:Sprite;
      
      public var myStandard:MovieClip;
      
      public var myImage:FsgImageHolder;
      
      public var myPreviewImage:FsgImageHolder;
      
      public var myPreviewIcon:Sprite;
      
      public var myBackground:MovieClip;
      
      public var myFocusFill:Sprite;
      
      public var myDetails:TextField;
      
      public var myLoadoutName:TextField;
      
      public var myTotemBg:MovieClip;
      
      public var myLoadoutArrowBG:MovieClip;
      
      public var myCharacterList:LoadoutFilterCharacterList;
      
      protected var mCharacterChangeCallback:Function;
      
      private var mMaxListHeight:Number = 600;
      
      private var mCharListClickable:BehaviourClickable;
      
      private var mSwapClickable:BehaviourClickable;
      
      private var mSwapAudio:BehaviourAudio;
      
      private var mShown:Boolean = false;
      
      private var mIsPreviewShown:Boolean = false;
      
      private var mDetailsText:String;
      
      public function CharacterSwitchModule()
      {
         super();
         this.myCharacterList.addOnCharacterSelectedCallback(this.refreshDisplay);
         this.myCharacterList.addOnCharactersUpdatedCallback(this.onCharsUpdated);
         this.myNextArrow.registerClickEvent(this.onNextArrowClicked);
         this.myPrevArrow.registerClickEvent(this.onPrevArrowClicked);
         this.myFocusFill.alpha = 0;
         this.mCharListClickable = new BehaviourClickable(this.myFocusFill);
         this.mCharListClickable.addMouseDownCallback(this.onFillClicked);
         this.mCharListClickable.addMouseOverCallback(this.onFillFocused);
         this.mCharListClickable.addMouseOutCallback(this.onFillUnfocused);
         this.myPreviewIcon.visible = this.myPreviewImage.visible = false;
         this.myDetails.alignment = TextStyle.HALIGN_CENTER;
         this.myDetails.fontSize = GlobalGuide.FONT_SIZE_MICRO;
         this.myDetails.fontColor = GlobalGuide.CODO_BLUE_HIGHLIGHT;
         this.myDetails.alignmentVertical = TextStyle.VALIGN_MIDDLE;
         this.myDetails.multiline = true;
         this.myDetails.width = 86;
         this.myDetails.height = 41;
         this.myDetails.isInteractiveEnabled = false;
         this.myDetails.mouseChildren = false;
         this.myDetails.buttonMode = false;
         this.setupPreviewAndFactionAssets();
         this.setSwitchable(false);
         if(this.myDetails != null)
         {
            this.myDetails.visible = false;
         }
         if(this.myLoadoutName != null)
         {
            this.myLoadoutName.visible = false;
         }
         this.initBinds();
         this.onCharsUpdated();
      }
      
      protected function initBinds() : void
      {
         DataManager.getInstance().bind(DataID.CHARACTERLOADOUT_SELECTED_FACTION,this.bindFaction);
      }
      
      protected function bindFaction(cResult:Object) : void
      {
         this.refreshFaction();
      }
      
      protected function setupPreviewAndFactionAssets() : void
      {
         var colorFilter:ColorMatrixFilter = null;
         var matrix:Array = [];
         var value:Number = 0.33;
         var filterArr:Array = [];
         matrix = matrix.concat([value,value,value,0,0]);
         matrix = matrix.concat([value,value,value,0,0]);
         matrix = matrix.concat([value,value,value,0,0]);
         matrix = matrix.concat([0,0,0,1,0]);
         colorFilter = new ColorMatrixFilter(matrix);
         this.mySwapHighlight.alpha = 0;
         this.mSwapClickable = new BehaviourClickable(this.mySwapHighlight);
         this.mSwapClickable.addMouseDownCallback(this.onTeamSwapBtnClick);
         this.mSwapClickable.addMouseOverCallback(this.onMouseOverSwapButton);
         this.mSwapClickable.addMouseOutCallback(this.onMouseOutSwapButton);
         this.mSwapAudio = new BehaviourAudio(this.mSwapClickable);
         this.myPreviewIcon.visible = this.myPreviewImage.visible = false;
         if(this.myDetails != null)
         {
            this.myLoadoutName.wordWrap = true;
            this.myLoadoutName.alignment = TextStyle.HALIGN_CENTER;
            this.myLoadoutName.fontSize = GlobalGuide.FONT_SIZE_MICRO;
            this.myLoadoutName.fontColor = GlobalGuide.CODO_BLUE_HIGHLIGHT;
            this.myLoadoutName.width = 120;
            this.myLoadoutName.height = 26;
            this.myLoadoutName.isInteractiveEnabled = false;
            this.myLoadoutName.mouseChildren = false;
            this.myLoadoutName.buttonMode = false;
         }
         filterArr.splice(0,1,colorFilter);
         this.myPreviewImage.filters = filterArr;
      }
      
      public function show() : void
      {
         if(true == this.mShown)
         {
            return;
         }
         this.setSwitchable(true);
      }
      
      public function setWeaponLoadoutVisible(value:Boolean) : void
      {
         this.myTotemBg.visible = value;
         this.myLoadoutArrowBG.visible = this.myPrevLoadoutArrow.visible = this.myNextLoadoutArrow.visible = value;
      }
      
      private function setSwitchable(switchable:Boolean) : void
      {
         this.mShown = switchable;
         if(this.mCharListClickable != null)
         {
            this.mCharListClickable.setEnabled(switchable);
         }
         if(this.mSwapClickable != null)
         {
            this.mSwapClickable.setEnabled(switchable);
         }
         this.myNextArrow.enabled = switchable;
         this.myPrevArrow.enabled = switchable;
         if(this.myNextLoadoutArrow != null)
         {
            this.myNextLoadoutArrow.enabled = switchable;
            this.myPrevLoadoutArrow.enabled = switchable;
         }
         this.myLockIcon.visible = !switchable;
      }
      
      public function showCharacterOnly(characterOnly:Boolean) : void
      {
         this.mySwapHighlight.visible = !characterOnly;
         this.myStandard.visible = !characterOnly;
      }
      
      public function setPreviewCharacter(imgURL:String) : void
      {
         this.myPreviewImage.setImage(imgURL);
         this.mIsPreviewShown = this.myPreviewIcon.visible = this.myPreviewImage.visible = true;
         this.myDetails.fontColor = 15815448;
         this.myDetails.text = LocalizeUtil.localize(DictMarket.CONTROLS_PREVIEW_LABEL);
         this.myImage.visible = false;
         this.myBackground.gotoAndStop(2);
         this.myFocusFill.visible = false;
      }
      
      public function killPreviewImage() : void
      {
         this.myPreviewImage.clearImage();
         this.mIsPreviewShown = this.myPreviewIcon.visible = this.myPreviewImage.visible = false;
         this.myDetails.fontColor = GlobalGuide.CODO_BLUE_HIGHLIGHT;
         this.myDetails.text = this.mDetailsText;
         this.myImage.visible = true;
         this.myBackground.gotoAndStop(1);
         this.myFocusFill.visible = true;
      }
      
      public function hide() : void
      {
         if(false == this.mShown)
         {
            return;
         }
         this.setSwitchable(false);
      }
      
      public function setListMaxHeight(h:Number) : void
      {
         this.mMaxListHeight = h;
         this.updateListPosition();
      }
      
      private function updateListPosition() : void
      {
         var mListBaseYPosition:Number = NaN;
         if(this.myCharacterList.height > this.mMaxListHeight)
         {
            mListBaseYPosition = 12;
            this.myCharacterList.y = mListBaseYPosition + this.mMaxListHeight - this.myCharacterList.height;
         }
      }
      
      private function onCharsUpdated() : void
      {
         this.refreshDisplay();
         var numChars:int = this.myCharacterList.characters != null ? int(this.myCharacterList.characters.length) : 0;
         this.myNextArrow.visible = this.myPrevArrow.visible = numChars > 1;
      }
      
      public function setCurrentLoadout(i:int, s:String) : void
      {
         this.myLoadoutName.text = s;
         this.myLoadoutName.visible = true;
      }
      
      public function registerGotoNextLoadoutCallback(f:Function) : void
      {
         this.myNextLoadoutArrow.registerClickEvent(f);
      }
      
      public function registerGotoPrevLoadoutCallback(f:Function) : void
      {
         this.myPrevLoadoutArrow.registerClickEvent(f);
      }
      
      public function refreshDisplay() : void
      {
         var charData:CharacterObj = null;
         var prodData:ProductObj = null;
         if(this.mIsPreviewShown)
         {
            this.killPreviewImage();
         }
         if(this.myCharacterList.characters != null && this.myCharacterList.characters.length > 0)
         {
            this.myImage.setImage(this.myCharacterList.currentCharacter.imageURL);
            if(this.myDetails != null)
            {
               charData = this.myCharacterList.currentCharacter;
               prodData = CFunctionCommonContainer.GetItemInfo(charData.id);
               this.mDetailsText = LocalizeUtil.localize(charData.name).toUpperCase();
               if(prodData.isOwnedRental())
               {
                  this.mDetailsText += "\n" + TimeUtil.convertTimeRemainingToHHMMSS(prodData.remainSecond,false);
               }
               this.myDetails.text = this.mDetailsText;
               this.myDetails.visible = true;
            }
         }
         else if(this.myDetails != null)
         {
            this.myDetails.visible = false;
         }
         this.refreshFaction();
         if(this.mCharacterChangeCallback != null)
         {
            this.mCharacterChangeCallback();
         }
      }
      
      public function refreshFaction() : void
      {
         var SC_FRAME:int = 2;
         var TF_FRAME:int = 1;
         var faction:uint = CharacterLoadoutService.getInstance().currentLoadoutType;
         var frame:int = faction == Common.LOADOUT_TYPE_SC ? SC_FRAME : TF_FRAME;
         var sndAlias:String = faction == Common.LOADOUT_TYPE_SC ? SE_ID.UI_CHARACTER_CHANGE_FACTION_RED_TO_BLUE : SE_ID.UI_CHARACTER_CHANGE_FACTION_BLUE_TO_RED;
         this.mSwapAudio.overrideClickAudio(sndAlias);
         this.myStandard.gotoAndStop(frame);
      }
      
      public function registerCharacterChangeCallback(c:Function) : void
      {
         this.mCharacterChangeCallback = c;
      }
      
      private function onPrevArrowClicked() : void
      {
         var c:int = this.myCharacterList.currentCharacterIndex - 1;
         if(c < 0)
         {
            c = this.myCharacterList.characters.length - 1;
         }
         this.myCharacterList.selectIndex(c);
      }
      
      private function onNextArrowClicked() : void
      {
         var c:int = this.myCharacterList.currentCharacterIndex + 1;
         if(c == this.myCharacterList.characters.length)
         {
            c = 0;
         }
         this.myCharacterList.selectIndex(c);
      }
      
      private function onTeamSwapBtnClick() : void
      {
         TLogUtil.TLog_UserInput(ButtonTLog.BUTTON_CHARACTERLANDING_SWAP_TEAM);
         var faction:uint = CharacterLoadoutService.getInstance().currentLoadoutType;
         switch(faction)
         {
            case Common.LOADOUT_TYPE_SC:
               faction = Common.LOADOUT_TYPE_TF;
               break;
            case Common.LOADOUT_TYPE_TF:
            default:
               faction = Common.LOADOUT_TYPE_SC;
         }
         CharacterLoadoutService.getInstance().changeFactionIdx(faction);
         this.refreshFaction();
         EventManager.getInstance().broadcast(BCEvent.EVT_CHARACTER_FACTION_SWAP,faction == Common.LOADOUT_TYPE_SC);
      }
      
      private function onMouseOverSwapButton() : void
      {
         TweenLite.killTweensOf(this.mySwapHighlight);
         TweenLite.to(this.mySwapHighlight,FADE_DURATION,{"alpha":1});
      }
      
      private function onMouseOutSwapButton() : void
      {
         TweenLite.killTweensOf(this.mySwapHighlight);
         TweenLite.to(this.mySwapHighlight,FADE_DURATION,{"alpha":0});
      }
      
      private function onFillFocused() : void
      {
         if(!this.mShown)
         {
            return;
         }
         CursorUtil.BeginCursor(CursorUtil.CURSOR_OVER_BUTTON);
         TweenLite.killTweensOf(this.myFocusFill);
         TweenLite.to(this.myFocusFill,ARROW_FADE_DURATION,{"alpha":1});
         SoundUtil.getInstance().playSound("ui_roster_hover_01");
      }
      
      private function onFillUnfocused() : void
      {
         CursorUtil.EndCursor(CursorUtil.CURSOR_OVER_BUTTON);
         TweenLite.killTweensOf(this.myFocusFill);
         TweenLite.to(this.myFocusFill,ARROW_FADE_DURATION,{"alpha":0});
      }
      
      private function onFillClicked() : void
      {
         if(!this.mShown)
         {
            return;
         }
         if(false == this.myCharacterList.isShowing)
         {
            this.myCharacterList.show();
            this.updateListPosition();
         }
         else
         {
            this.myCharacterList.hide();
         }
      }
   }
}

