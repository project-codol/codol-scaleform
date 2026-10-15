package components.clash
{
   import codo.utils.LocalizeUtil;
   import flash.display.Sprite;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import scaleform.gfx.TextFieldEx;
   
   public class ClashWeaponLoadoutLocked extends Sprite
   {
      
      public var mySep1:Sprite;
      
      public var mySep2:Sprite;
      
      public var myLockBkg:Sprite;
      
      public var myLockedTF:TextField;
      
      public function ClashWeaponLoadoutLocked()
      {
         super();
         this.myLockedTF.autoSize = TextFieldAutoSize.CENTER;
         TextFieldEx.setVerticalAlign(this.myLockedTF,TextFieldEx.VALIGN_CENTER);
      }
      
      public function set lockedText(txt:String) : void
      {
         this.myLockedTF.text = LocalizeUtil.localize(txt).toUpperCase();
         this.myLockedTF.x = (this.mySep1.width - this.myLockedTF.textWidth) / 2;
      }
   }
}

