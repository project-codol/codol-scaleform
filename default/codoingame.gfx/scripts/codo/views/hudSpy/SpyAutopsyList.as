package codo.views.hudSpy
{
   import flash.display.MovieClip;
   import flash.utils.getDefinitionByName;
   
   public class SpyAutopsyList extends MovieClip
   {
      
      private static const ITEM_LINKAGE:String = "codo.shared.hud.spy.spyAutopsyListItem";
      
      private static const ITEM_HEIGHT:int = 37;
      
      public var myBg:MovieClip;
      
      public var myMount:MovieClip;
      
      public var myHeader:SpyAutopsyListHeader;
      
      private var mItems:Vector.<SpyAutopsyListItem>;
      
      public function SpyAutopsyList()
      {
         super();
         this.mItems = new Vector.<SpyAutopsyListItem>(0);
      }
      
      public function cppSetData(data:Array) : void
      {
         var i:int = 0;
         var totalHeight:int = 0;
         var cls:Class = null;
         var item:SpyAutopsyListItem = null;
         var itemObj:Object = null;
         while(this.mItems.length < data.length)
         {
            cls = getDefinitionByName(ITEM_LINKAGE) as Class;
            item = new cls() as SpyAutopsyListItem;
            this.myMount.addChild(item);
            this.mItems.push(item);
         }
         totalHeight = ITEM_HEIGHT;
         for(i = 0; i < this.mItems.length; i++)
         {
            this.mItems[i].visible = false;
         }
         for(i = 0; i < data.length; i++)
         {
            itemObj = data[i];
            this.mItems[i].setData(itemObj);
            this.mItems[i].y = i * ITEM_HEIGHT;
            this.mItems[i].visible = true;
            totalHeight += ITEM_HEIGHT;
         }
         this.myBg.height = totalHeight;
      }
   }
}

