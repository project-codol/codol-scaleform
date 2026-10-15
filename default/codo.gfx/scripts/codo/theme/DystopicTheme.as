package codo.theme
{
   import codo.component.navigation.parts.NavigationButton;
   import codo.style.ButtonGuide;
   import codo.style.GlobalGuide;
   import codo.style.TextStyle;
   import flash.utils.getDefinitionByName;
   
   public class DystopicTheme extends BaseTheme implements ITheme
   {
      
      public function DystopicTheme()
      {
         super();
         themePieceLinkages = ["codo.views.persistentView.DystopicCODOLogo","codo.views.persistentView.DystopicPrimaryNavigationMenu","codo.views.persistent.DystopicSocialButtonBackGround","","","","","","",""];
      }
      
      public function getThemeColor() : uint
      {
         return 15777635;
      }
      
      public function buildPrimaryMenuButton() : NavigationButton
      {
         var cls:Class = getDefinitionByName("codo.shared.DystopicPrimaryNavigationButton") as Class;
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
         itm.labelFocusColor = GlobalGuide.WHITE;
         itm.themeColor = this.getThemeColor();
         itm.myLabel.filters = null;
         return itm;
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

