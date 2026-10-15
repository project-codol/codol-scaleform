package codo.views.wargod_parts
{
   import codo.component.TextField;
   import codo.localization.DictWarGod;
   import codo.objects.WarGodGlobalSettingObj;
   import codo.objects.WarGodPlayerObj;
   import codo.objects.WarGodSeasonObj;
   import codo.style.TextStyle;
   import codo.style.WarGodGuide;
   import codo.utils.LocalizeUtil;
   import flash.display.MovieClip;
   
   public class HeroicTierProgressBar extends MovieClip implements IWarGodUIElement
   {
      
      private static const GAP:int = 5;
      
      private static const RANK_RANGE:int = 100;
      
      private static const MIN_X:int = 0;
      
      private static const MAX_X:int = 1180;
      
      private static const MY_POSITION_BAR_WIDTH:int = 95;
      
      public var myPastProgress:MovieClip;
      
      public var myPosition:MovieClip;
      
      public var myFutureProgress:MovieClip;
      
      public var myBottomRank:TextField;
      
      public var myTopRank:TextField;
      
      public var myRank:TextField;
      
      private var mSelfRankValid:Boolean = false;
      
      public function HeroicTierProgressBar()
      {
         super();
         this.myPastProgress.gotoAndStop(2);
         this.myPosition.gotoAndStop(4);
         this.myFutureProgress.gotoAndStop(1);
         this.myBottomRank.textStyle = WarGodGuide.styleWarGodProgressTextIndicator;
         this.myBottomRank.alignment = TextStyle.HALIGN_LEFT;
         this.myRank.textStyle = WarGodGuide.styleWarGodProgressTextIndicator;
         this.myRank.alignment = TextStyle.HALIGN_LEFT;
         this.myTopRank.textStyle = WarGodGuide.styleWarGodProgressTextIndicator;
         this.myTopRank.alignment = TextStyle.HALIGN_RIGHT;
         visible = false;
      }
      
      public function setData(seasonObj:WarGodSeasonObj, playerObj:WarGodPlayerObj, globalSetting:WarGodGlobalSettingObj) : void
      {
      }
      
      public function setSelfLBState(selfStats:Object) : void
      {
         var lbRankCeil:int = 0;
         var lbRankFloor:int = 0;
         var lbRank:int = int(selfStats.rank);
         if(lbRank == 0)
         {
            return;
         }
         if(lbRank % RANK_RANGE == 0)
         {
            lbRankFloor = lbRank;
            lbRankCeil = lbRank - RANK_RANGE + 1;
         }
         else
         {
            lbRankCeil = lbRank - lbRank % RANK_RANGE + 1;
            lbRankFloor = lbRankCeil + RANK_RANGE - 1;
         }
         this.myTopRank.text = LocalizeUtil.param(DictWarGod.WARGOD_RANK_LABEL,[lbRankCeil]);
         this.myBottomRank.text = LocalizeUtil.param(DictWarGod.WARGOD_RANK_LABEL,[lbRankFloor]);
         this.myRank.text = LocalizeUtil.param(DictWarGod.WARGOD_RANK_LABEL,[lbRank]);
         this.myRank.x = MIN_X + (MAX_X - MIN_X - this.myRank.textWidth) / 2;
         var progress:Number = lbRank / RANK_RANGE;
         if(lbRank == lbRankCeil)
         {
            progress = 0;
         }
         var minRangeX:Number = MIN_X + MY_POSITION_BAR_WIDTH;
         var maxRangeX:Number = MAX_X;
         this.myPosition.x = maxRangeX + progress * (minRangeX - maxRangeX) - MY_POSITION_BAR_WIDTH;
         this.myFutureProgress.x = this.myPosition.x + MY_POSITION_BAR_WIDTH + GAP;
         if(this.myFutureProgress.x < MAX_X)
         {
            this.myFutureProgress.width = MAX_X - this.myFutureProgress.x;
            this.myFutureProgress.visible = true;
         }
         else
         {
            this.myFutureProgress.visible = false;
         }
         var pastProgressWidth:Number = this.myPosition.x - GAP - MIN_X;
         if(pastProgressWidth > 0)
         {
            this.myPastProgress.visible = true;
            this.myPastProgress.width = pastProgressWidth;
         }
         else
         {
            this.myPastProgress.visible = false;
         }
         visible = true;
      }
   }
}

