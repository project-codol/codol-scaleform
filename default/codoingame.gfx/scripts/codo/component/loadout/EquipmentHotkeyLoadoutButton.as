package codo.component.loadout
{
   import codo.objects.ProductObj;
   import fsg.util.FsgImageHolder;
   
   public class EquipmentHotkeyLoadoutButton extends HotkeyLoadoutButton
   {
      
      public var myImageDouble:FsgImageHolder;
      
      private var _homeX:Number;
      
      public function EquipmentHotkeyLoadoutButton()
      {
         super();
      }
      
      public function setDoubleAmmo(data:*) : void
      {
         var prodData:ProductObj = new ProductObj(data);
         if(prodData.id > 0)
         {
            this.myImageDouble.setImage(prodData.imageURL);
            myImage.x = this._homeX - 20;
            this.myImageDouble.x = this._homeX + 20;
         }
         else
         {
            this.myImageDouble.clearImage();
            myImage.x = this._homeX;
         }
      }
      
      override public function draw() : void
      {
         super.draw();
         this.myImageDouble.width = myImage.width;
         this.myImageDouble.height = myImage.height;
         this.myImageDouble.x = myImage.x;
         this.myImageDouble.y = myImage.y;
         this._homeX = myImage.x;
      }
   }
}

