package codo.views.hudZombieArena
{
   import codo.style.GlobalGuide;
   import flash.display.MovieClip;
   import fsg.shared.InputIconUtility;
   import fsg.util.FsgImageHolder;
   
   public class ZombieArenaSpecializationIcon extends MovieClip
   {
      
      public var myImage:FsgImageHolder;
      
      public var myFillImage:FsgImageHolder;
      
      public var myFillMask:MovieClip;
      
      public var myKeyBind:InputIconUtility;
      
      public var myKeyBindBG:MovieClip;
      
      public function ZombieArenaSpecializationIcon()
      {
         super();
      }
      
      public function setImages(data:Object) : void
      {
         if(null != data.image)
         {
            this.myImage.visible = true;
            this.myImage.setImage(data.image);
         }
         else
         {
            this.myImage.setImage("");
            this.myImage.visible = false;
         }
         if(null != data.fillImage)
         {
            this.myFillImage.visible = true;
            this.myFillImage.setImage(data.fillImage);
         }
         else
         {
            this.myFillImage.setImage("");
            this.myFillImage.visible = false;
         }
         if(Boolean(data.keybind) && data.keybind != "")
         {
            this.myKeyBind.visible = this.myKeyBindBG.visible = true;
            this.myKeyBind.setForCommand(data.keybind,GlobalGuide.CODO_COLOR_HIGHLIGHT_ORANGE,false);
         }
         else
         {
            this.myKeyBind.visible = this.myKeyBindBG.visible = false;
         }
      }
   }
}

