package codo.views.hudSpy
{
   import flash.display.MovieClip;
   import fsg.util.FsgImageHolder;
   
   public class WeaponBar extends MovieClip
   {
      
      public var myImage:FsgImageHolder;
      
      public function WeaponBar()
      {
         super();
      }
      
      public function set image(image:String) : void
      {
         this.myImage.setImage(image);
      }
   }
}

