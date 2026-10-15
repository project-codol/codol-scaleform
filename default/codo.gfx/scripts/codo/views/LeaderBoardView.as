package codo.views
{
   import codo.base.BaseView;
   import codo.component.CloseButton;
   import codo.component.TextField;
   import codo.constants.BCEvent;
   import codo.constants.DataID;
   import codo.localization.Dict;
   import codo.style.LeaderBoardGuide;
   import codo.views.leaderboard_sub.LeaderBoardDetailPanel;
   import codo.views.leaderboard_sub.LeaderBoardSelectPanel;
   
   public class LeaderBoardView extends BaseView
   {
      
      private static const LEADERBOARD_GROUP_PVP:String = "PVP";
      
      private static const LEADERBOARD_GROUP_PVE:String = "PVE";
      
      public var myTitle:TextField;
      
      public var myCloseBtn:CloseButton;
      
      public var myLeaderBoardSelectPanel:LeaderBoardSelectPanel;
      
      public var myLeaderBoardDetailPanel:LeaderBoardDetailPanel;
      
      public function LeaderBoardView()
      {
         super();
         this.initStage();
      }
      
      private static function sortByPriority(obj1:Object, obj2:Object) : int
      {
         return obj1.priority - obj2.priority;
      }
      
      private function initStage() : void
      {
         this.myTitle.textStyle = LeaderBoardGuide.styleTitle;
         this.myTitle.text = Dict.MAIN_MENU_LABEL_LEADERBOARD;
         this.myLeaderBoardSelectPanel.registerLBSelectionChangeHandler(this.onLeaderBoardSelectChanged);
         this.myCloseBtn.registerClickEvent(this.onCloseBtnClicked);
      }
      
      override protected function enableData() : void
      {
         super.enableData();
         this.myLeaderBoardSelectPanel.active();
         this.myLeaderBoardDetailPanel.active();
         var leaderBoardList:Object = getDP(DataID.LEADERBOARD_LIST);
         this.SetLeaderBoardList(leaderBoardList);
      }
      
      override protected function disableData() : void
      {
         this.myLeaderBoardSelectPanel.deactive();
         this.myLeaderBoardDetailPanel.deactive();
         super.disableData();
      }
      
      private function onCloseBtnClicked() : void
      {
         broadcast(BCEvent.EVT_CLOSE_LEADERBOARD);
      }
      
      private function SetLeaderBoardList(data:Object) : void
      {
         var key:String = null;
         var i:uint = 0;
         var pvpLB:Vector.<Object> = new Vector.<Object>();
         var pveLB:Vector.<Object> = new Vector.<Object>();
         var pvpCategoryObj:Object = data[LEADERBOARD_GROUP_PVP];
         if(pvpCategoryObj != null)
         {
            for(key in pvpCategoryObj)
            {
               pvpCategoryObj[key].options.sort(sortByPriority);
               for(i = 0; i < pvpCategoryObj[key].options.length; i++)
               {
                  pvpCategoryObj[key].options[i].id = i;
               }
               pvpLB.push(pvpCategoryObj[key]);
            }
         }
         var pveCategoryObj:Object = data[LEADERBOARD_GROUP_PVE];
         if(pveCategoryObj != null)
         {
            for(key in pveCategoryObj)
            {
               pveCategoryObj[key].options.sort(sortByPriority);
               for(i = 0; i < pveCategoryObj[key].options.length; i++)
               {
                  pveCategoryObj[key].options[i].id = i;
               }
               pveLB.push(pveCategoryObj[key]);
            }
         }
         pvpLB.sort(sortByPriority);
         pveLB.sort(sortByPriority);
         this.myLeaderBoardSelectPanel.setData(pvpLB,pveLB);
      }
      
      private function onLeaderBoardSelectChanged(lbObj:Object) : void
      {
         this.myLeaderBoardDetailPanel.refreshFilters();
         this.myLeaderBoardDetailPanel.showLeaderBoard(lbObj);
      }
   }
}

