package codo.views.wargod_parts
{
   import codo.constants.WebImgData;
   import codo.objects.WarGodPlayerObj;
   import codo.objects.WebAdObj;
   import codo.utils.WarGodUtility;
   import flash.display.MovieClip;
   import fsg.util.FsgImageHolder;
   
   public class WarGodNameCard extends MovieClip
   {
      
      public var myBg:FsgImageHolder;
      
      public function WarGodNameCard()
      {
         super();
      }
      
      public function setData(playerObj:WarGodPlayerObj) : void
      {
         var isJuniorWarGodImage:Boolean = WarGodUtility.isJuniorWarGod(playerObj);
         this.myBg.setImage(this.getSeasonWebImage(isJuniorWarGodImage).imageURL);
      }
      
      private function getSeasonWebImage(isJuniorWarGodImage:Boolean) : WebAdObj
      {
         var imageURL:String = WebImgData.getWebImgURL(isJuniorWarGodImage ? uint(WebImgData.WARGODLADDER1.id) : uint(WebImgData.WARGODLADDER2.id),0);
         return new WebAdObj(imageURL,null);
      }
   }
}

