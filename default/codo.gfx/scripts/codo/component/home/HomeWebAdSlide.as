package codo.component.home
{
   import codo.component.core.UIInteractiveComponent;
   import codo.objects.WebAdObj;
   import flash.display.Sprite;
   import fsg.util.FsgImageHolder;
   
   public class HomeWebAdSlide extends UIInteractiveComponent
   {
      
      public var myImage:FsgImageHolder;
      
      public var myBackground:Sprite;
      
      public function HomeWebAdSlide()
      {
         super();
         isInteractiveEnabled = true;
      }
      
      override public function setData(data:*) : void
      {
         super.setData(data);
         var webAd:WebAdObj = data as WebAdObj;
         this.myImage.setImage(webAd.imageURL);
         resetCallback();
         if(webAd.callback is Function)
         {
            registerClickEvent(webAd.callback);
         }
      }
      
      override public function get width() : Number
      {
         return this.myImage.width;
      }
      
      override public function get height() : Number
      {
         return this.myImage.height;
      }
   }
}

