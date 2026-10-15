package codo.views.persistentView_parts
{
   import codo.component.navigation.NavigationMenu;
   import codo.constants.DataID;
   import codo.manager.DataManager;
   import codo.theme.ITheme;
   import flash.display.Sprite;
   
   public class PrimaryNavigationMenu extends NavigationMenu
   {
      
      private static const TEXT_OFFSET:uint = 50;
      
      public var myPrimaryMenuItemHolder:Sprite;
      
      public function PrimaryNavigationMenu()
      {
         super();
      }
      
      override protected function isPrimaryNav() : Boolean
      {
         return true;
      }
      
      override protected function initStage() : void
      {
         myFocusGlow.alpha = 0.5;
      }
      
      override public function showMenu() : void
      {
         visible = true;
      }
      
      override public function hideMenu() : void
      {
         visible = false;
      }
      
      public function initTheme(gameOptions:GameOptionsPanel) : void
      {
         var theme:ITheme = DataManager.getInstance().getDP(DataID.GET_THEME_SUITE);
         gameOptions.setButtonColor(theme.getOptionButtonColor());
         navButtonRenderMethod = theme.buildPrimaryMenuButton;
      }
      
      override protected function get menuItemHolder() : Sprite
      {
         return this.myPrimaryMenuItemHolder;
      }
      
      override public function get width() : Number
      {
         return this.myPrimaryMenuItemHolder.width + TEXT_OFFSET;
      }
      
      override public function get x() : Number
      {
         return this.myPrimaryMenuItemHolder.x;
      }
      
      override public function set x(value:Number) : void
      {
         this.myPrimaryMenuItemHolder.x = value;
      }
   }
}

