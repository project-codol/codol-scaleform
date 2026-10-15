package codo.objects
{
   import codo.common.CFunctionContainer;
   
   public class WeaponStatsObj
   {
      
      public var firetype:String;
      
      public var rps:Number;
      
      public var clipsize:int;
      
      public var modclipsize:int;
      
      public var stats:Array = [];
      
      public var basicStats:Vector.<WeaponBasicStatObj>;
      
      public function WeaponStatsObj(item:ProductObj = null, useUiViewerStats:Boolean = false, useClashProperties:Boolean = false, previewAttachmentID:int = 0)
      {
         super();
         if(item == null)
         {
            return;
         }
         var statData:WeaponStatsObj = null;
         if(useClashProperties && Boolean(item.clashProperties))
         {
            statData = item.clashProperties as WeaponStatsObj;
         }
         else if(item.isEquipped())
         {
            statData = CFunctionContainer.WL_GetModifiedWeaponStats(item.id) as WeaponStatsObj;
         }
         else if(useUiViewerStats)
         {
            statData = CFunctionContainer.WL_GetPreviewedWeaponStats(item.id,previewAttachmentID) as WeaponStatsObj;
         }
         else
         {
            statData = item.properties as WeaponStatsObj;
         }
         this.basicStats = new Vector.<WeaponBasicStatObj>();
         for(var i:int = 0; i < statData.stats.length; i++)
         {
            this.basicStats.push(statData.stats[i] as WeaponBasicStatObj);
         }
         this.firetype = statData.firetype;
         this.rps = statData.rps;
         this.clipsize = statData.clipsize;
         this.modclipsize = statData.modclipsize;
      }
   }
}

