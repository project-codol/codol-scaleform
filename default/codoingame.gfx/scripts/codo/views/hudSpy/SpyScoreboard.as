package codo.views.hudSpy
{
   import codo.component.TextField;
   import codo.constants.SpyModeRoleStatus;
   import codo.localization.DictHud;
   import codo.localization.DictSpy;
   import codo.objects.SpyScoreboardItemObj;
   import codo.shared.hud.spyScoreboardItem;
   import codo.style.SpyHudGuide;
   import flash.display.MovieClip;
   import flash.utils.Dictionary;
   
   public class SpyScoreboard extends MovieClip
   {
      
      private static const ROUNDS_LEFT_MARGIN_RIGHT:int = 25;
      
      public static const SPY_STATUS:Array = [SpyModeRoleStatus.SPY_STATUS_ALIVE,SpyModeRoleStatus.SPY_STATUS_MISSING,SpyModeRoleStatus.SPY_STATUS_BODYFOUND];
      
      public var myHeader:SpyScoreboardHeader;
      
      public var myAliveStatusHeader:SpyScoreBoardCategoryHeader;
      
      public var myMissingStatusHeader:SpyScoreBoardCategoryHeader;
      
      public var myBodyFoundStatusHeader:SpyScoreBoardCategoryHeader;
      
      public var myBg:MovieClip;
      
      public var myFooter:MovieClip;
      
      private var mItems:Dictionary;
      
      private var mCategoryHeaders:Array;
      
      private var myRoundsLeft:TextField;
      
      private var myRoundsLeftLabel:TextField;
      
      public function SpyScoreboard()
      {
         super();
         this.myAliveStatusHeader.text = DictSpy.SCOREBOARD_CATEGORY_HEADER_ALIVE;
         this.myMissingStatusHeader.text = DictSpy.SCOREBOARD_CATEGORY_HEADER_MISSING;
         this.myBodyFoundStatusHeader.text = DictSpy.SCOREBOARD_CATEGORY_HEADER_BODYFOUND;
         this.mItems = new Dictionary();
         this.mCategoryHeaders = [this.myAliveStatusHeader,this.myMissingStatusHeader,this.myBodyFoundStatusHeader];
         this.myRoundsLeft = this.myFooter["myRoundsLeft"];
         this.myRoundsLeftLabel = this.myFooter["myRoundsLeftLabel"];
         this.myRoundsLeft.textStyle = SpyHudGuide.SpyScoreboardRoundLeft;
         this.myRoundsLeftLabel.textStyle = SpyHudGuide.SpyScoreboardRoundLeftLabel;
         this.myRoundsLeftLabel.text = DictHud.SPY_ROUNDS_LEFT;
         this.myRoundsLeftLabel.x = this.myFooter.width - this.myRoundsLeftLabel.textWidth - ROUNDS_LEFT_MARGIN_RIGHT;
         this.myRoundsLeft.x = this.myRoundsLeftLabel.x - 3 - this.myRoundsLeft.width;
      }
      
      public function cppRefreshScoreboard(scores:Vector.<SpyScoreboardItemObj>, roundsLeft:int) : void
      {
         var key:Object = null;
         var index:int = 0;
         var i:int = 0;
         var j:int = 0;
         var score:SpyScoreboardItemObj = null;
         var item:SpyScoreboardItem = null;
         for(key in this.mItems)
         {
            this.mItems[key].available = false;
         }
         index = 0;
         for(i = 0; i < SPY_STATUS.length; i++)
         {
            index++;
            this.mCategoryHeaders[i].y = 37 * index;
            this.mCategoryHeaders[i].gotoAndStop(i + 1);
            for(j = 0; j < scores.length; j++)
            {
               score = scores[j];
               if(score.group == SPY_STATUS[i])
               {
                  if(this.mItems[score.nickName] == null)
                  {
                     item = new spyScoreboardItem();
                     addChild(item);
                     this.mItems[score.nickName] = item;
                     item.setData(score);
                     index++;
                     item.y = 37 * index;
                     item.visible = true;
                     item.gotoAndStop(i + 1);
                  }
                  else
                  {
                     this.mItems[score.nickName].setData(score);
                     index++;
                     this.mItems[score.nickName].y = 37 * index;
                     this.mItems[score.nickName].visible = true;
                     this.mItems[score.nickName].gotoAndStop(i + 1);
                  }
               }
            }
         }
         index++;
         this.myFooter.y = 37 * index;
         this.myRoundsLeft.text = roundsLeft.toString();
         var totalHeight:int = (index + 1) * 37;
         this.myBg.height = totalHeight;
         this.myBg.x = -1;
         this.myBg.y = -1;
      }
   }
}

