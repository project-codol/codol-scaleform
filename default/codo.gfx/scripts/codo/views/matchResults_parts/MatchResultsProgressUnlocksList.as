package codo.views.matchResults_parts
{
   import codo.localization.DictMatchResults;
   import codo.objects.DailyChallengeRewardObj;
   import codo.objects.ProductObj;
   import codo.utils.DataUtil;
   import codo.utils.ScaleformUtil;
   import flash.display.Sprite;
   import flash.text.TextField;
   
   public class MatchResultsProgressUnlocksList extends Sprite
   {
      
      private static const LIST_HEIGHT:int = 250;
      
      public var myScrollList:MatchResultsUnlocksScrollList;
      
      public var myUnlocksHeaderTF:TextField;
      
      public var myBkg:Sprite;
      
      public function MatchResultsProgressUnlocksList()
      {
         super();
         this.myScrollList.maxVisibleItems = 4;
         this.header = ScaleformUtil.isScaleform ? DictMatchResults.MARKET_AND_LEVEL_UNLOCKS : "MARKET UNLOCKS AND REWARDS";
      }
      
      public function set header(txt:String) : void
      {
         this.myUnlocksHeaderTF.text = txt;
      }
      
      public function setData(data:Vector.<Object>) : void
      {
         data.sort(this.sortOnOwned);
         this.myScrollList.addItemsByVector(DataUtil.copyElems(new Vector.<Object>(0),data));
         this.myBkg.width = this.myScrollList.width + 20;
         this.myBkg.height = Math.min(LIST_HEIGHT,this.myScrollList.height + 40);
      }
      
      private function sortOnOwned(a:Object, b:Object) : int
      {
         var prodA:ProductObj = null;
         var prodB:ProductObj = null;
         var aOwned:int = 0;
         var bOwned:int = 0;
         if(a is ProductObj && b is ProductObj)
         {
            prodA = a as ProductObj;
            prodB = b as ProductObj;
            aOwned = prodA.isOwned() ? 1 : 0;
            bOwned = prodB.isOwned() ? 1 : 0;
            return bOwned - aOwned;
         }
         if(a is ProductObj)
         {
            return 1;
         }
         if(b is ProductObj)
         {
            return -1;
         }
         if(a is DailyChallengeRewardObj && b is DailyChallengeRewardObj)
         {
            return (a as DailyChallengeRewardObj).score - (b as DailyChallengeRewardObj).score;
         }
         if(a is DailyChallengeRewardObj)
         {
            return 1;
         }
         if(b is DailyChallengeRewardObj)
         {
            return -1;
         }
         return 0;
      }
      
      override public function get height() : Number
      {
         return this.myBkg.height;
      }
   }
}

