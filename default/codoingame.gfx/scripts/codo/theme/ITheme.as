package codo.theme
{
   import codo.component.navigation.parts.NavigationButton;
   
   public interface ITheme
   {
      
      function getThemeColor() : uint;
      
      function buildPrimaryMenuButton() : NavigationButton;
      
      function hasCODOLogoGlow() : Boolean;
      
      function getChatThemeColor() : uint;
      
      function getSocialButtonColor() : uint;
      
      function getOptionButtonColor() : uint;
   }
}

