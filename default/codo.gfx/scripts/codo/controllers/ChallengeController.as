package codo.controllers
{
   import codo.base.BaseController;
   import codo.common.CFunctionContainer;
   import codo.constants.BCEvent;
   import codo.constants.CodoPageViewDB;
   import codo.constants.Common;
   import codo.constants.DataID;
   import codo.constants.RankedMatchStatus;
   import codo.constants.SystemMsgPriority;
   import codo.event.ParaEvent;
   import codo.localization.Dict;
   import codo.objects.ChallengeObj;
   import codo.objects.DailyChallengeObj;
   import codo.objects.SystemMsgObj;
   import codo.utils.DataUtil;
   
   public class ChallengeController extends BaseController
   {
      
      private var _recentChallenges:Array = [];
      
      private var _isRecentChallengeEnabled:Boolean = true;
      
      private var _idxDismissedRecentChallenge:int = -1;
      
      private var _rerollChallange:DailyChallengeObj = null;
      
      public function ChallengeController()
      {
         super();
      }
      
      override protected function onInitialized() : void
      {
         this.addDP(DataID.IS_RECENT_CHALLENGE_ENABLED,this.getEnableChallenge);
         this.listen(BCEvent.CHALLENGE_DISMISS,this.onDismissChallengeHandle);
         this.listen(BCEvent.ON_ROOM_LEFT,this.onRoomLeftHandle);
         this.listen(BCEvent.ON_ROOM_JOINED,this.onRoomJoinedHandle);
         this.listen(BCEvent.RANKED_MATCH_STATUS_CHANGED,this.onRankedMatchStatusChangedHandle);
         this.listen(BCEvent.PARTY_STATE_CHANGED,this.onPartyStateChangedHandle);
         this.listen(BCEvent.OPEN_CHALLENGE_SUMMARY,this.openChallengeSummary);
         this.listen(BCEvent.OPEN_PIN_CHALLENGE,this.openPinChallenge);
         this.listen(BCEvent.REROLL_CHALLENGE,this.onReRollChallenge);
      }
      
      public function cppRefreshRecentChallenge(challenges:Array) : void
      {
         var i:uint = 0;
         if(challenges == null)
         {
            return;
         }
         if(this._idxDismissedRecentChallenge >= 0)
         {
            for(i = 0; i < challenges.length; i++)
            {
               if(!DataUtil.isInArray(challenges[i].id,this._recentChallenges))
               {
                  this.fillChallengeObj(this._recentChallenges[this._idxDismissedRecentChallenge],challenges[i]);
                  break;
               }
            }
         }
         else
         {
            for(i = 0; i < challenges.length; i++)
            {
               if(this._recentChallenges[i] == null)
               {
                  this._recentChallenges[i] = new ChallengeObj();
               }
               this.fillChallengeObj(this._recentChallenges[i],challenges[i]);
            }
            if(i < this._recentChallenges.length - 1)
            {
               this._recentChallenges.splice(i + 1,this._recentChallenges.length - 1 - i);
            }
         }
         if(this._idxDismissedRecentChallenge >= this._recentChallenges.length)
         {
            this._idxDismissedRecentChallenge = -1;
         }
         this.setBindData(this.isZM() ? DataID.RECENT_CHALLENGES_CYBORG : DataID.RECENT_CHALLENGES,{
            "challenges":this._recentChallenges,
            "index":this._idxDismissedRecentChallenge
         });
         this._idxDismissedRecentChallenge = -1;
      }
      
      private function onDismissChallengeHandle(cEvt:ParaEvent) : void
      {
         for(var i:uint = 0; i < this._recentChallenges.length; i++)
         {
            if(this._recentChallenges[i].id == cEvt.myPara)
            {
               this._idxDismissedRecentChallenge = i;
               break;
            }
         }
         CFunctionContainer.DismissChallenge(uint(cEvt.myPara));
      }
      
      private function getEnableChallenge() : Boolean
      {
         return this._isRecentChallengeEnabled;
      }
      
      private function fillChallengeObj(dest:ChallengeObj, src:Object) : void
      {
         var j:uint = 0;
         if(dest == null || src == null)
         {
            return;
         }
         this.resetChallengeObj(dest);
         dest.id = src.id;
         dest.target = src.target;
         dest.progress = src.progress;
         dest.name = src.name;
         dest.category = src.category;
         dest.description = src.description;
         dest.imageURL = src.imageURL;
         dest.complete = src.complete;
         dest.xpGained = src.xpGained;
         dest.gpGained = src.gpGained;
         for(j = 0; j < src.actionIds.length; j++)
         {
            dest.actionIDs.push(src.actionIds[j]);
         }
         var pageName:String = dest.actionIDs[Common.CHALLENGE_ACTION_ID_PAGE];
         dest.enablePageJump = pageName != "null";
         if(dest.xpGained > 0)
         {
            dest.items.push({
               "name":"XP",
               "imageURL":"",
               "count":dest.xpGained
            });
         }
         if(dest.gpGained > 0)
         {
            dest.items.push({
               "name":"GP",
               "imageURL":"",
               "count":dest.gpGained
            });
         }
         for(j = 0; j < src.items.length; j++)
         {
            dest.items.push(src.items[j]);
         }
      }
      
      private function resetChallengeObj(target:ChallengeObj) : void
      {
         if(target == null)
         {
            return;
         }
         target.id = 0;
         target.target = 0;
         target.progress = 0;
         target.name = "";
         target.description = "";
         target.imageURL = "";
         target.complete = false;
         target.xpGained = 0;
         target.gpGained = 0;
         target.actionIDs.splice(0);
         target.items.splice(0);
      }
      
      private function onPartyStateChangedHandle(cEvt:ParaEvent) : void
      {
         this.refreshChallengeState();
      }
      
      private function onRoomLeftHandle(cEvt:ParaEvent) : void
      {
         this.refreshChallengeState();
      }
      
      private function onRoomJoinedHandle(cEvt:ParaEvent) : void
      {
         this.refreshChallengeState();
      }
      
      private function onRankedMatchStatusChangedHandle(cEvt:ParaEvent) : void
      {
         this.refreshChallengeState();
      }
      
      private function refreshChallengeState() : void
      {
         var isInRoom:Boolean = this.getDP(DataID.IS_IN_ROOM);
         var isInParty:Boolean = this.getDP(DataID.IS_IN_PARTY);
         var isPartyHost:Boolean = this.getDP(DataID.IS_PARTY_HOST);
         var isInRankedMatch:Boolean = this.getDP(DataID.CURRENT_RANKED_MATCH_STATUS) != RankedMatchStatus.IDLE;
         this._isRecentChallengeEnabled = !isInRoom && !isInRankedMatch && !(isInParty && !isPartyHost);
         this.broadcast(BCEvent.SET_MATCH_STATE,this._isRecentChallengeEnabled);
      }
      
      private function isZM() : Boolean
      {
         return this.getDP(DataID.IS_CYBORG);
      }
      
      public function openChallengeSummary(cEvt:ParaEvent) : void
      {
         gotoPage(CodoPageViewDB.PAGE_POPUP_CHALLENGE_INFO,cEvt.myPara);
      }
      
      public function openPinChallenge(cEvt:ParaEvent) : void
      {
         gotoPage(CodoPageViewDB.PAGE_POPUP_PIN_CHALLENGE,cEvt.myPara);
      }
      
      public function onReRollChallenge(cEvt:ParaEvent) : void
      {
         this._rerollChallange = cEvt.myPara as DailyChallengeObj;
         var systemMsg:SystemMsgObj = SystemMsgObj.getObj(Dict.CHALLENGE_REROLL_POPUP_INSTRUCTIONS,2,SystemMsgPriority.NORMAL,this.onReRollChallengeConfirm,Dict.CONFIRM,null,Dict.CANCEL,null,"",0,0,Dict.CHALLENGE_REROLL_POPUP_HEADER);
         systemMsg.imageURL = "challenge_reroll_token.tga";
         this.broadcast(BCEvent.EVT_SHOW_SYSTEM_MSG,systemMsg);
      }
      
      private function onReRollChallengeConfirm() : void
      {
         if(this._rerollChallange != null)
         {
            this.broadcast(BCEvent.EVT_REWARD_REROLL_CHALLENGE_REQUEST,this._rerollChallange);
            this._rerollChallange = null;
         }
      }
   }
}

