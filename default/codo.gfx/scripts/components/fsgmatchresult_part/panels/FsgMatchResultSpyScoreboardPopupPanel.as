package components.fsgmatchresult_part.panels
{
   import codo.common.CFunctionContainer;
   import codo.objects.SpyMatchResultObj;
   import codo.objects.SpyScoreboardItemObj;
   import codo.views.spyMatchResult_parts.SpyMatchResultScoreboardHeader;
   import codo.views.spyMatchResult_parts.SpyMatchResultScoreboardItem;
   import components.fsgmatchresult_part.FsgMatchResultPopupPanelBase;
   import flash.display.MovieClip;
   import flash.utils.getDefinitionByName;
   
   public class FsgMatchResultSpyScoreboardPopupPanel extends FsgMatchResultPopupPanelBase
   {
      
      public static const MAX_SCOREBOARD_ITEM:int = 18;
      
      public static const ITEM_HEIGHT:int = 37;
      
      public var myHeader:SpyMatchResultScoreboardHeader;
      
      public var myScoreItemHolder:MovieClip;
      
      public var myBg:MovieClip;
      
      private var mItems:Vector.<SpyMatchResultScoreboardItem>;
      
      public function FsgMatchResultSpyScoreboardPopupPanel()
      {
         super();
      }
      
      private function resetScoreboard() : void
      {
         this.mItems = new Vector.<SpyMatchResultScoreboardItem>(0);
         while(this.myScoreItemHolder.numChildren > 0)
         {
            this.myScoreItemHolder.removeChildAt(0);
         }
      }
      
      override public function active() : void
      {
         var i:int = 0;
         var scoreObj:SpyScoreboardItemObj = null;
         var itemClass:Class = null;
         var item:SpyMatchResultScoreboardItem = null;
         super.active();
         this.resetScoreboard();
         var spyMatchResult:SpyMatchResultObj = CFunctionContainer.AS_GetSpyModeMatchResult();
         if(spyMatchResult.mScores != null)
         {
            for(i = 0; i < spyMatchResult.mScores.length; i++)
            {
               scoreObj = spyMatchResult.mScores[i];
               itemClass = getDefinitionByName("codo.matchresult.spy.spyMatchResultScoreboardItem") as Class;
               item = new itemClass();
               this.myScoreItemHolder.addChild(item);
               item.x = 0;
               item.y = i * ITEM_HEIGHT;
               item.setData(scoreObj);
            }
            this.myBg.height = (1 + spyMatchResult.mScores.length) * ITEM_HEIGHT;
         }
         else
         {
            this.myBg.height = ITEM_HEIGHT;
         }
      }
      
      override public function deactive() : void
      {
         super.deactive();
      }
   }
}

