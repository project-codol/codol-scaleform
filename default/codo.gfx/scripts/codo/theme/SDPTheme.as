package codo.theme
{
   import codo.component.navigation.parts.NavigationButton;
   import codo.style.ButtonGuide;
   import codo.style.GlobalGuide;
   import codo.style.TextStyle;
   import flash.filters.GlowFilter;
   import flash.utils.getDefinitionByName;
   
   public class SDPTheme extends BaseTheme implements ITheme
   {
      
      public function SDPTheme()
      {
         super();
         themePieceLinkages = ["codo.views.persistentView.SDPCODOLogo","codo.views.persistentView.SDPPrimaryNavigationMenu","codo.views.persistent.SDPSocialButtonBackGround","","","","","","",""];
      }
      
      public function getThemeColor() : uint
      {
         return 855309;
      }
      
      public function buildPrimaryMenuButton() : NavigationButton
      {
         var cls:Class = getDefinitionByName("codo.shared.SDPPrimaryNavigationButton") as Class;
         var itm:NavigationButton = new cls() as NavigationButton;
         var style:TextStyle = ButtonGuide.styleButtonCommon;
         style.font = GlobalGuide.FONT_FACE_MEDIUM;
         style.alignment = TextStyle.HALIGN_CENTER;
         style.alignmentVertical = TextStyle.VALIGN_TOP;
         style.fontColor = this.getThemeColor();
         style.autoSize = TextStyle.HALIGN_LEFT;
         style.fontSize = 20;
         itm.textStyle = style;
         itm.labelUnfocusColor = this.getThemeColor();
         itm.labelFocusColor = this.getThemeColor();
         itm.themeColor = this.getThemeColor();
         itm.myLabel.filters = null;
         itm.glowStyle = new GlowFilter(this.getThemeColor(),1,2,2);
         return itm;
      }
      
      public function hasCODOLogoGlow() : Boolean
      {
         return false;
      }
      
      public function getChatThemeColor() : uint
      {
         return 4375548;
      }
      
      public function getSocialButtonColor() : uint
      {
         return 4375548;
      }
      
      public function getOptionButtonColor() : uint
      {
         return this.getThemeColor();
      }
   }
}

