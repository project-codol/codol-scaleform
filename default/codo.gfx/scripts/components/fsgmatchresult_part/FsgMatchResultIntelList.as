package components.fsgmatchresult_part
{
   import codo.objects.ObjectiveObject;
   import codo.objects.ResultObj;
   import codo.utils.LocalizeUtil;
   import components.cyborg.cyborgInGame_part.CyborgObjectiveItem;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class FsgMatchResultIntelList extends MovieClip
   {
      
      private static const NUM_INTEL_ITEMS:int = 4;
      
      public var myIntelItem0:CyborgObjectiveItem;
      
      public var myIntelItem1:CyborgObjectiveItem;
      
      public var myIntelItem2:CyborgObjectiveItem;
      
      public var myIntelItem3:CyborgObjectiveItem;
      
      public var myIntelTitle:TextField;
      
      public function FsgMatchResultIntelList()
      {
         super();
         this.ClearData();
      }
      
      public function SetTitle(title:String) : void
      {
         this.myIntelTitle.text = LocalizeUtil.localize(title).toUpperCase();
      }
      
      public function ClearData() : void
      {
         var intelItem:CyborgObjectiveItem = null;
         for(var i:int = 0; i < NUM_INTEL_ITEMS; i++)
         {
            intelItem = this["myIntelItem" + i];
            intelItem.SetData(null);
         }
      }
      
      public function bindObjectives(result:ResultObj) : void
      {
         var objectiveArray:Array = result.data;
         var intelItem:CyborgObjectiveItem = null;
         var objective:ObjectiveObject = null;
         for(var i:int = 0; i < NUM_INTEL_ITEMS; i++)
         {
            intelItem = this["myIntelItem" + i];
            if(objectiveArray.length > i && objectiveArray[i] != null)
            {
               objective = new ObjectiveObject(objectiveArray[i]);
               intelItem.SetData(objective);
            }
            else
            {
               intelItem.SetData(null);
            }
         }
      }
   }
}

