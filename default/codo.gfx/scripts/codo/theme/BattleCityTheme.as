package codo.theme
{
   import codo.component.navigation.parts.NavigationButton;
   import codo.style.ButtonGuide;
   import codo.style.GlobalGuide;
   import codo.style.TextStyle;
   import flash.filters.GlowFilter;
   import flash.utils.getDefinitionByName;
   
   public class BattleCityTheme extends BaseTheme implements ITheme
   {
      
      private static const GOLD_LIGHT_COLOR:uint = 16759040;
      
      private static const GOLD_DARK_COLOR:uint = 7819520;
      
      private static const GOLD_GLOW_COLOR:uint = 16759296;
      
      public function BattleCityTheme()
      {
         super();
         themePieceLinkages = ["codo.views.persistentView.BattleCityCODOLogo","codo.views.persistentView.BattleCityPrimaryNavigationMenu","codo.views.persistent.BattleCitySocialButtonBackGround","","","","","","",""];
      }
      
      public function getThemeColor() : uint
      {
         return 4375548;
      }
      
      public function buildPrimaryMenuButton() : NavigationButton
      {
         var style:TextStyle = null;
         var cls:Class = getDefinitionByName("codo.shared.BattleCityPrimaryNavigationButton") as Class;
         var item:NavigationButton = new cls() as NavigationButton;
         style = ButtonGuide.styleButtonCommon;
         style.font = GlobalGuide.FONT_FACE_MEDIUM;
         style.alignment = TextStyle.HALIGN_CENTER;
         style.alignmentVertical = TextStyle.VALIGN_TOP;
         style.fontColor = GOLD_LIGHT_COLOR;
         style.autoSize = TextStyle.HALIGN_LEFT;
         style.fontSize = 20;
         item.textStyle = style;
         item.labelUnfocusColor = GOLD_DARK_COLOR;
         item.setCustomizeFilter([],[new GlowFilter(GOLD_GLOW_COLOR,1,25,25)],[new GlowFilter(GOLD_GLOW_COLOR,1,5,5)]);
         item.customizeLabelOffset(25);
         item.customizeTextMargin(60);
         item.setButtonXOffset(-10);
         return item;
      }
      
      public function hasCODOLogoGlow() : Boolean
      {
         return false;
      }
      
      public function getChatThemeColor() : uint
      {
         return this.getThemeColor();
      }
      
      public function getSocialButtonColor() : uint
      {
         return GOLD_LIGHT_COLOR;
      }
      
      public function getOptionButtonColor() : uint
      {
         return GOLD_DARK_COLOR;
      }
   }
}

