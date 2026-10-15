package codo.controllers
{
   import codo.base.BaseController;
   import codo.common.CFunctionCommonContainer;
   import codo.constants.DataID;
   import codo.theme.BaseTheme;
   import codo.theme.BattleCityTheme;
   import codo.theme.CODOTheme;
   import codo.theme.DystopicTheme;
   import codo.theme.ESportTheme;
   import codo.theme.SDPTheme;
   import codo.theme.SpaceStationTheme;
   
   public class ThemeController extends BaseController
   {
      
      private var mThemeSuite:Array;
      
      private var mCurrentThemeSuite:BaseTheme;
      
      public function ThemeController()
      {
         super();
         this.mThemeSuite = [new CODOTheme(),new ESportTheme(),new SDPTheme(),new DystopicTheme(),new BattleCityTheme(),new SpaceStationTheme()];
      }
      
      override protected function onInitialized() : void
      {
         super.onInitialized();
         this.loadThemeConfigure();
         addDP(DataID.GET_THEME_SUITE,this.getThemeSuite);
      }
      
      private function loadThemeConfigure() : void
      {
         var themeID:int = getDvarInt("ui_theme");
         if(themeID < this.mThemeSuite.length)
         {
            this.mCurrentThemeSuite = this.mThemeSuite[themeID];
            CFunctionCommonContainer.Assert(this.mCurrentThemeSuite.getThemePieceLinkages().length == BaseTheme.MAX_PIECES,new Error());
         }
      }
      
      private function getThemeSuite() : BaseTheme
      {
         return this.mCurrentThemeSuite;
      }
   }
}

