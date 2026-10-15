package fsg.shared
{
   import fsg.util.FsgImageHolder;
   
   public class ComboBoxImageItem extends ComboBoxItem
   {
      
      public var myImageHolder:FsgImageHolder;
      
      private var mImageURL:String = "";
      
      public function ComboBoxImageItem()
      {
         super();
      }
      
      public function set image(imgURL:String) : void
      {
         this.mImageURL = imgURL;
         this.myImageHolder.setImage(imgURL);
      }
      
      override public function get height() : Number
      {
         return 55;
      }
      
      public function get imageURL() : String
      {
         return this.mImageURL;
      }
   }
}

