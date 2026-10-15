package codo.component.marketplaceitem.parts
{
   import flash.display.Sprite;
   import flash.text.TextField;
   import fsg.util.FsgImageHolder;
   import scaleform.gfx.TextFieldEx;
   
   public class IconLock extends Sprite
   {
      
      public var myLockLevelTF:TextField;
      
      public var myPrestigeIcon:FsgImageHolder;
      
      public var myIcon:Sprite;
      
      public function IconLock()
      {
         super();
         this.myLockLevelTF.visible = this.myPrestigeIcon.visible = false;
         TextFieldEx.setVerticalAlign(this.myLockLevelTF,TextFieldEx.VALIGN_CENTER);
      }
      
      public function setLockLevel(level:String, prestigeImgPath:String = "") : void
      {
         this.myLockLevelTF.text = level;
         this.myPrestigeIcon.visible = prestigeImgPath != "";
         this.myLockLevelTF.visible = true;
         if(this.myPrestigeIcon.visible)
         {
            this.myPrestigeIcon.setImage(prestigeImgPath);
         }
      }
      
      override public function get width() : Number
      {
         return scaleX * (this.myPrestigeIcon.visible ? this.myLockLevelTF.width + this.myPrestigeIcon.width : this.myLockLevelTF.width);
      }
   }
}

