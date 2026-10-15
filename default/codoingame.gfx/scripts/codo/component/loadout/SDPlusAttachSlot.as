package codo.component.loadout
{
   import codo.component.core.UIInteractiveComponent;
   import codo.objects.ProductObj;
   import fsg.util.FsgImageHolder;
   
   public class SDPlusAttachSlot extends UIInteractiveComponent
   {
      
      public var myImage:FsgImageHolder;
      
      public function SDPlusAttachSlot()
      {
         super();
         isInteractiveEnabled = false;
         this.myImage.clearImage();
      }
      
      override public function setData(data:*) : void
      {
         super.setData(data);
         var prodData:ProductObj = new ProductObj(data);
         this.myImage.setImage(prodData.imageURL);
         if(prodData.id > 0)
         {
            gotoAndStop(2);
         }
         else
         {
            gotoAndStop(1);
         }
      }
   }
}

