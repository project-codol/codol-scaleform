package codo.views.wargod_parts
{
   import codo.base.BaseSubElement;
   import codo.component.ScrollGrid;
   import codo.component.factory.ButtonFactory;
   import codo.constants.BCEvent;
   import codo.constants.DataID;
   import codo.objects.ScrollGridSettings;
   import codo.objects.ScrollListHeaderObj;
   import codo.objects.ScrollListSettings;
   import codo.objects.ScrollListTwoLabelHeaderObj;
   import codo.objects.WarGodSeasonHistroy;
   import codo.objects.WarGodSeasonObj;
   import codo.objects.WarGodSeasonStatsObj;
   
   public class WarGodSeasonHistoryPanel extends BaseSubElement
   {
      
      public var myScrollGrid:ScrollGrid;
      
      public function WarGodSeasonHistoryPanel()
      {
         super();
         this.initStage();
      }
      
      private function initStage() : void
      {
         var gridSettings:ScrollGridSettings = new ScrollGridSettings();
         gridSettings.orientation = ScrollListSettings.SCROLL_VERTICAL;
         gridSettings.useNavArrows = false;
         gridSettings.buildGridItemRenderMethod = ButtonFactory.BUILD_WARGOD_SEASON_HISTORY_ROW;
         this.myScrollGrid.initGrid(gridSettings,688,true,1);
         this.myScrollGrid.visible = false;
      }
      
      override public function active() : void
      {
         super.active();
         broadcast(BCEvent.EVT_FETCH_WARGOD_HISTROY_SEASON);
         bind(DataID.WARGOD_HISTROY_SEASON_RESULT,this.onGetHistroySeasonData);
      }
      
      override public function deactive() : void
      {
         super.deactive();
         unbind(DataID.WARGOD_HISTROY_SEASON_RESULT,this.onGetHistroySeasonData);
      }
      
      private function onGetHistroySeasonData(cRes:Object) : void
      {
         var data:WarGodSeasonHistroy = null;
         var historyData:WarGodSeasonStatsObj = null;
         var leaderBoardData:Array = cRes.data;
         var historyList:Vector.<WarGodSeasonStatsObj> = new Vector.<WarGodSeasonStatsObj>();
         for(var i:int = 0; i < leaderBoardData.length; i++)
         {
            data = leaderBoardData[i] as WarGodSeasonHistroy;
            historyData = new WarGodSeasonStatsObj();
            historyData.seasonData = getDP(DataID.GET_SEASON_BY_ID,[data.seasonID]);
            historyData.seasonRank = data.rank;
            historyData.score = data.score;
            historyList.push(historyData);
         }
         this.showList(historyList);
         this.myScrollGrid.visible = true;
      }
      
      private function showList(historyData:Vector.<WarGodSeasonStatsObj>) : void
      {
         var seasonData:WarGodSeasonObj = null;
         var header:ScrollListTwoLabelHeaderObj = null;
         var seasonStats:Vector.<WarGodSeasonStatsObj> = historyData;
         var headers:Vector.<ScrollListHeaderObj> = new Vector.<ScrollListHeaderObj>(0);
         var statList:Vector.<Object> = new Vector.<Object>();
         var startIndex:int = 0;
         var len:int = int(seasonStats.length);
         for(var i:int = 0; i < len; i++)
         {
            seasonData = seasonStats[i].seasonData;
            header = new ScrollListTwoLabelHeaderObj();
            header.beforeIndex = startIndex;
            header.subLabel = " ";
            header.label = seasonData.timeForShow;
            headers.push(header);
            startIndex += 1;
            statList.push(seasonStats[i]);
         }
         this.myScrollGrid.setHeaders(headers);
         this.myScrollGrid.addItemsByVector(statList);
      }
   }
}

