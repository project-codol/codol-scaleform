package codo.component.career
{
   import codo.common.CFunctionCommonContainer;
   import codo.component.TextField;
   import codo.constants.DataCommonID;
   import codo.constants.GameInfo;
   import codo.constants.MarketMenuData;
   import codo.localization.Dict;
   import codo.localization.DictMatchResults;
   import codo.localization.DictRoom;
   import codo.manager.DataManager;
   import codo.objects.PlayerObj;
   import codo.objects.ProductObj;
   import codo.style.GlobalGuide;
   import codo.style.TextStyle;
   import codo.utils.ItemUtil;
   import codo.utils.LocalizeUtil;
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import fsg.util.FsgImageHolder;
   import fsg.util.FsgUtil;
   
   public class XPProgressTooltip extends MovieClip
   {
      
      private static const FADE_DURATION:Number = 0.15;
      
      private static const SHOW_DELAY:Number = 0.15;
      
      private static const PREVIEW_BOX_TOP_STOP:Number = 90;
      
      private static const CAP_WIDTH:Number = 23;
      
      public var myBackground:Sprite;
      
      public var myProgressFillCap:Sprite;
      
      public var myProgressFill:Sprite;
      
      public var myProgressFillBackground:Sprite;
      
      public var myRewardImage:FsgImageHolder;
      
      public var myCurrentPrestigeIcon:FsgImageHolder;
      
      public var myNextPrestigeIcon:FsgImageHolder;
      
      public var myHeader:TextField;
      
      public var myLevelLabel:TextField;
      
      public var myNextLevel:TextField;
      
      public var myCurrentLevel:TextField;
      
      public var myRewardLabel:TextField;
      
      public var myNoRewardLabel:TextField;
      
      public var myXPValue:TextField;
      
      public var myXPLabel:TextField;
      
      private var mShowing:Boolean = false;
      
      public function XPProgressTooltip()
      {
         super();
         alpha = 0;
         visible = false;
         this.myHeader.fontSize = GlobalGuide.FONT_SIZE_EXTRA_SMALL;
         this.myHeader.fontColor = GlobalGuide.BLACK;
         this.myXPLabel.font = GlobalGuide.FONT_FACE_NUMBERS;
         this.myXPValue.font = GlobalGuide.FONT_FACE_NUMBERS;
         this.myXPLabel.fontSize = GlobalGuide.FONT_SIZE_LARGE;
         this.myXPLabel.fontColor = GlobalGuide.CODO_BLUE_HIGHLIGHT;
         this.myXPValue.fontSize = GlobalGuide.FONT_SIZE_LARGE;
         this.myLevelLabel.fontSize = GlobalGuide.FONT_SIZE_EXTRA_SMALL;
         this.myLevelLabel.fontColor = GlobalGuide.GRAY_50;
         this.myNextLevel.font = GlobalGuide.FONT_FACE_NUMBERS;
         this.myCurrentLevel.font = GlobalGuide.FONT_FACE_NUMBERS;
         this.myNextLevel.fontSize = GlobalGuide.FONT_SIZE_MEDIUM;
         this.myCurrentLevel.fontSize = GlobalGuide.FONT_SIZE_MEDIUM;
         this.myNextLevel.alignment = TextStyle.HALIGN_CENTER;
         this.myCurrentLevel.alignment = TextStyle.HALIGN_CENTER;
         this.myNextLevel.fontColor = GlobalGuide.BLACK;
         this.myRewardLabel.fontSize = GlobalGuide.FONT_SIZE_EXTRA_SMALL;
         this.myRewardLabel.alignment = TextStyle.HALIGN_CENTER;
         this.myNoRewardLabel.fontSize = GlobalGuide.FONT_SIZE_EXTRA_SMALL;
         this.myNoRewardLabel.wordWrap = true;
         this.myNoRewardLabel.alignment = TextStyle.HALIGN_CENTER;
         this.myNoRewardLabel.visible = false;
         this.myHeader.width = 300;
         this.myLevelLabel.width = 300;
         this.myXPValue.width = 300;
         this.myCurrentLevel.width = 41;
         this.myNextLevel.width = 41;
         this.myXPLabel.height = 40;
         this.myXPValue.height = 40;
         this.myRewardLabel.width = 128;
         this.myNoRewardLabel.width = 100;
         this.myNoRewardLabel.height = 128;
         this.myHeader.text = LocalizeUtil.localize(DictRoom.SUMMARY_PROGRESS_TITLE);
         this.myRewardLabel.text = LocalizeUtil.localize(DictMatchResults.REWARD_LABEL);
         this.myXPLabel.text = LocalizeUtil.localize(Dict.XP);
         this.myXPValue.x = this.myXPLabel.x + this.myXPLabel.textWidth + 7;
      }
      
      public function updateProgress() : Number
      {
         var xpMin:int = 0;
         var xpMax:int = 0;
         var ratio:Number = NaN;
         var length:int = 0;
         var i:int = 0;
         var currentUnlockIndex:int = 0;
         var prestigeLevel:int = 0;
         var prestigeNextLevel:int = 0;
         var index:int = 0;
         var itemArray:Array = null;
         var prod:ProductObj = null;
         var xpCurrent:int = CFunctionCommonContainer.GetPlayerXP();
         var playerLevel:int = CFunctionCommonContainer.GetPlayerLevel();
         var playerPrestigeLevel:int = CFunctionCommonContainer.GetPlayerPrestige();
         this.myLevelLabel.text = PlayerObj.getRankName(playerLevel);
         this.myXPValue.text = xpCurrent.toString();
         if(playerPrestigeLevel == CFunctionCommonContainer.GetPlayerMaxPrestige() && playerLevel == CFunctionCommonContainer.GetPlayerMaxLevel())
         {
            ratio = 1;
         }
         else
         {
            xpMin = CFunctionCommonContainer.GetXpForRank(playerLevel,playerPrestigeLevel);
            xpMax = CFunctionCommonContainer.GetTargetXpForRank(playerLevel,playerPrestigeLevel);
            ratio = (xpCurrent - xpMin) / (xpMax - xpMin);
            ratio = Math.min(1,Math.max(0,ratio));
         }
         this.myProgressFill.width = this.myProgressFillBackground.width * ratio;
         this.myProgressFillCap.x = this.myProgressFill.x + this.myProgressFill.width - CAP_WIDTH;
         this.myCurrentLevel.text = CFunctionCommonContainer.GetDisplayLevel(playerLevel);
         var nextLevel:int = playerLevel + 1;
         if(nextLevel < CFunctionCommonContainer.GetPlayerMaxLevel())
         {
            this.myNextLevel.text = CFunctionCommonContainer.GetDisplayLevel(nextLevel);
         }
         else
         {
            this.myNextLevel.text = "--";
         }
         var unlocksCount:int = 0;
         var lastLevel:int = -1;
         var unlocksPerPrestige:Array = [];
         var unlockArray:Array = DataManager.getInstance().getDP(DataCommonID.CAREER_UNLOCK_OBJ_ALL_FOR_REAL);
         if(unlockArray != null && unlockArray.length > 0)
         {
            length = int(unlockArray.length);
            for(i = 0; i < length; i++)
            {
               if(unlockArray[i] != null)
               {
                  if(unlockArray[i].level < lastLevel)
                  {
                     unlocksPerPrestige.push(unlocksCount);
                  }
                  unlocksCount++;
                  lastLevel = int(unlockArray[i].level);
               }
            }
         }
         unlocksPerPrestige.push(unlocksCount);
         if(unlockArray != null && unlockArray.length > 0)
         {
            currentUnlockIndex = playerPrestigeLevel == 0 ? 0 : int(unlocksPerPrestige[playerPrestigeLevel - 1]);
            while(Boolean(unlockArray[currentUnlockIndex + 2]) && Boolean(unlockArray[currentUnlockIndex].level < playerLevel) && unlockArray[currentUnlockIndex + 1].level <= playerLevel)
            {
               currentUnlockIndex++;
            }
            prestigeLevel = 0;
            prestigeNextLevel = 0;
            index = 0;
            while(index < unlocksPerPrestige.length)
            {
               if(currentUnlockIndex >= unlocksPerPrestige[index])
               {
                  prestigeLevel++;
               }
               if(currentUnlockIndex + 1 >= unlocksPerPrestige[index])
               {
                  prestigeNextLevel++;
               }
               index++;
            }
            playerPrestigeLevel = prestigeLevel;
            if(playerPrestigeLevel > 0)
            {
               this.myCurrentPrestigeIcon.setImage(FsgUtil.getPrestigeIcon(playerPrestigeLevel));
            }
            else
            {
               this.myCurrentPrestigeIcon.setImage("");
            }
            if(prestigeNextLevel > CFunctionCommonContainer.GetPlayerMaxPrestige() || playerPrestigeLevel == 0)
            {
               this.myNextPrestigeIcon.setImage("");
            }
            else
            {
               this.myNextPrestigeIcon.setImage(FsgUtil.getPrestigeIcon(prestigeNextLevel));
            }
         }
         this.myRewardLabel.visible = false;
         this.myRewardImage.setImage("");
         this.myNoRewardLabel.visible = true;
         this.myNoRewardLabel.text = "@SF_UI_NO_REWARDS_THIS_LEVEL";
         if(unlockArray != null && currentUnlockIndex + 1 < unlockArray.length)
         {
            itemArray = unlockArray[currentUnlockIndex + 1].items;
            if(itemArray.length > 0)
            {
               this.myRewardLabel.visible = true;
               prod = CFunctionCommonContainer.GetItemInfo(itemArray[0].id);
               if(prod.type == MarketMenuData.TYPE_CALLSIGN_TITLE)
               {
                  this.myNoRewardLabel.text = prod.name;
               }
               else
               {
                  ItemUtil.setItemImage(this.myRewardImage,prod);
                  this.myNoRewardLabel.visible = false;
               }
            }
         }
         return ratio;
      }
      
      public function showBox() : void
      {
         if(this.mShowing)
         {
            return;
         }
         this.mShowing = true;
         visible = true;
         if(stage.hasEventListener(MouseEvent.MOUSE_MOVE) == false)
         {
            stage.addEventListener(MouseEvent.MOUSE_MOVE,this.onStageMouseMoveHandle);
         }
         parent.setChildIndex(this,parent.numChildren - 1);
         TweenLite.to(this,FADE_DURATION,{
            "alpha":1,
            "delay":SHOW_DELAY
         });
         this.setLocation();
      }
      
      public function hideBox() : void
      {
         this.mShowing = false;
         TweenLite.killTweensOf(this);
         TweenLite.to(this,FADE_DURATION,{
            "alpha":0,
            "onComplete":this.onHideComplete
         });
      }
      
      private function onHideComplete() : void
      {
         stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onStageMouseMoveHandle);
         visible = false;
      }
      
      private function onStageMouseMoveHandle(cEvt:MouseEvent) : void
      {
         this.setLocation();
      }
      
      private function setLocation() : void
      {
         if(stage == null)
         {
            return;
         }
         var mousePoint:Point = new Point(stage.mouseX,stage.mouseY);
         var localMousePoint:Point = parent.globalToLocal(mousePoint);
         var temp:Number = localMousePoint.x - this.myBackground.width * 0.5;
         if(temp + this.myBackground.width > GameInfo.DEFAULT_WIDTH)
         {
            temp = GameInfo.DEFAULT_WIDTH - this.myBackground.width;
         }
         x = temp;
         temp = localMousePoint.y - this.myBackground.height * 0.5;
         if(temp + this.myBackground.height > GameInfo.DEFAULT_HEIGHT)
         {
            temp = GameInfo.DEFAULT_HEIGHT - this.myBackground.height;
         }
         else if(temp < PREVIEW_BOX_TOP_STOP)
         {
            temp = PREVIEW_BOX_TOP_STOP;
         }
         y = temp;
      }
   }
}

