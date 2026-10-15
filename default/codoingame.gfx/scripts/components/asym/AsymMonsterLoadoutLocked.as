package components.asym
{
   import codo.utils.LocalizeUtil;
   import flash.display.Sprite;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import scaleform.gfx.TextFieldEx;
   
   public class AsymMonsterLoadoutLocked extends Sprite
   {
      
      public var mySep1:Sprite;
      
      public var mySep2:Sprite;
      
      public var myLockBkg:Sprite;
      
      public var myLockedTF:TextField;
      
      public function AsymMonsterLoadoutLocked()
      {
         super();
         this.myLockedTF.autoSize = TextFieldAutoSize.CENTER;
         TextFieldEx.setVerticalAlign(this.myLockedTF,TextFieldEx.VALIGN_CENTER);
      }
      
      public function set lockedText(txt:String) : void
      {
         var assetWidth:uint = 0;
         var PADDING:uint = 40;
         this.myLockedTF.text = LocalizeUtil.localize(txt).toUpperCase();
         assetWidth = this.myLockedTF.textWidth + PADDING;
         this.mySep2.width = this.mySep1.width = this.myLockBkg.width = assetWidth;
         this.myLockedTF.x = (assetWidth - this.myLockedTF.textWidth) / 2;
      }
   }
}

