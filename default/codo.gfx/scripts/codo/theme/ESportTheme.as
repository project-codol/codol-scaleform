package codo.theme
{
   import codo.component.navigation.parts.NavigationButton;
   import codo.style.ButtonGuide;
   import codo.style.GlobalGuide;
   import codo.style.TextStyle;
   import flash.utils.getDefinitionByName;
   
   public class ESportTheme extends BaseTheme implements ITheme
   {
      
      public function ESportTheme()
      {
         super();
         themePieceLinkages = ["codo.views.persistentView.SDPCODOLogo","codo.views.persistentView.EsportsPrimaryNavigationMenu","codo.views.persistent.EsportsSocialButtonBackGround","codo.chat.EsportsControlPanel","codo.chat.EsportsMainChatPanel","codo.chat.EsportsChatList","codo.chat.EsportsLoudSpeakerbtn","codo.shared.EsportsPopup","codo.shared.EsportsContentSimpleBackground","codo.shared.EsportsWebImgRefreshButton"];
      }
      
      public function getThemeColor() : uint
      {
         return 16768674;
      }
      
      public function buildPrimaryMenuButton() : NavigationButton
      {
         var cls:Class = getDefinitionByName("codo.shared.EsportsPrimaryNavigationButton") as Class;
         var item:NavigationButton = new cls() as NavigationButton;
         var style:TextStyle = ButtonGuide.styleButtonCommon;
         style.font = GlobalGuide.FONT_FACE_MEDIUM;
         style.alignment = TextStyle.HALIGN_CENTER;
         style.alignmentVertical = TextStyle.VALIGN_TOP;
         style.fontColor = this.getThemeColor();
         style.autoSize = TextStyle.HALIGN_LEFT;
         style.fontSize = 20;
         item.textStyle = style;
         item.labelUnfocusColor = this.getThemeColor();
         item.themeColor = this.getThemeColor();
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
         return this.getThemeColor();
      }
   }
}

