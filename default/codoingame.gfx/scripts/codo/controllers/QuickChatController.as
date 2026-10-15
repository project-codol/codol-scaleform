package codo.controllers
{
   import codo.base.BaseController;
   import codo.constants.BCInGameEvent;
   import codo.constants.CodoInGamePageDB;
   import codo.constants.DataID;
   import codo.constants.ViewState;
   import codo.event.ParaEvent;
   import codo.manager.PageInGameManager;
   
   public class QuickChatController extends BaseController
   {
      
      private var mChannel:int;
      
      private var mFrequencyTimeLimit:int;
      
      private var mFrequencyNumLimit:int;
      
      private var mLastCDTime:Number;
      
      private var mCDTimeMessageCount:int;
      
      public function QuickChatController()
      {
         super();
      }
      
      override protected function onInitialized() : void
      {
         this.mChannel = 0;
         this.mLastCDTime = 0;
         this.mCDTimeMessageCount = 0;
         addDP(DataID.GET_QUICK_CHAT_CHANNEL,this.getQuickChatChannel);
         addDP(DataID.IS_QUICK_CHAT_CD_AVAILABLE,this.isQuickChatCDAvailable);
         listen(BCInGameEvent.EVT_QUICK_CHAT_UPDATE_CD,this.onQuickChatUpdateCD);
      }
      
      public function cppShowQuickChatWheel(channel:int, fraquencyTimeLimit:int, fraquencyNumLimit:int) : void
      {
         this.mChannel = channel;
         this.mFrequencyTimeLimit = fraquencyTimeLimit;
         this.mFrequencyNumLimit = fraquencyNumLimit;
         PageInGameManager.getInstance().showPage(CodoInGamePageDB.PAGE_QUICK_CHAT,false,ViewState.ACTIVATED,null);
      }
      
      public function cppHideQuickChatWheel() : void
      {
         this.mChannel = 0;
         PageInGameManager.getInstance().cleanPageLayer(CodoInGamePageDB.PAGE_QUICK_CHAT.owner);
      }
      
      private function getQuickChatChannel() : int
      {
         return this.mChannel;
      }
      
      private function isQuickChatCDAvailable() : Boolean
      {
         var currentTime:Number = new Date().time / 1000;
         if(currentTime - this.mLastCDTime >= this.mFrequencyTimeLimit)
         {
            return true;
         }
         if(this.mCDTimeMessageCount >= this.mFrequencyNumLimit)
         {
            return false;
         }
         return true;
      }
      
      private function onQuickChatUpdateCD(evt:ParaEvent) : void
      {
         var currentTime:Number = new Date().time / 1000;
         if(currentTime - this.mLastCDTime >= this.mFrequencyTimeLimit)
         {
            this.mLastCDTime = currentTime;
            this.mCDTimeMessageCount = 1;
         }
         else
         {
            this.mCDTimeMessageCount += 1;
         }
      }
   }
}

