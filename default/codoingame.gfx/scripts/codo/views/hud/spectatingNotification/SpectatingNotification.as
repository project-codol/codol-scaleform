package codo.views.hud.spectatingNotification
{
   import codo.constants.HUDComponentTypes;
   import codo.localization.DictHud;
   import codo.utils.LocalizeUtil;
   import codo.views.hud.HUDComponent;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   
   public class SpectatingNotification extends HUDComponent
   {
      
      private static var LABEL_NAME_MARGIN:int = 5;
      
      private static var BACKGROUND_MARGIN:int = 8;
      
      public var myIcon:MovieClip;
      
      public var myLabel:TextField;
      
      public var myName:TextField;
      
      public var myBG:MovieClip;
      
      public function SpectatingNotification()
      {
         super();
      }
      
      override protected function init() : void
      {
         this.myLabel.autoSize = TextFieldAutoSize.LEFT;
         this.myLabel.text = LocalizeUtil.localize(DictHud.SPECTATING);
         this.myName.autoSize = TextFieldAutoSize.LEFT;
         this.myName.x = this.myLabel.x + this.myLabel.width + LABEL_NAME_MARGIN;
      }
      
      override public function get CompType() : int
      {
         return HUDComponentTypes.SPECTATING_NOTIFICATION;
      }
      
      public function cppSetPlayerName(name:String) : void
      {
         this.myName.text = name;
         var totalWidth:Number = this.myLabel.textWidth + this.myName.textWidth + LABEL_NAME_MARGIN * 2 + BACKGROUND_MARGIN * 2 + this.myIcon.width;
         this.myBG.width = totalWidth;
         this.myBG.x = -totalWidth / 2;
         this.myIcon.x = this.myBG.x + BACKGROUND_MARGIN;
         this.myLabel.x = this.myIcon.x + this.myIcon.width + LABEL_NAME_MARGIN;
         this.myName.x = this.myLabel.x + this.myLabel.textWidth + LABEL_NAME_MARGIN;
      }
   }
}

