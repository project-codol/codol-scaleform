package components.fsgonboardpopups_part.character
{
   import codo.base.BaseSubElement;
   import codo.constants.BCEvent;
   import codo.constants.GameInfo;
   import codo.constants.PageID;
   import codo.interfaces.IDisposable;
   import codo.localization.DictOnBoard;
   import codo.objects.OnboardCharacterOptionObj;
   import codo.utils.CursorUtil;
   import codo.utils.ScaleformUtil;
   import com.greensock.TweenLite;
   import com.greensock.easing.Cubic;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.utils.getDefinitionByName;
   
   public class FsgCharacterSelectViewPanel extends BaseSubElement implements IDisposable
   {
      
      private static const ANIMATION_SPEED:Number = 0.2;
      
      private static const PANEL_SCALE:Number = 0.9;
      
      private static const CHAR_ITEM_ID_WEI:uint = 592;
      
      private static const CHAR_ITEM_ID_MARCUS:uint = 612;
      
      private static const CHAR_ITEM_ID_COWBOY:uint = 686;
      
      private static const CHAR_ITEM_ID_MOUNTAIN_MAN:uint = 1945;
      
      private static const CHAR_ITEM_ID_HERNANDEZ:uint = 792;
      
      private var mPanelHolder:Sprite;
      
      private var mCharacters:Vector.<FsgCharacterSelectItem>;
      
      private var mSelectedCharacter:FsgCharacterSelectItem;
      
      private var mPanelBaseX:uint;
      
      private var mPanelBaseY:uint;
      
      private var mIsStageClickEnabled:Boolean = true;
      
      public var myBounds:Sprite;
      
      public function FsgCharacterSelectViewPanel()
      {
         super();
      }
      
      public function initPanel() : void
      {
         var ITEM_PADDING:int = 0;
         var itemDataObj:OnboardCharacterOptionObj = null;
         var itemData:Vector.<OnboardCharacterOptionObj> = null;
         var len:uint = 0;
         var i:uint = 0;
         var item:FsgCharacterSelectItem = null;
         var prevItem:FsgCharacterSelectItem = null;
         var itemClass:Class = null;
         ITEM_PADDING = -5;
         var PANEL_START_Y:uint = 60;
         itemData = ScaleformUtil.isScaleform ? this.returnCharacterOptions() : this.returnDEBUGCharacterOptions();
         len = itemData.length;
         i = 0;
         y = PANEL_START_Y;
         this.mCharacters = new Vector.<FsgCharacterSelectItem>(0);
         this.mPanelHolder = addChild(new Sprite()) as Sprite;
         this.mPanelHolder.mouseEnabled = mouseEnabled = false;
         for(stage.addEventListener(MouseEvent.CLICK,this.onStageMouseClick,false,0,true); i < len; )
         {
            itemDataObj = itemData[i];
            itemClass = itemDataObj.characterImageClassPath;
            item = this.mPanelHolder.addChild(new itemClass()) as FsgCharacterSelectItem;
            item.clickCallback = this.onCharacterSelected;
            item.mouseOverCallback = this.onCharacterFocused;
            item.mouseOutCallback = this.onCharacterUnFocused;
            item.panelAnimationCompleteCallback = this.onPanelAnimComplete;
            item.mouseEnabled = false;
            item.data = itemDataObj;
            item.index = i;
            this.mCharacters[i] = item;
            if(i > 0)
            {
               prevItem = this.mCharacters[i - 1];
               item.x = (-item.myHitArea.x * item.scaleX + prevItem.x + (prevItem.width + prevItem.myHitArea.x) * prevItem.scaleX + ITEM_PADDING) * this.mPanelHolder.scaleX;
            }
            i++;
         }
         this.sortDisplayObjectsByFilter(this.mPanelHolder,"characterDepth");
         var startX:uint = item.width * 0.5;
         this.mPanelHolder.x = this.mPanelBaseX = startX + (GameInfo.DEFAULT_WIDTH - this.mPanelHolder.width) * 0.5;
         this.mPanelHolder.y = this.mPanelBaseY = GameInfo.DEFAULT_HEIGHT * 0.5;
         this.mCharacters[1].x -= 35;
         this.mCharacters[3].x += 15;
      }
      
      private function onStageMouseClick(e:MouseEvent) : void
      {
         if(e.target == stage || e.target == this.myBounds)
         {
            this.onCharacterSelectionCancelled();
         }
      }
      
      private function sortDisplayObjectsByFilter(container:Sprite, filter:String) : void
      {
         var child:DisplayObject = null;
         var numChildren:int = container.numChildren;
         if(numChildren < 2)
         {
            return;
         }
         var children:Array = new Array(numChildren);
         var i:int = -1;
         while(++i < numChildren)
         {
            children[i] = container.getChildAt(i);
         }
         children.sortOn(filter,Array.NUMERIC);
         i = -1;
         while(++i < numChildren)
         {
            child = DisplayObject(children[i]);
            if(i != container.getChildIndex(child))
            {
               container.setChildIndex(child,i);
            }
         }
      }
      
      private function onCharacterUnFocused(selectedClip:FsgCharacterSelectItem) : void
      {
         this.sortDisplayObjectsByFilter(this.mPanelHolder,"characterDepth");
      }
      
      private function onCharacterFocused(selectedClip:FsgCharacterSelectItem) : void
      {
         this.mPanelHolder.setChildIndex(selectedClip,this.mPanelHolder.numChildren - 1);
      }
      
      private function onPanelAnimComplete() : void
      {
         this.mIsStageClickEnabled = true;
      }
      
      private function onCharacterSelected(selectedClip:FsgCharacterSelectItem) : void
      {
         var item:FsgCharacterSelectItem = null;
         this.mIsStageClickEnabled = false;
         if(this.mSelectedCharacter != null)
         {
            this.mSelectedCharacter.isSelected = false;
         }
         this.mSelectedCharacter = selectedClip;
         var pageEventData:Object = {
            "page":PageID.CHARACTER_SELECT_DETAILS,
            "routeData":{
               "characterSelectOptions":this.returnCharacterOptions(),
               "selectedCharacterIndex":this.mSelectedCharacter.index
            }
         };
         broadcast(BCEvent.EVT_ROUTE_TO_PAGE,pageEventData);
         while(this.mPanelHolder.numChildren > 0)
         {
            this.mPanelHolder.removeChildAt(0);
         }
      }
      
      public function dispose() : void
      {
         stage.removeEventListener(MouseEvent.CLICK,this.onStageMouseClick);
      }
      
      private function onCharacterSelectionCancelled() : void
      {
         var item:FsgCharacterSelectItem = null;
         if(!this.mIsStageClickEnabled)
         {
            return;
         }
         for each(item in this.mCharacters)
         {
            item.isSelected = false;
            item.fade(false);
            item.enable();
         }
         this.sortDisplayObjectsByFilter(this.mPanelHolder,"characterDepth");
         TweenLite.to(this.mPanelHolder,ANIMATION_SPEED,{
            "x":this.mPanelBaseX,
            "scaleX":1,
            "scaleY":1,
            "ease":Cubic.easeIn,
            "overwrite":1
         });
      }
      
      private function returnCharacterOptions() : Vector.<OnboardCharacterOptionObj>
      {
         return new <OnboardCharacterOptionObj>[new OnboardCharacterOptionObj(CHAR_ITEM_ID_MOUNTAIN_MAN,DictOnBoard.ONBOARDING_CHARACTER_SELECT_CHAR4_NAME,DictOnBoard.ONBOARDING_CHARACTER_SELECT_CHAR4_CODENAME,DictOnBoard.ONBOARDING_CHARACTER_SELECT_CHAR4_SLOGAN,DictOnBoard.ONBOARDING_CHARACTER_SELECT_CHAR4_BIO,"27,180.3, 97.5",fsgCharacterSelectViewItemMountainMan,null,3,null,"scaleform_ash/itemicons/cha_MOUveteranA_item_icon"),new OnboardCharacterOptionObj(CHAR_ITEM_ID_HERNANDEZ,DictOnBoard.ONBOARDING_CHARACTER_SELECT_CHAR5_NAME,DictOnBoard.ONBOARDING_CHARACTER_SELECT_CHAR5_CODENAME,DictOnBoard.ONBOARDING_CHARACTER_SELECT_CHAR5_SLOGAN,DictOnBoard.ONBOARDING_CHARACTER_SELECT_CHAR5_BIO,"27,170.1, 62.6",fsgCharacterSelectViewItemHernandez,null,1,null,"scaleform_ash/itemicons/cha_INFbaseE_item_icon"),new OnboardCharacterOptionObj(CHAR_ITEM_ID_COWBOY,DictOnBoard.ONBOARDING_CHARACTER_SELECT_CHAR3_NAME,DictOnBoard.ONBOARDING_CHARACTER_SELECT_CHAR3_CODENAME,DictOnBoard.ONBOARDING_CHARACTER_SELECT_CHAR3_SLOGAN
         ,DictOnBoard.ONBOARDING_CHARACTER_SELECT_CHAR3_BIO,"30,175.2,90.8",fsgCharacterSelectViewItemCowboy,null,4,null,"scaleform_ash/itemicons/cha_COWprestigeA_item_icon"),new OnboardCharacterOptionObj(CHAR_ITEM_ID_MARCUS,DictOnBoard.ONBOARDING_CHARACTER_SELECT_CHAR2_NAME,DictOnBoard.ONBOARDING_CHARACTER_SELECT_CHAR2_CODENAME,DictOnBoard.ONBOARDING_CHARACTER_SELECT_CHAR2_SLOGAN,DictOnBoard.ONBOARDING_CHARACTER_SELECT_CHAR2_BIO,"26,185.4,104.5",fsgCharacterSelectViewItemMarcus,null,2,null,"scaleform_ash/itemicons/cha_GREbaseA_item_icon"),new OnboardCharacterOptionObj(CHAR_ITEM_ID_WEI,DictOnBoard.ONBOARDING_CHARACTER_SELECT_CHAR1_NAME,DictOnBoard.ONBOARDING_CHARACTER_SELECT_CHAR1_CODENAME,DictOnBoard.ONBOARDING_CHARACTER_SELECT_CHAR1_SLOGAN,DictOnBoard.ONBOARDING_CHARACTER_SELECT_CHAR1_BIO,"28,177.8,83.2",fsgCharacterSelectViewItemWei,null,0,null,"scaleform_ash/itemicons/cha_ACUbaseA_item_icon")];
      }
      
      private function returnDEBUGCharacterOptions() : Vector.<OnboardCharacterOptionObj>
      {
         return new <OnboardCharacterOptionObj>[new OnboardCharacterOptionObj(CHAR_ITEM_ID_WEI,"JOHN MULLINS","VIPER","\"TO THE GUNS!\"","As a child, Poole was precocious and a voracious reader, but the death of his father forced him to abandon hopes for college and focus on taking care of his mother and 3 sisters. This upbringing forged Poole into the leader he is today. He is calm, selfless and honorable – a commander that everyone in his squad respects.","29,178,91.2",getDefinitionByName("fsgCharacterSelectViewItemWei") as Class,null,0),new OnboardCharacterOptionObj(CHAR_ITEM_ID_MARCUS,"VANCE CHI","TIGER","\"SEMPER FIDELIS\"","As a child, Poole was precocious and a voracious reader, but the death of his father forced him to abandon hopes for college and focus on taking care of his mother and 3 sisters. This upbringing forged Poole into the leader he is today. He is calm, selfless and honorable – a commander that everyone in his squad respects.","33,188,111.5",getDefinitionByName("fsgCharacterSelectViewItemMarcus") as Class
         ,null,2),new OnboardCharacterOptionObj(CHAR_ITEM_ID_COWBOY,"TOM STEELE","DRAGONFIRE","\"BURN IT DOWN\"","As a child, Poole was precocious and a voracious reader, but the death of his father forced him to abandon hopes for college and focus on taking care of his mother and 3 sisters. This upbringing forged Poole into the leader he is today. He is calm, selfless and honorable – a commander that everyone in his squad respects.","27,185,102.8",getDefinitionByName("fsgCharacterSelectViewItemCowboy") as Class,null,4),new OnboardCharacterOptionObj(CHAR_ITEM_ID_MOUNTAIN_MAN,"JOHNNY DANGER","SWORD","\"PILE EM HIGH\"","As a child, Poole was precocious and a voracious reader, but the death of his father forced him to abandon hopes for college and focus on taking care of his mother and 3 sisters. This upbringing forged Poole into the leader he is today. He is calm, selfless and honorable – a commander that everyone in his squad respects.","22,193,113.4",getDefinitionByName("fsgCharacterSelectViewItemMountainMan") as Class
         ,null,3),new OnboardCharacterOptionObj(CHAR_ITEM_ID_HERNANDEZ,"JOHNNY DANGER","SWORD","\"RUN THEM THROUGH\"","As a child, Poole was precocious and a voracious reader, but the death of his father forced him to abandon hopes for college and focus on taking care of his mother and 3 sisters. This upbringing forged Poole into the leader he is today. He is calm, selfless and honorable – a commander that everyone in his squad respects.","24,173,63",getDefinitionByName("fsgCharacterSelectViewItemHernandez") as Class,null,1)];
      }
   }
}

