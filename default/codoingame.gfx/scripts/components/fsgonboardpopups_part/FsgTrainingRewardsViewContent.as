package components.fsgonboardpopups_part
{
   import codo.constants.BCInGameEvent;
   import codo.interfaces.IDisposable;
   import codo.localization.DictCoopSummary;
   import codo.localization.DictOnBoard;
   import codo.objects.ItemObj;
   import codo.utils.LocalizeUtil;
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.utils.getDefinitionByName;
   import fsg.shared.popups.PopupContentBase;
   import fsg.shared.popups.PopupUnlockItem;
   
   public class FsgTrainingRewardsViewContent extends PopupContentBase implements IDisposable
   {
      
      private var mUnlockItems:Vector.<PopupUnlockItem>;
      
      private var mUnlockItemsHolder:Sprite;
      
      private var mFinalScore:uint = 0;
      
      public var myDetailsTF:TextField;
      
      public function FsgTrainingRewardsViewContent()
      {
         super();
         this.myDetailsTF.autoSize = TextFieldAutoSize.LEFT;
         this.mUnlockItemsHolder = addChild(new Sprite()) as Sprite;
      }
      
      override protected function configPopUpBase() : void
      {
         var contentPos:Point = null;
         super.configPopUpBase();
         contentPos = myPopupBase.contentPosition;
         myPopupBase.headerText = LOCALIZE(DictOnBoard.ONBOARD_TRAINING_REWARDS).toUpperCase();
         myPopupBase.subheaderText = LOCALIZE(DictOnBoard.ONBOARD_TRAINING_REWARDS_TITLE).toUpperCase();
         myPopupBase.animateFrame = true;
         this.myDetailsTF.y = contentPos.y + CONTENT_TOP_PADDING;
         this.myDetailsTF.x = this.mUnlockItemsHolder.x = contentPos.x + CONTENT_PADDING;
      }
      
      public function set finalScore(score:uint) : void
      {
         this.mFinalScore = score;
      }
      
      public function setDataProvider(data:Vector.<ItemObj>) : void
      {
         var unlockItem:PopupUnlockItem = null;
         var prevOption:PopupUnlockItem = null;
         var itemData:ItemObj = null;
         var detailsTxtBase:String = null;
         var metric:uint = 0;
         var ITEM_WIDTH:uint = 245;
         var finalScore:uint = uint(data.shift().level);
         var i:uint = 0;
         var len:uint = data.length;
         var unlockItemClass:Class = getDefinitionByName("fsg.popups.fsgPopupUnlockItem") as Class;
         var optionPadding:uint = 0;
         var availableSpace:uint = myPopupBase.contentInnerWidth - CONTENT_PADDING * 2;
         var unlockNum:uint = 0;
         var previousUnlocks:uint = 0;
         this.mFinalScore = Math.max(this.mFinalScore,finalScore);
         if(this.mFinalScore > finalScore)
         {
            detailsTxtBase = LOCALIZE(DictOnBoard.ONBOARD_TRAINING_REWARDS_REPEAT_PLAY_DESC).toUpperCase();
            metric = this.mFinalScore;
         }
         else
         {
            if(finalScore > 0 && finalScore < 3)
            {
               unlockNum = 1;
            }
            else if(finalScore > 2 && finalScore < 5)
            {
               unlockNum = 2;
            }
            else if(finalScore == 5)
            {
               unlockNum = 3;
            }
            detailsTxtBase = LOCALIZE(DictOnBoard.ONBOARD_TRAINING_REWARDS_DESC).toUpperCase();
            metric = unlockNum;
         }
         this.myDetailsTF.text = LocalizeUtil.replaceConversionString(detailsTxtBase,[finalScore,metric]);
         this.mUnlockItemsHolder.y = this.myDetailsTF.y + this.myDetailsTF.textHeight + 40;
         for(this.dispose(); i < len; )
         {
            itemData = data[i];
            unlockItem = this.mUnlockItemsHolder.addChild(new unlockItemClass()) as PopupUnlockItem;
            this.mUnlockItems[i] = unlockItem;
            data[i].name = "@" + itemData.name;
            unlockItem.setItemData(data[i],true);
            this.mUnlockItems[i].activateStars = this.mFinalScore;
            if(i > 0)
            {
               prevOption = this.mUnlockItems[i - 1];
               unlockItem.x = prevOption.x + ITEM_WIDTH + optionPadding;
            }
            else
            {
               optionPadding = (availableSpace - ITEM_WIDTH * 3) / 2;
            }
            if(itemData.isBought)
            {
               previousUnlocks++;
            }
            i++;
         }
      }
      
      override public function initListeners() : void
      {
         myPopupBase.configConfirmButton(LOCALIZE(DictOnBoard.ONBOARD_TRAINING_FINISH).toUpperCase(),this.onFinishClicked);
         myPopupBase.configCancelButton(DictCoopSummary.UI_PLAY_AGAIN,this.onTryAgainBtnClick);
      }
      
      private function onTryAgainBtnClick() : void
      {
         this.broadcast(BCInGameEvent.TRAINING_TRY_AGAIN);
      }
      
      private function onFinishClicked() : void
      {
         this.broadcast(BCInGameEvent.TRAINING_SKIP);
      }
      
      public function dispose() : void
      {
         var i:uint = 0;
         var len:uint = 0;
         var item:PopupUnlockItem = null;
         if(this.mUnlockItemsHolder != null && this.mUnlockItemsHolder.numChildren > 0)
         {
            i = 0;
            len = uint(this.mUnlockItemsHolder.numChildren);
            for each(item in this.mUnlockItems)
            {
               this.mUnlockItemsHolder.removeChild(item);
            }
         }
         this.mUnlockItems = new Vector.<PopupUnlockItem>(0);
      }
   }
}

