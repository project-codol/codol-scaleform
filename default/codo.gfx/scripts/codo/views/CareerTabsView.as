package codo.views
{
   import codo.base.BaseView;
   import codo.component.factory.ButtonFactory;
   import codo.component.navigation.NavigationMenu;
   import codo.component.object.NavigationObj;
   import codo.constants.BCEvent;
   import codo.constants.ButtonTLog;
   import codo.constants.PageID;
   import codo.event.ParaEvent;
   import codo.localization.DictRoom;
   import codo.localization.DictSummary;
   import codo.utils.ScaleformUtil;
   import codo.utils.TLogUtil;
   
   public class CareerTabsView extends BaseView
   {
      
      public static const TAB_BATTLE_EXPERIENCE:int = 0;
      
      public static const TAB_CHALLENGES:int = 1;
      
      public var myTabNavigation:NavigationMenu;
      
      public function CareerTabsView()
      {
         var secondaryButtons:Vector.<NavigationObj> = null;
         super();
         if(true == ScaleformUtil.isScaleform)
         {
            secondaryButtons = new <NavigationObj>[new NavigationObj(TAB_BATTLE_EXPERIENCE,DictRoom.SUMMARY_PROGRESS_TITLE),new NavigationObj(TAB_CHALLENGES,DictSummary.MISSION_AWARDS)];
         }
         else
         {
            secondaryButtons = new <NavigationObj>[new NavigationObj(TAB_BATTLE_EXPERIENCE,"BATTLE EXPERIENCE"),new NavigationObj(TAB_CHALLENGES,"CHALLENGES")];
         }
         this.myTabNavigation.navButtonRenderMethod = ButtonFactory.BUILD_SECONDARY_MENU_BUTTON;
         this.myTabNavigation.listItemClickCallback = this.onTabClicked;
         this.myTabNavigation.setData(secondaryButtons);
      }
      
      override protected function onInit() : void
      {
         super.onInit();
         listen(BCEvent.EVT_MAIN_PAGE_CHANGED,this.updateTab);
      }
      
      override public function set routeData(data:*) : void
      {
         super.routeData = data;
         var event:ParaEvent = data as ParaEvent;
         if(event.myPara == null)
         {
            return;
         }
         if(event.myPara.tabIndex != null)
         {
            this.myTabNavigation.selectedIndex = event.myPara.tabIndex;
         }
      }
      
      override protected function showView() : void
      {
         super.showView();
         this.myTabNavigation.showMenu();
      }
      
      override protected function hideView() : void
      {
         super.hideView();
         this.myTabNavigation.hideMenu();
      }
      
      private function updateTab(evt:ParaEvent) : void
      {
         var pageID:String = evt.myPara.id;
         if(pageID == PageID.CAREER_BATTLE_EXPERIENCE)
         {
            this.myTabNavigation.selectedIndex = TAB_BATTLE_EXPERIENCE;
         }
         else if(pageID == PageID.CAREER_CHALLENGES)
         {
            this.myTabNavigation.selectedIndex = TAB_CHALLENGES;
         }
      }
      
      private function onTabClicked(tab:NavigationObj) : void
      {
         if(tab.index == TAB_BATTLE_EXPERIENCE)
         {
            TLogUtil.TLog_UserInput(ButtonTLog.BUTTON_CAREER_BATTLE_EXPERIENCE);
            broadcast(BCEvent.EVT_GOTO_CAREER);
         }
         else if(tab.index == TAB_CHALLENGES)
         {
            TLogUtil.TLog_UserInput(ButtonTLog.BUTTON_CAREER_CHALLENGES);
            broadcast(BCEvent.EVT_GOTO_CAREER_CHALLENGES);
         }
      }
   }
}

