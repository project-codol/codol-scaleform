package codo.views
{
   import codo.base.PopupView;
   import codo.constants.BCEvent;
   import codo.constants.DataID;
   import codo.constants.MsgBtnCount;
   import codo.localization.DictInGame;
   import codo.localization.DictParty;
   import codo.localization.DictRoom;
   import codo.services.MatchService;
   import flash.text.TextField;
   
   public class LaunchTrainingPopupView extends PopupView
   {
      
      private static const POPUP_HEIGHT:Number = 490;
      
      private static const POPUP_WIDTH:Number = 750;
      
      public var myDescription:TextField;
      
      private var mEntranceType:int = 1;
      
      private var mJumpMatchPara:Object;
      
      public function LaunchTrainingPopupView()
      {
         super();
         myPopup.keepBogusHeightCode = false;
      }
      
      override protected function enableData() : void
      {
         super.enableData();
         myPopup.width = POPUP_WIDTH;
         myPopup.height = POPUP_HEIGHT;
         myPopup.resetButtons();
         myPopup.configConfirmButton("@SF_UI_ENTER_FIRING_RANGE",this.launchTraining,true);
         myPopup.configCancelButton(DictInGame.Cancel,closePopupView);
         myPopup.header.title = "@SF_UI_LAUNCH_TRAINING_TITLE";
         this.myDescription.text = "@SF_UI_LAUNCH_TRAINING_DESC";
      }
      
      override public function set routeData(data:*) : void
      {
         super.routeData = data;
         this.mJumpMatchPara = data;
      }
      
      private function launchTraining() : void
      {
         if(MatchService.getInstance().isInRoom)
         {
            showMsg(DictRoom.NOTE_ALREADY_IN_RANKED_MATCH,MsgBtnCount.ONE);
            return;
         }
         if(Boolean(DataManager.getDP(DataID.IS_IN_PARTY)))
         {
            EventManager.broadcast(BCEvent.PARTY_LEAVE,DictParty.LEAVE_PARTY_DUE_TO_TRAINING);
            return;
         }
         broadcast(BCEvent.EVT_RESET_WARGOD_HIDDEN_ROOM);
         broadcast(BCEvent.EVT_RESET_BCL_HIDDEN_ROOM);
         if(null != this.mJumpMatchPara)
         {
            DataManager.request(DataID.JUMP_GAME,this.mJumpMatchPara);
         }
      }
   }
}

