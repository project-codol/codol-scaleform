package codo.views.hudDMZ
{
   import codo.localization.DictDmz;
   import codo.utils.LocalizeUtil;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   
   public class SpectatingNotification extends MovieClip
   {
      
      private static var LABEL_NAME_MARGIN:int = 5;
      
      private static var BACKGROUND_MARGIN:int = 4;
      
      public var myIcon:MovieClip;
      
      public var myLabel:TextField;
      
      public var myName:TextField;
      
      public var myBG:MovieClip;
      
      public function SpectatingNotification()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         this.myLabel.autoSize = TextFieldAutoSize.LEFT;
         this.myLabel.text = LocalizeUtil.localize(DictDmz.SPECTATING);
         this.myName.autoSize = TextFieldAutoSize.LEFT;
         this.myName.x = this.myLabel.x + this.myLabel.width + LABEL_NAME_MARGIN;
      }
      
      public function setPlayerName(name:String) : void
      {
         this.myName.text = name;
         this.myBG.width = this.myName.x + this.myName.width + BACKGROUND_MARGIN;
      }
   }
}

