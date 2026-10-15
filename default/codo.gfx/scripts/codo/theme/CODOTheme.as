package codo.theme
{
   import codo.component.navigation.parts.NavigationButton;
   import codo.style.ButtonGuide;
   import codo.style.GlobalGuide;
   import codo.style.TextStyle;
   import flash.utils.getDefinitionByName;
   
   public class CODOTheme extends BaseTheme implements ITheme
   {
      
      public function CODOTheme()
      {
         super();
         themePieceLinkages = ["","","","","","","","","",""];
      }
      
      public function getThemeColor() : uint
      {
         return 4375548;
      }
      
      public function buildPrimaryMenuButton() : NavigationButton
      {
         var cls:Class = getDefinitionByName("codo.shared.PrimaryNavigationButton") as Class;
         var item:NavigationButton = new cls() as NavigationButton;
         var style:TextStyle = ButtonGuide.styleButtonCommon;
         style.font = GlobalGuide.FONT_FACE_MEDIUM;
         style.alignment = TextStyle.HALIGN_CENTER;
         style.alignmentVertical = TextStyle.VALIGN_TOP;
         style.fontColor = GlobalGuide.NAV_TEXT_BLUE;
         style.autoSize = TextStyle.HALIGN_LEFT;
         style.fontSize = 20;
         item.textStyle = style;
         return item;
      }
      
      public function hasCODOLogoGlow() : Boolean
      {
         return true;
      }
      
      public function getChatThemeColor() : uint
      {
         return this.getThemeColor();
      }
      
      public function getSocialButtonColor() : uint
      {
         return this.getThemeColor();
      }
      
      public function getOptionButtonColor() : uint
      {
         return this.getThemeColor();
      }
   }
}

