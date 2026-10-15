package codo.objects
{
   public class WebAdObj
   {
      
      public var imageURL:String;
      
      public var callback:Function;
      
      public function WebAdObj(image:String, cb:Function)
      {
         super();
         this.imageURL = image;
         this.callback = cb;
      }
   }
}

