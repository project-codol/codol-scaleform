package codo.views.matchResults_parts
{
   import codo.component.ScrollList;
   import codo.component.core.UIInteractiveComponent;
   import flash.utils.getDefinitionByName;
   
   public class MatchResultsUnlocksScrollList extends ScrollList
   {
      
      public function MatchResultsUnlocksScrollList()
      {
         super();
         myNavArrowLeft.scaleY = 1.4;
         myNavArrowRight.scaleY = 1.4;
      }
      
      override protected function makeRenderer(itemLinkage:String) : UIInteractiveComponent
      {
         var cls:Class = getDefinitionByName("fsg.matchresults.fsgMatchResultProgressReward") as Class;
         var item:UIInteractiveComponent = new cls();
         myItemHolder.addChild(item);
         mItems.push(item);
         return item;
      }
   }
}

