package codo.style
{
   import flash.display.DisplayObject;
   import flash.geom.ColorTransform;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormatAlign;
   
   public class ChatGuide extends GlobalGuide
   {
      
      public static const PADDING:int = 10;
      
      public static const CHANNEL_BTN_WIDTH:int = 60;
      
      public static const CHANNEL_BTN_PADDING:int = 3;
      
      public static const GLOBAL_CHANNEL_NOTE_WIDTH:int = 710;
      
      public static const BIG_LOUD_SPEAKER_MESSAGE_WIDTH:int = 415;
      
      public static const BIG_LOUD_SPEAKER_MESSAGE_HEIGHT:int = 53;
      
      public static const OTHER_SEND_COLOR:int = GREEN;
      
      public static const LOUD_SPEAKER_COLOR:int = CODO_YELLOW;
      
      public static const SYS_SEND_COLOR:int = 13395507;
      
      public static const SMALL_SPEAKER_ICON_FRAME:int = 1;
      
      public static const BIG_SPEAKER_ICON_FRAME:int = 2;
      
      public static const HEROIC_TIER_ICON_FRAME:int = 3;
      
      public function ChatGuide()
      {
         super();
      }
      
      public static function get styleTitle() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.fontSize = 30;
         style.font = GlobalGuide.FONT_FACE_BOLD;
         style.fontColor = GlobalGuide.WHITE;
         return style;
      }
      
      public static function get styleSingleLine() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.multiLine = false;
         style.wordWrap = false;
         style.font = GlobalGuide.FONT_FACE_BOLD;
         style.autoSize = TextFieldAutoSize.NONE;
         return style;
      }
      
      public static function get styleChatSenderName() : TextStyle
      {
         var style:TextStyle = styleSingleLine;
         style.font = FONT_FACE_MEDIUM;
         style.fontSize = FONT_SIZE_EXTRA_SMALL;
         style.fontColor = CODO_BLUE_LIGHT;
         style.multiLine = false;
         style.wordWrap = false;
         style.autoSize = TextFieldAutoSize.NONE;
         return style;
      }
      
      public static function get styleChatMessage() : TextStyle
      {
         var style:TextStyle = styleSingleLine;
         style.font = FONT_FACE_MEDIUM;
         style.fontSize = FONT_SIZE_EXTRA_SMALL;
         style.multiLine = false;
         style.wordWrap = false;
         style.autoSize = TextFieldAutoSize.NONE;
         style.alignmentVertical = TextStyle.VALIGN_MIDDLE;
         return style;
      }
      
      public static function get styleLoudSpeakerRemainNum() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_NUMBERS;
         style.fontSize = FONT_SIZE_MEDIUM_SMALL;
         style.multiLine = false;
         style.wordWrap = false;
         style.autoSize = TextFieldAutoSize.NONE;
         style.alignment = TextStyle.HALIGN_RIGHT;
         return style;
      }
      
      public static function get styleLoudSpeakerRemain() : TextStyle
      {
         var style:TextStyle = styleSingleLine;
         style.font = FONT_FACE_BOLD;
         style.fontSize = FONT_SIZE_MEDIUM;
         style.fontColor = WHITE;
         return style;
      }
      
      public static function get styleInputCharacterRemain() : TextStyle
      {
         var style:TextStyle = styleSingleLine;
         style.font = FONT_FACE_MEDIUM;
         style.fontSize = FONT_SIZE_EXTRA_SMALL;
         style.fontColor = WHITE;
         style.alignment = TextFormatAlign.RIGHT;
         style.autoSize = TextFieldAutoSize.RIGHT;
         return style;
      }
      
      public static function get styleChannelLabel() : TextStyle
      {
         var style:TextStyle = styleSingleLine;
         style.font = FONT_FACE_BOLD;
         style.fontSize = FONT_SIZE_SMALL;
         style.fontColor = CODO_BLUE_LIGHT;
         return style;
      }
      
      public static function get styleChannelName() : TextStyle
      {
         var style:TextStyle = styleSingleLine;
         style.font = FONT_FACE_MEDIUM;
         style.fontSize = FONT_SIZE_EXTRA_SMALL;
         return style;
      }
      
      public static function get styleGlobalChannelNote() : TextStyle
      {
         var style:TextStyle = styleSingleLine;
         style.font = FONT_FACE_BOLD;
         style.fontSize = FONT_SIZE_MEDIUM;
         style.alignment = TextStyle.HALIGN_CENTER;
         return style;
      }
      
      public static function get stylePrivateChannelSelector() : TextStyle
      {
         var style:TextStyle = styleSingleLine;
         style.font = FONT_FACE_MEDIUM;
         style.fontSize = FONT_SIZE_EXTRA_SMALL;
         return style;
      }
      
      public static function get styleBigLoudSpeakerSender() : TextStyle
      {
         var style:TextStyle = styleSingleLine;
         style.font = FONT_FACE_MEDIUM;
         style.fontSize = FONT_SIZE_MEDIUM_SMALL;
         style.fontColor = CODO_YELLOW;
         return style;
      }
      
      public static function get styleBigLoudSpeakerMessage() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.multiLine = true;
         style.wordWrap = true;
         style.autoSize = TextFieldAutoSize.NONE;
         style.font = GlobalGuide.FONT_FACE_MEDIUM;
         style.fontSize = FONT_SIZE_MEDIUM_SMALL;
         style.fontColor = CODO_YELLOW;
         return style;
      }
      
      public static function get roomChatTabButton() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_BOLD;
         style.fontSize = FONT_SIZE_EXTRA_SMALL;
         style.autoSize = TextFieldAutoSize.NONE;
         style.alignmentVertical = TextStyle.VALIGN_MIDDLE;
         style.alignment = TextStyle.HALIGN_CENTER;
         return style;
      }
      
      public static function tint(enable:Boolean, mc:DisplayObject, color:uint = 0) : void
      {
         var colorTransform:ColorTransform = new ColorTransform();
         if(enable)
         {
            colorTransform.color = color;
         }
         mc.transform.colorTransform = colorTransform;
      }
   }
}

