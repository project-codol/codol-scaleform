package codo.objects
{
   import codo.common.CFunctionCommonContainer;
   import codo.constants.MarketMenuData;
   
   public class ItemBuffListObj
   {
      
      private static var _wpnBuffsTable:Object;
      
      private static var _charBuffsTable:Object;
      
      public var id:String;
      
      public var buffs:Array = [];
      
      public function ItemBuffListObj()
      {
         super();
      }
      
      public static function getBuffs(item:ProductObj) : Vector.<ItemBuffObj>
      {
         var buffs:Vector.<ItemBuffObj> = new Vector.<ItemBuffObj>();
         if(item.itemBuffs != null)
         {
            addWpnBuffs(item,buffs);
         }
         else if(item.type == MarketMenuData.TYPE_CHARACTER || item.group == MarketMenuData.GRP_KNIFE)
         {
            addCharBuffs(item,buffs);
         }
         return buffs;
      }
      
      private static function addWpnBuffs(item:ProductObj, buffs:Vector.<ItemBuffObj>) : void
      {
         var id:String = null;
         var buffList:ItemBuffListObj = null;
         var j:int = 0;
         if(_wpnBuffsTable == null)
         {
            _wpnBuffsTable = CFunctionCommonContainer.BuildWeaponBuffsTable();
            initBuffsTable(_wpnBuffsTable);
         }
         for(var i:int = 0; i < item.itemBuffs.length; i++)
         {
            id = item.itemBuffs[i];
            buffList = _wpnBuffsTable[id] as ItemBuffListObj;
            if(buffList == null)
            {
               buffList = makeFakeBuffList();
            }
            for(j = 0; j < buffList.buffs.length; j++)
            {
               buffs.push(buffList.buffs[j] as ItemBuffObj);
            }
         }
      }
      
      private static function initBuffsTable(table:Object) : void
      {
         var id:String = null;
         var list:ItemBuffListObj = null;
         var buff:ItemBuffObj = null;
         for(id in table)
         {
            list = table[id];
            for each(buff in list.buffs)
            {
               buff.name = "@" + buff.name;
               buff.desc = "@" + buff.desc;
            }
         }
      }
      
      private static function addCharBuffs(item:ProductObj, buffs:Vector.<ItemBuffObj>) : void
      {
         if(_charBuffsTable == null)
         {
            _charBuffsTable = CFunctionCommonContainer.BuildCharBuffsTable();
            initBuffsTable(_charBuffsTable);
         }
         var buffList:ItemBuffListObj = _charBuffsTable[item.nameid] as ItemBuffListObj;
         if(buffList == null)
         {
            return;
         }
         for(var j:int = 0; j < buffList.buffs.length; j++)
         {
            buffs.push(buffList.buffs[j] as ItemBuffObj);
         }
      }
      
      private static function makeFakeBuffList() : ItemBuffListObj
      {
         var buff:ItemBuffObj = new ItemBuffObj();
         buff.name = "err";
         buff.desc = "err";
         buff.icon = "item_repair_kit_icon.tga";
         buff.percent = "err";
         var buffList:ItemBuffListObj = new ItemBuffListObj();
         buffList.id = "err";
         buffList.buffs = [buff];
         return buffList;
      }
   }
}

