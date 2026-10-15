package components.fsgonboardpopups_part
{
   import flash.display.Sprite;
   import flash.text.TextField;
   
   public class FsgUnlockItemCompleteBanner extends Sprite
   {
      
      public var myBannerTF:TextField;
      
      public function FsgUnlockItemCompleteBanner()
      {
         super();
      }
      
      public function set bannerText(txt:String) : void
      {
         this.myBannerTF.text = txt;
      }
   }
}

