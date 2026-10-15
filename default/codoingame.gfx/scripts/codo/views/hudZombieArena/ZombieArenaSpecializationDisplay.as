package codo.views.hudZombieArena
{
   import codo.component.TextField;
   import codo.objects.ZombieArenaSpecializationObj;
   import codo.style.GlobalGuide;
   import codo.style.TextStyle;
   import codo.utils.LocalizeUtil;
   import flash.display.MovieClip;
   import flash.text.TextFieldAutoSize;
   import fsg.util.FsgImageHolder;
   
   public class ZombieArenaSpecializationDisplay extends MovieClip
   {
      
      private static const LABEL_WIDTH:Number = 300;
      
      public var myIcon:FsgImageHolder;
      
      public var myLabel:TextField;
      
      public var myDescription:TextField;
      
      public function ZombieArenaSpecializationDisplay()
      {
         super();
         this.myLabel.fontSize = GlobalGuide.FONT_SIZE_EXTRA_SMALL;
         this.myLabel.alignment = TextStyle.HALIGN_CENTER;
         this.myLabel.autoSize = TextFieldAutoSize.CENTER;
         this.myLabel.width = LABEL_WIDTH;
         this.myIcon.visible = false;
         if(null != this.myDescription)
         {
            this.myDescription.fontColor = GlobalGuide.GRAY_80;
            this.myDescription.fontSize = GlobalGuide.FONT_SIZE_EXTRA_SMALL;
            this.myDescription.alignment = TextStyle.HALIGN_CENTER;
            this.myDescription.autoSize = TextFieldAutoSize.CENTER;
            this.myDescription.width = LABEL_WIDTH;
         }
      }
      
      public function setData(data:ZombieArenaSpecializationObj) : void
      {
         this.myLabel.text = LocalizeUtil.localize(data.label).toUpperCase();
         if(null != data.description && null != this.myDescription)
         {
            this.myDescription.text = data.description;
         }
         else if(null != this.myDescription)
         {
            this.myDescription.text = "";
         }
         if(null != data.imageURL)
         {
            this.myIcon.visible = true;
            this.myIcon.setImage(data.imageURL);
         }
         else
         {
            this.myIcon.setImage("");
            this.myIcon.visible = false;
         }
      }
   }
}

