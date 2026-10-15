package codo.views
{
   import codo.base.BaseView;
   import codo.common.CFunctionContainer;
   import codo.constants.Common;
   import codo.constants.DataCommonID;
   import codo.constants.DataID;
   import codo.objects.MOTDCheckinRewardObj;
   import codo.objects.ProductObj;
   import codo.objects.ResultObj;
   import codo.objects.SummaryObj;
   import codo.views.quit_parts.QuitGameSummaryContent;
   
   public class QuitGameSummaryView extends BaseView
   {
      
      public var myContent:QuitGameSummaryContent;
      
      private var mEarnedIndex:int = -1;
      
      private var mReward:MOTDCheckinRewardObj;
      
      public function QuitGameSummaryView()
      {
         super();
      }
      
      override protected function showView() : void
      {
         super.showView();
         this.myContent.active();
      }
      
      override protected function hideView() : void
      {
         super.hideView();
         this.myContent.deactive();
      }
      
      override protected function enableData() : void
      {
         super.enableData();
         this.mEarnedIndex = -1;
         this.mReward = null;
         CFunctionContainer.SavePlayerStats();
         this.refreshSummary();
         bind(DataID.DATA_RECEIVE,this.bind_dataReceived);
         this.myContent.setNextSupplyDropReward(this.getNextLoginReward(),this.mReward);
      }
      
      private function getNextLoginReward() : ProductObj
      {
         var item:MOTDCheckinRewardObj = null;
         var nextItem:ProductObj = null;
         var rewards:Vector.<MOTDCheckinRewardObj> = getDP(DataID.CHECKIN_REWARDS);
         var len:int = int(rewards.length);
         var allEarned:Boolean = true;
         for(var i:int = 0; i < len; i++)
         {
            item = rewards[i];
            if(item.isEarned)
            {
               this.mEarnedIndex = i;
            }
            allEarned &&= item.isEarned;
         }
         if(!allEarned)
         {
            this.mReward = rewards[this.mEarnedIndex + 1];
            nextItem = ProductObj.makeItemOrGp(this.mReward.itemID,this.mReward.gp);
         }
         return nextItem;
      }
      
      override protected function disableData() : void
      {
         super.disableData();
         unbind(DataID.DATA_RECEIVE,this.bind_dataReceived);
      }
      
      private function refreshSummary() : void
      {
         var data:Object = getDP(DataCommonID.SUMMARY_DATA);
         if(data != null)
         {
            this.myContent.summaryData = new SummaryObj(data);
            this.myContent.visible = true;
         }
         else
         {
            this.myContent.visible = false;
         }
      }
      
      private function bind_dataReceived(cRes:Object) : void
      {
         if(cRes.result == ResultObj.RESULT_SUCCESS && cRes.data == Common.PLAYERDATA_RECEIVED)
         {
            this.refreshSummary();
         }
      }
   }
}

