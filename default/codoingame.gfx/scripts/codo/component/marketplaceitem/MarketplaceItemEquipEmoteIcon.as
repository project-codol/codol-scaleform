package codo.component.marketplaceitem
{
   import codo.objects.ProductObj;
   import flash.display.MovieClip;
   
   public class MarketplaceItemEquipEmoteIcon extends MovieClip
   {
      
      public var myKey1:MarketplaceItemEquipEmoteBtn;
      
      public var myKey2:MarketplaceItemEquipEmoteBtn;
      
      public var myKey3:MarketplaceItemEquipEmoteBtn;
      
      public var myKey4:MarketplaceItemEquipEmoteBtn;
      
      private var mItem:ProductObj;
      
      private var mKeys:Vector.<MarketplaceItemEquipEmoteBtn>;
      
      public function MarketplaceItemEquipEmoteIcon()
      {
         super();
         this.mKeys = new <MarketplaceItemEquipEmoteBtn>[this.myKey1,this.myKey2,this.myKey3,this.myKey4];
         for(var i:int = 0; i < this.mKeys.length; i++)
         {
            this.mKeys[i].index = i;
         }
      }
      
      public function setData(data:ProductObj) : void
      {
         this.mItem = data;
         for(var i:int = 0; i < this.mKeys.length; i++)
         {
            this.mKeys[i].setData(data);
         }
      }
      
      public function mouseMove() : void
      {
         for(var i:int = 0; i < this.mKeys.length; i++)
         {
            if(this.mKeys[i].hitTestPoint(stage.mouseX,stage.mouseY))
            {
               this.mKeys[i].onMouseOver();
            }
            else
            {
               this.mKeys[i].onMouseOut();
            }
         }
      }
      
      public function getCurrentSelectedIndex() : int
      {
         for(var i:int = 0; i < this.mKeys.length; i++)
         {
            if(this.mKeys[i].hitTestPoint(stage.mouseX,stage.mouseY))
            {
               return i;
            }
         }
         return -1;
      }
   }
}

