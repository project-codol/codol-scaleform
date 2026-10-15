package components.fsgpopups_part
{
   import codo.constants.BCInGameEvent;
   import codo.constants.ComponentCSS;
   import codo.localization.DictInGame;
   import codo.localization.DictSystem;
   import fl.motion.Color;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import fsg.shared.popups.PopupContentBase;
   
   public class FsgQuitGameWarningPopupViewContent extends PopupContentBase
   {
      
      public static const STYLE_RED_WARNING:uint = 0;
      
      public static const STYLE_BLUE_TIP:uint = 1;
      
      public var myWarningIcon:Sprite;
      
      public var myDescriptionTF:TextField;
      
      public function FsgQuitGameWarningPopupViewContent()
      {
         super();
         this.myDescriptionTF.autoSize = TextFieldAutoSize.LEFT;
         this.myDescriptionTF.multiline = this.myDescriptionTF.wordWrap = true;
      }
      
      public function set cancelCallback(callback:Function) : void
      {
         myPopupBase.configCancelButton(DictSystem.CANCEL,callback);
      }
      
      public function set warningDescription(txt:String) : void
      {
         this.myDescriptionTF.text = LOCALIZE(txt).toUpperCase();
      }
      
      public function set warningStyle(style:uint) : void
      {
         var color:uint = 0;
         var textMargin:uint = 0;
         switch(style)
         {
            case STYLE_RED_WARNING:
               color = ComponentCSS.WARNING_COLOR_RED;
               myPopupBase.subheaderText = DictSystem.WARNING;
               textMargin = 80;
               this.myWarningIcon.visible = true;
               break;
            case STYLE_BLUE_TIP:
               color = ComponentCSS.FSG_COLOR_BLUE;
               myPopupBase.subheaderText = DictSystem.TIP;
               textMargin = 32;
               this.myWarningIcon.visible = false;
         }
         var subheaderTF:TextField = myPopupBase.mySubHeader.mySubHeaderText;
         var tf:TextFormat = subheaderTF.getTextFormat();
         tf.leftMargin = textMargin;
         subheaderTF.setTextFormat(tf);
         var warningColor:Color = new Color();
         var highlight:MovieClip = myPopupBase.myFrameAnimated.myAnimatedHighlight;
         warningColor.setTint(color,100);
         highlight.transform.colorTransform = warningColor;
      }
      
      override protected function configPopUpBase() : void
      {
         super.configPopUpBase();
         this.warningStyle = STYLE_RED_WARNING;
         var contentPos:Point = myPopupBase.contentPosition;
         this.myWarningIcon.y = contentPos.y;
         this.myWarningIcon.x = this.myDescriptionTF.x = contentPos.x;
         this.myDescriptionTF.y = this.myWarningIcon.y + this.myWarningIcon.height + CONTENT_PADDING;
         this.myDescriptionTF.text = LOCALIZE(DictInGame.QUIT_GAME_WARNING_DESCRIPTION).toUpperCase();
         this.myDescriptionTF.width = myPopupBase.contentInnerWidth;
         myPopupBase.configConfirmButton(DictSystem.CONFIRM,this.onConfirm);
         myPopupBase.setSize(-1,this.myDescriptionTF.y + this.myDescriptionTF.textHeight + 35);
         myPopupBase.animateFrame = true;
      }
      
      private function onConfirm() : void
      {
         broadcast(BCInGameEvent.BACK_TO_MAIN_MENU);
      }
      
      override protected function get viewWidth() : uint
      {
         return 450;
      }
      
      override protected function get viewHeight() : uint
      {
         return 220;
      }
   }
}

