package codo.views.hudZombieArena
{
   import codo.component.TextField;
   import codo.style.GlobalGuide;
   import codo.style.TextStyle;
   import codo.style.ZombieHudGuide;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import fsg.util.FsgImageHolder;
   
   public class ZombieArenaSelectedSpecializations extends MovieClip
   {
      
      public var myRoleIcon:FsgImageHolder;
      
      public var myEmpoweredIcon:FsgImageHolder;
      
      public var mySpecializationMount:MovieClip;
      
      public var myBackground:Sprite;
      
      public var myLabel:TextField;
      
      public function ZombieArenaSelectedSpecializations()
      {
         super();
         this.myLabel.alignment = TextStyle.HALIGN_CENTER;
         this.myLabel.font = GlobalGuide.FONT_FACE_BOLD;
         this.myLabel.fontSize = GlobalGuide.FONT_SIZE_TINY;
         this.myLabel.width = 110;
         this.myRoleIcon.visible = false;
         this.myBackground.visible = false;
      }
      
      public function setRoleIcon(imageURL:String) : void
      {
         this.myRoleIcon.setImage(imageURL);
      }
      
      public function setCurrentRole(data:Object) : void
      {
         this.myRoleIcon.setImage(data.image);
         this.myLabel.text = data.label;
         this.myLabel.fontColor = ZombieHudGuide.getSpecializationColor(data.type);
      }
      
      public function setAllIcons(icons:Array) : void
      {
         var clip:ZombieArenaSpecializationIcon = null;
         var length:Number = icons.length;
         for(var i:Number = 0; i < length; i++)
         {
            clip = this.mySpecializationMount.getChildAt(i) as ZombieArenaSpecializationIcon;
            clip.setImages(icons[i]);
         }
      }
   }
}

