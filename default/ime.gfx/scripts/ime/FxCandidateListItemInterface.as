package ime
{
   import flash.display.*;
   
   public class FxCandidateListItemInterface
   {
      
      public var ItemObj:Object;
      
      public var ItemDataMap:Array;
      
      public var ItemData:Array;
      
      public function FxCandidateListItemInterface(mc:MovieClip)
      {
         super();
         this.ItemObj = mc;
      }
      
      public function GetData(key:String) : *
      {
         for(var i:* = 0; i < this.ItemDataMap.length; i++)
         {
            if(this.ItemDataMap[i] == key)
            {
               return this.ItemData[i];
            }
         }
      }
      
      public function DisplayInfo() : *
      {
         var obj:* = undefined;
         for(var j:* = 0; j < this.ItemDataMap.length; j++)
         {
            obj = this.ItemObj[this.ItemDataMap[j]];
            if(obj != null && obj != undefined && this.ItemData != null)
            {
               obj.replaceText(0,obj.length,this.ItemData[j]);
            }
         }
      }
   }
}

