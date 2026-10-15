package codo.style
{
   import flash.text.TextFieldAutoSize;
   
   public class FriendGuide extends GlobalGuide
   {
      
      public function FriendGuide()
      {
         super();
      }
      
      public static function get styleTitle() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.fontSize = 44;
         style.fontColor = WHITE;
         style.font = GlobalGuide.FONT_FACE_BOLD;
         return style;
      }
      
      public static function get styleRelationSelector() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.fontSize = FONT_SIZE_SMALL;
         style.fontColor = WHITE;
         style.font = FONT_FACE_BOLD;
         return style;
      }
      
      public static function get styleFriendInviteLabel() : TextStyle
      {
         var style:TextStyle = null;
         style = new TextStyle();
         style.fontSize = FONT_SIZE_SMALL;
         style.fontColor = GRAY_80;
         return style;
      }
      
      public static function get styleFilterLabel() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.fontSize = FONT_SIZE_SMALL;
         style.fontColor = GRAY_80;
         return style;
      }
      
      public static function get styleFriendName() : TextStyle
      {
         var style:TextStyle = null;
         style = new TextStyle();
         style.multiLine = false;
         style.wordWrap = false;
         style.font = GlobalGuide.FONT_FACE_MEDIUM;
         style.autoSize = TextFieldAutoSize.NONE;
         style.fontSize = FONT_SIZE_SMALL;
         return style;
      }
      
      public static function get styleStatusLabel() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.fontSize = FONT_SIZE_SMALL;
         style.font = FONT_FACE_BOLD;
         style.fontColor = WHITE;
         return style;
      }
   }
}

