package codo.theme
{
   import codo.component.navigation.parts.NavigationButton;
   import codo.style.ButtonGuide;
   import codo.style.GlobalGuide;
   import codo.style.TextStyle;
   import flash.utils.getDefinitionByName;
   
   public class SpaceStationTheme extends BaseTheme implements ITheme
   {
      
      private static const GREY_COLOR:uint = 12827829;
      
      private static const DEEP_BLUE_COLOR:uint = 3225678;
      
      public function SpaceStationTheme()
      {
         super();
         themePieceLinkages = ["codo.views.persistentView.SpaceStationCODOLogo","codo.views.persistentView.SpaceStationPrimaryNavigationMenu","codo.views.persistent.SpaceStationSocialButtonBackGround","","","","","","",""];
      }
      
      public function getThemeColor() : uint
      {
         return GREY_COLOR;
      }
      
      public function buildPrimaryMenuButton() : NavigationButton
      {
         var cls:Class = getDefinitionByName("codo.shared.SpaceStationPrimaryNavigationButton") as Class;
         var item:NavigationButton = new cls() as NavigationButton;
         var style:TextStyle = ButtonGuide.styleButtonCommon;
         style.font = GlobalGuide.FONT_FACE_MEDIUM;
         style.alignment = TextStyle.HALIGN_CENTER;
         style.alignmentVertical = TextStyle.VALIGN_TOP;
         style.fontColor = GREY_COLOR;
         style.autoSize = TextStyle.HALIGN_LEFT;
         style.fontSize = 20;
         item.textStyle = style;
         item.labelUnfocusColor = GREY_COLOR;
         item.labelFocusColor = GlobalGuide.WHITE;
         item.setCustomizeFilter([],[],[]);
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
         return this.getThemeColor();
      }
      
      public function getOptionButtonColor() : uint
      {
         return DEEP_BLUE_COLOR;
      }
   }
}

