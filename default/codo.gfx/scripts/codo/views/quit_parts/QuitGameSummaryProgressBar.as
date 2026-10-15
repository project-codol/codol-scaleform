package codo.views.quit_parts
{
   import codo.common.CFunctionCommonContainer;
   import codo.event.ParaEvent;
   import codo.localization.Dict;
   import codo.objects.EXPLevelObj;
   import com.greensock.TweenLite;
   import com.greensock.easing.Cubic;
   import components.XPBar;
   import components.fsggamesummary_part.FsgGameSummaryProgressBar;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import fsg.util.FsgUtil;
   import fsg.util.ImageHolderSimple;
   
   public class QuitGameSummaryProgressBar extends MovieClip
   {
      
      public var myInvalidLevelTF:TextField;
      
      public var myXPRemainingTF:TextField;
      
      public var myCurrentPrestigeIcon:ImageHolderSimple;
      
      public var myCurrentRankTF:TextField;
      
      public var myNextRankTF:TextField;
      
      public var myNextPrestigeIcon:ImageHolderSimple;
      
      public var myProgressBar:FsgGameSummaryProgressBar;
      
      private var mProgressData:Vector.<EXPLevelObj>;
      
      private var mIsInit:Boolean = true;
      
      public function QuitGameSummaryProgressBar()
      {
         super();
         this.myXPRemainingTF.autoSize = TextFieldAutoSize.LEFT;
         this.myInvalidLevelTF.text = Dict.RANK_TABLE_CHANGED;
         this.myInvalidLevelTF.visible = false;
         this.myXPRemainingTF.alpha = 0;
      }
      
      public function set data(lvlIncrease:Vector.<EXPLevelObj>) : void
      {
         this.mProgressData = lvlIncrease;
         var total:int = int(this.mProgressData[this.mProgressData.length - 1].total);
         var current:int = int(this.mProgressData[this.mProgressData.length - 1].current);
         var targetValTxt:String = FsgUtil.commaFormatNumber(current).concat(" <font color=\'#1cc5ff\'>XP</font> / ",FsgUtil.commaFormatNumber(total)," <font color=\'#1cc5ff\'>XP</font>");
         this.myXPRemainingTF.htmlText = targetValTxt;
         this.myProgressBar.XPData = lvlIncrease;
         if(this.mIsInit)
         {
            this.myProgressBar.play();
            this.mIsInit = false;
         }
      }
      
      public function initBarAnimListeners() : void
      {
         this.myProgressBar.addEventListener(XPBar.EVT_COMPLETE,this.onXPBarCompleteHandle);
         this.myProgressBar.addEventListener(XPBar.EVT_NODE_START,this.onXPBarNodeStartHandle);
      }
      
      public function setDataInvalid() : void
      {
         this.myInvalidLevelTF.visible = true;
      }
      
      private function onXPBarNodeStartHandle(cEvt:ParaEvent) : void
      {
         this.initBar(this.mProgressData[cEvt.myPara.index]);
      }
      
      private function initBar(expData:EXPLevelObj) : void
      {
         var oldPrestige:int = 0;
         var nextLevel:int = 0;
         var oldLevel:int = expData.displayRank;
         oldPrestige = expData.prestige;
         var nextPrestige:int = oldPrestige;
         nextLevel = oldLevel + 1;
         this.myCurrentRankTF.text = oldLevel.toString();
         this.myXPRemainingTF.visible = true;
         if(nextLevel > CFunctionCommonContainer.GetPlayerMaxLevel())
         {
            nextPrestige++;
            if(nextPrestige > CFunctionCommonContainer.GetPlayerMaxPrestige())
            {
               nextPrestige = -1;
               nextLevel = -1;
            }
            else
            {
               nextLevel = 1;
            }
         }
         this.myCurrentPrestigeIcon.visible = false;
         if(oldPrestige > 0)
         {
            this.myCurrentPrestigeIcon.visible = true;
            this.myCurrentPrestigeIcon.setImage(FsgUtil.getPrestigeIcon(oldPrestige));
            this.myCurrentPrestigeIcon.addEventListener(Event.COMPLETE,this.onCurrentPrestigeImageLoaded);
         }
         this.myNextPrestigeIcon.visible = false;
         if(nextPrestige > 0)
         {
            this.myNextPrestigeIcon.visible = true;
            this.myNextPrestigeIcon.setImage(FsgUtil.getPrestigeIcon(nextPrestige));
            this.myNextPrestigeIcon.addEventListener(Event.COMPLETE,this.onNextPrestigeImageLoaded);
         }
         this.myCurrentRankTF.x = 75;
         this.myNextRankTF.x = 645;
         this.myNextRankTF.visible = true;
         this.myNextRankTF.text = nextLevel > 0 ? nextLevel.toString() : "-";
         if(!this.myNextPrestigeIcon.visible && !this.myCurrentPrestigeIcon.visible)
         {
            gotoAndStop(2);
            this.myCurrentRankTF.x = 33;
            this.myNextRankTF.x = 689;
         }
         else if(this.myNextPrestigeIcon.visible && this.myCurrentPrestigeIcon.visible)
         {
            gotoAndStop(1);
         }
         else if(this.myCurrentPrestigeIcon.visible && !this.myNextPrestigeIcon.visible)
         {
            gotoAndStop(3);
            this.myNextRankTF.x = 689;
         }
         else
         {
            this.myCurrentRankTF.x = 33;
            gotoAndStop(4);
         }
         this.myInvalidLevelTF.x = this.myProgressBar.x;
         this.myInvalidLevelTF.width = this.myProgressBar.width;
      }
      
      protected function onCurrentPrestigeImageLoaded(e:Event) : void
      {
         this.myCurrentPrestigeIcon.removeEventListener(Event.COMPLETE,this.onCurrentPrestigeImageLoaded);
         this.sizePrestigeIconToFit(this.myCurrentPrestigeIcon.loadedAsset);
      }
      
      protected function onNextPrestigeImageLoaded(e:Event) : void
      {
         this.myNextPrestigeIcon.removeEventListener(Event.COMPLETE,this.onNextPrestigeImageLoaded);
         this.sizePrestigeIconToFit(this.myNextPrestigeIcon.loadedAsset);
      }
      
      private function sizePrestigeIconToFit(asset:DisplayObject) : void
      {
         asset.width = 64;
         asset.height = 64;
         var scale:Number = Math.min(asset.scaleX,asset.scaleY);
         asset.scaleX = asset.scaleY = scale;
      }
      
      private function onXPBarCompleteHandle(cEvt:Event) : void
      {
         var offsetRatio:Number = this.myInvalidLevelTF.width * this.myProgressBar.myBarMask.scaleX;
         this.myXPRemainingTF.x = this.myInvalidLevelTF.x + offsetRatio + 10;
         var offset:Number = this.myXPRemainingTF.x + this.myXPRemainingTF.textWidth;
         if(offset > this.myInvalidLevelTF.width)
         {
            this.myXPRemainingTF.x = this.myInvalidLevelTF.x + (offsetRatio - this.myXPRemainingTF.textWidth) - 10;
         }
         TweenLite.to(this.myXPRemainingTF,0.3,{
            "alpha":1,
            "ease":Cubic.easeOut
         });
         this.myProgressBar.removeEventListener(XPBar.EVT_COMPLETE,this.onXPBarCompleteHandle);
         this.myProgressBar.removeEventListener(XPBar.EVT_NODE_START,this.onXPBarNodeStartHandle);
      }
   }
}

