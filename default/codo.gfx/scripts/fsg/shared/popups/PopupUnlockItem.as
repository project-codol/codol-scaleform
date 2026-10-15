package fsg.shared.popups
{
   import codo.constants.ComponentCSS;
   import codo.interfaces.IDisposable;
   import codo.localization.Dict;
   import codo.localization.DictOnBoard;
   import codo.objects.ItemObj;
   import codo.utils.LocalizeUtil;
   import codo.utils.StringUtil;
   import components.fsgonboardpopups_part.FsgUnlockItemCompleteBanner;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.utils.getDefinitionByName;
   import fsg.util.FsgImageHolder;
   import scaleform.gfx.TextFieldEx;
   
   public class PopupUnlockItem extends Sprite implements IDisposable
   {
      
      private static const FRAME_INCOMPLETE:uint = 1;
      
      private static const FRAME_COMPLETE:uint = 2;
      
      public static const REWARD_NUM:uint = 5;
      
      public var myItemUnlockCompleteBanner:FsgUnlockItemCompleteBanner;
      
      public var myOutline:MovieClip;
      
      public var myUnlockTitleTF:TextField;
      
      public var myTimeRemainingTF:TextField;
      
      public var myNumStarLabelTF:TextField;
      
      public var myRewardDescTF:TextField;
      
      public var myBkg:MovieClip;
      
      public var myStarPanelBkg:Sprite;
      
      public var myUnlockImageHolder:FsgImageHolder;
      
      private var mRewardHolder:Sprite;
      
      private var mRewards:Vector.<MovieClip>;
      
      private var mItemData:ItemObj;
      
      private var mLevel:uint;
      
      public function PopupUnlockItem()
      {
         super();
         TextFieldEx.setVerticalAlign(this.myNumStarLabelTF,TextFieldEx.VALIGN_CENTER);
         this.myNumStarLabelTF.autoSize = this.myUnlockTitleTF.autoSize = TextFieldAutoSize.LEFT;
         this.myTimeRemainingTF.autoSize = TextFieldAutoSize.RIGHT;
         this.myTimeRemainingTF.visible = this.myRewardDescTF.visible = this.myItemUnlockCompleteBanner.visible = false;
         this.mRewardHolder = addChild(new Sprite()) as Sprite;
         this.mRewards = new Vector.<MovieClip>(0);
      }
      
      public function setItemData(data:ItemObj, desaturateStars:Boolean = true) : void
      {
         var star:MovieClip = null;
         var prevStar:MovieClip = null;
         var LOCALIZE:Function = LocalizeUtil.localize;
         var PADDING:uint = 10;
         var starClass:Class = getDefinitionByName("fsg.popups.fsgPopupUnlockStar") as Class;
         var i:uint = 0;
         this.myUnlockTitleTF.text = LOCALIZE(data.name).toUpperCase();
         this.myNumStarLabelTF.text = LocalizeUtil.replaceConversionString(LOCALIZE(DictOnBoard.ONBOARD_TRAINING_REWARD_STAR_NUM),[data.level]);
         if(data.description != null)
         {
            this.myRewardDescTF.visible = true;
            this.myRewardDescTF.text = data.description;
         }
         this.mItemData = data;
         this.mLevel = data.level;
         if(data.description != null)
         {
            this.myRewardDescTF.text = LOCALIZE(data.description).toUpperCase();
         }
         this.myUnlockImageHolder.addEventListener(Event.COMPLETE,this.positionImage);
         for(this.myUnlockImageHolder.setImage(data.imageURL); i < REWARD_NUM; )
         {
            star = this.mRewardHolder.addChild(new starClass()) as MovieClip;
            this.mRewards[i] = star;
            if(desaturateStars)
            {
               MovieClip(star.getChildByName("myFill")).gotoAndStop(FRAME_COMPLETE);
            }
            if(i > 0)
            {
               prevStar = this.mRewards[i - 1];
               star.x = prevStar.x + prevStar.width;
            }
            if(i < data.level)
            {
               star.gotoAndStop(FRAME_COMPLETE);
            }
            i++;
         }
         this.mRewardHolder.x = this.myStarPanelBkg.width - (this.mRewardHolder.width + PADDING);
         this.mRewardHolder.y = this.myStarPanelBkg.y + (this.myStarPanelBkg.height * 0.5 - this.mRewardHolder.height * 0.5);
      }
      
      public function set activateStars(numStars:uint) : void
      {
         var i:uint = 0;
         if(numStars >= this.mLevel)
         {
            for(this.isUnlocked = true; i < this.mLevel; )
            {
               this.mRewards[i].gotoAndStop(FRAME_COMPLETE);
               MovieClip(this.mRewards[i].getChildByName("myFill")).gotoAndStop(FRAME_INCOMPLETE);
               i++;
            }
         }
      }
      
      private function positionImage(e:Event) : void
      {
         var bmpImage:DisplayObject = null;
         var boundsWidth:uint = 0;
         var textHeightOffset:uint = 0;
         var boundsHeight:uint = 0;
         var setScale:Number = NaN;
         var scaleAmount:Number = NaN;
         this.myUnlockImageHolder.removeEventListener(Event.COMPLETE,this.positionImage);
         if(this.mItemData.specialPara != null && this.mItemData.specialPara.length > 0)
         {
            bmpImage = this.myUnlockImageHolder.getChildAt(0);
            boundsWidth = this.myBkg.width;
            textHeightOffset = !StringUtil.isEmpty(this.myUnlockTitleTF.text) ? uint(this.myUnlockTitleTF.textHeight) : 0;
            boundsHeight = this.myBkg.height - (this.myStarPanelBkg.height + textHeightOffset);
            setScale = this.mItemData.specialPara[0] != null ? this.mItemData.specialPara[0] as Number : 1;
            scaleAmount = 1;
            bmpImage.width = boundsWidth * setScale;
            bmpImage.height = boundsHeight * setScale;
            scaleAmount = Math.min(setScale,Math.max(bmpImage.scaleX,bmpImage.scaleY));
            bmpImage.scaleY = bmpImage.scaleX = scaleAmount;
            bmpImage.x = (boundsWidth - bmpImage.width) * 0.5;
            bmpImage.y = (boundsHeight - bmpImage.height) * 0.5;
         }
      }
      
      public function set isUnlocked(isUnlocked:Boolean) : void
      {
         this.myItemUnlockCompleteBanner.visible = isUnlocked;
         this.myNumStarLabelTF.textColor = isUnlocked ? ComponentCSS.FSG_COLOR_BLUE : 16777215;
         this.myBkg.gotoAndStop(isUnlocked ? FRAME_COMPLETE : FRAME_INCOMPLETE);
         if(isUnlocked)
         {
            this.myItemUnlockCompleteBanner.x = this.myItemUnlockCompleteBanner.y = 0;
            this.myItemUnlockCompleteBanner.bannerText = Dict.WON;
            this.myOutline.gotoAndStop(FRAME_COMPLETE);
         }
      }
      
      public function dispose() : void
      {
         var clip:MovieClip = null;
         for each(clip in this.mRewards)
         {
            this.mRewardHolder.removeChild(clip);
         }
         this.mRewards = new Vector.<MovieClip>(0);
      }
   }
}

