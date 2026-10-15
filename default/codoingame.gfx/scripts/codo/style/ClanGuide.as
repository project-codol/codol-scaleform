package codo.style
{
   import flash.text.TextFieldAutoSize;
   
   public class ClanGuide extends GlobalGuide
   {
      
      public static const ITEM_BTN_WIDTH:Number = 93;
      
      public static const ITEM_BTN_HEIGHT:Number = 31;
      
      public static const ITEM_BTN_Y_PADDING:Number = 2;
      
      public static const ITEM_BTN_X_PADDING:Number = 2;
      
      public static const TOOL_TIP_ITEM_WIDTH:Number = 100;
      
      public static const TOOL_TIP_ITEM_HEIGHT:Number = 28;
      
      public static const ONLINE_COLOR:uint = 65280;
      
      public static const INGAME_COLOR:uint = 16711680;
      
      public static const OFFLINE_COLOR:uint = 10658992;
      
      public static const WARNING_COLOR:uint = 16750848;
      
      public static const MAX_ANNO_TEXT_COUNT:int = 120;
      
      public static const MAX_DESC_TEXT_COUNT:int = 120;
      
      public static const BRONZE_COLOR:uint = 12945747;
      
      public static const SILVER_COLOR:uint = 8290950;
      
      public static const GOLD_COLOR:uint = 16506471;
      
      public static const PLATINUM_COLOR:uint = 13191906;
      
      public static const DIAMOND_COLOR:uint = 5017469;
      
      public static const CTP_GAUGE_COLOR_ORANGE:Array = [15963911,16763904];
      
      public static const CTP_GAUGE_COLOR_BLUE:Array = [3646444,4708344];
      
      public function ClanGuide()
      {
         super();
      }
      
      public static function get styleClanHeader() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_BOLD;
         style.fontSize = FONT_SIZE_LARGE;
         style.fontColor = WHITE;
         return style;
      }
      
      public static function get styleClanTableHeader() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_BOLD;
         style.fontSize = FONT_SIZE_EXTRA_SMALL;
         style.fontColor = GRAY_80;
         return style;
      }
      
      public static function get styleClanLabel() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_BOLD;
         style.fontSize = FONT_SIZE_SMALL;
         style.fontColor = CODO_BLUE_HIGHLIGHT;
         return style;
      }
      
      public static function get styleClanValue() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_MEDIUM;
         style.fontSize = FONT_SIZE_EXTRA_SMALL;
         style.fontColor = WHITE;
         return style;
      }
      
      public static function get styleClanMultiLineValue() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.fontSize = FONT_SIZE_SMALL;
         style.multiLine = true;
         style.autoSize = TextFieldAutoSize.LEFT;
         style.alignment = TextStyle.HALIGN_CENTER;
         style.alignmentVertical = TextStyle.VALIGN_MIDDLE;
         style.wordWrap = true;
         return style;
      }
      
      public static function get styleItemRenderBoldText() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_BOLD;
         style.fontSize = FONT_SIZE_EXTRA_SMALL;
         style.fontColor = WHITE;
         return style;
      }
      
      public static function get styleItemRenderText() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_MEDIUM;
         style.fontSize = FONT_SIZE_EXTRA_SMALL;
         style.fontColor = WHITE;
         return style;
      }
      
      public static function get styleItemRenderNumberText() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_NUMBERS;
         style.fontSize = FONT_SIZE_EXTRA_SMALL;
         style.fontColor = WHITE;
         return style;
      }
      
      public static function get styleDropDownText() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.alignment = TextStyle.HALIGN_LEFT;
         style.alignmentVertical = TextStyle.VALIGN_MIDDLE;
         style.font = FONT_FACE_MEDIUM;
         style.fontSize = FONT_SIZE_EXTRA_SMALL;
         style.fontColor = WHITE;
         return style;
      }
      
      public static function get styleDropDownText2() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.multiLine = false;
         style.wordWrap = false;
         style.autoSize = TextFieldAutoSize.NONE;
         style.font = FONT_FACE_MEDIUM;
         style.fontSize = FONT_SIZE_EXTRA_SMALL;
         style.fontColor = WHITE;
         style.alignment = TextStyle.HALIGN_CENTER;
         style.alignmentVertical = TextStyle.VALIGN_MIDDLE;
         return style;
      }
      
      public static function get styleClanSummaryDetailLabel() : TextStyle
      {
         return styleClanLabel;
      }
      
      public static function get styleClanWarning() : TextStyle
      {
         var style:TextStyle = styleClanLabel;
         style.fontColor = WARNING_COLOR;
         return style;
      }
      
      public static function get styleClanTabButton() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_BOLD;
         style.fontSize = FONT_SIZE_EXTRA_SMALL;
         style.fontColor = GlobalGuide.NAV_TEXT_BLUE;
         style.alignment = TextStyle.HALIGN_CENTER;
         style.alignmentVertical = TextStyle.VALIGN_MIDDLE;
         style.border = true;
         return style;
      }
      
      public static function get stylePageListSelectorBtn() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_BOLD;
         style.fontSize = FONT_SIZE_EXTRA_SMALL;
         style.fontColor = GlobalGuide.CODO_BLUE_LIGHT;
         return style;
      }
      
      public static function get stylePlayerDetailLabelStyle() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_MEDIUM;
         style.fontSize = FONT_SIZE_EXTRA_SMALL;
         style.fontColor = GlobalGuide.WHITE;
         return style;
      }
      
      public static function get stylePlayerDetailLabelNumberStyle() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_NUMBERS;
         style.fontSize = FONT_SIZE_EXTRA_SMALL;
         style.fontColor = GlobalGuide.CODO_BLUE_LIGHT;
         return style;
      }
      
      public static function get stylePlayerDetailCategoryLabelStyle() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_MEDIUM;
         style.fontSize = FONT_SIZE_SMALL;
         style.fontColor = GlobalGuide.WHITE;
         return style;
      }
      
      public static function get stylePlayerDetailCategoryLabel2Style() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_MEDIUM;
         style.fontSize = FONT_SIZE_EXTRA_SMALL;
         style.fontColor = GlobalGuide.WHITE;
         return style;
      }
      
      public static function get styleCTPGaugeLabel() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_MEDIUM;
         style.fontSize = 16;
         style.fontColor = WHITE;
         return style;
      }
      
      public static function get styleCTPGaugeText() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_MEDIUM;
         style.fontSize = 16;
         style.fontColor = WHITE;
         return style;
      }
      
      public static function get styleClaimButtonLabel() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_MEDIUM;
         style.fontSize = FONT_SIZE_EXTRA_SMALL;
         style.fontColor = WHITE;
         style.alignment = TextStyle.HALIGN_CENTER;
         return style;
      }
      
      public static function get styleClaimRemainLabel() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_MEDIUM;
         style.autoSize = TextFieldAutoSize.NONE;
         style.alignment = TextStyle.HALIGN_CENTER;
         style.fontSize = FONT_SIZE_EXTRA_SMALL;
         style.fontColor = WHITE;
         return style;
      }
      
      public static function get styleClanOptionLabel() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_BOLD;
         style.fontSize = FONT_SIZE_EXTRA_SMALL;
         style.fontColor = WHITE;
         return style;
      }
      
      public static function get styleClanLeader() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_MEDIUM;
         style.fontSize = FONT_SIZE_SMALL;
         style.fontColor = WHITE;
         style.multiLine = false;
         style.wordWrap = false;
         style.autoSize = TextFieldAutoSize.NONE;
         return style;
      }
      
      public static function get styleClanLevelName() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_BOLD;
         style.fontSize = FONT_SIZE_MEDIUM;
         style.multiLine = false;
         style.wordWrap = false;
         style.autoSize = TextFieldAutoSize.NONE;
         style.alignment = TextStyle.HALIGN_CENTER;
         return style;
      }
      
      public static function get styleClanDailyDecay() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_MEDIUM;
         style.fontSize = FONT_SIZE_SMALL;
         style.autoSize = TextFieldAutoSize.NONE;
         style.alignment = TextStyle.HALIGN_CENTER;
         style.multiLine = true;
         style.wordWrap = true;
         return style;
      }
      
      public static function get styleClanID() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_MEDIUM;
         style.fontSize = FONT_SIZE_SMALL;
         return style;
      }
      
      public static function get styleClanSize() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_MEDIUM;
         style.fontSize = FONT_SIZE_SMALL;
         style.autoSize = TextFieldAutoSize.NONE;
         style.alignment = TextStyle.HALIGN_RIGHT;
         return style;
      }
      
      public static function get styleClanLogTitle() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_BOLD;
         style.fontSize = FONT_SIZE_LARGE;
         return style;
      }
      
      public static function get styleClanCommonTip() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_MEDIUM;
         style.fontSize = FONT_SIZE_EXTRA_SMALL;
         style.autoSize = TextFieldAutoSize.LEFT;
         style.wordWrap = false;
         style.multiLine = true;
         return style;
      }
      
      public static function get styleClanMultipleTip() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_MEDIUM;
         style.fontSize = FONT_SIZE_EXTRA_SMALL;
         style.autoSize = TextFieldAutoSize.LEFT;
         style.wordWrap = true;
         style.multiLine = true;
         return style;
      }
      
      public static function get styleClanSortableHeader() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_BOLD;
         style.fontSize = FONT_SIZE_EXTRA_SMALL;
         style.fontColor = GRAY_80;
         style.alignmentVertical = TextStyle.VALIGN_MIDDLE;
         style.alignment = TextStyle.HALIGN_LEFT;
         style.autoSize = TextFieldAutoSize.NONE;
         return style;
      }
      
      public static function get styleClanRule() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_MEDIUM;
         style.fontSize = FONT_SIZE_EXTRA_SMALL;
         style.fontColor = WHITE;
         style.autoSize = TextFieldAutoSize.NONE;
         style.alignment = TextStyle.HALIGN_LEFT;
         style.wordWrap = true;
         style.multiLine = true;
         return style;
      }
   }
}

