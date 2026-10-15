package codo.views.hud.popups.HudVotePopup_parts
{
   import codo.common.CFunctionInGameContainer;
   import codo.constants.DataInGameID;
   import codo.localization.Dict;
   import codo.manager.DataManager;
   import codo.utils.LocalizeUtil;
   import codo.views.hudSpy.PlayerNickname;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class HudVotePanel extends MovieClip
   {
      
      public static const PADDING:int = 5;
      
      public static const VOTE_STATE_NONE:int = 0;
      
      public static const VOTE_STATE_AGREED:int = 1;
      
      public static const VOTE_STATE_REJECTED:int = 2;
      
      public static const VOTE_STATE_PASSED:int = 3;
      
      public var myStarterNick:PlayerNickname;
      
      public var myStarterNameTF:TextField;
      
      public var myStaticSuggestTF:TextField;
      
      public var myTargetNick:PlayerNickname;
      
      public var myTargetNameTF:TextField;
      
      public var myVoteTypeTF:TextField;
      
      public var myReasonTF:TextField;
      
      public var myOptionsTF:TextField;
      
      public var myAgreeRatioTF:TextField;
      
      public var myCountDownTF:TextField;
      
      public var myBg:MovieClip;
      
      public function HudVotePanel()
      {
         super();
         this.myStaticSuggestTF.text = Dict.VOTE_SUGGEST;
      }
      
      public function cppPropose(param:Object) : void
      {
         this.setStarter(param.starterClientNum,param.starterName,param.voteType);
         this.setTarget(param.targetClientNum,param.targetName);
         this.setReason(param.reason,param.additionalText,param.voteType);
         this.updateVoteState(param.votedState);
         this.setRatio(param.agree,param.total);
         this.myCountDownTF.visible = true;
         this.myVoteTypeTF.text = "";
         if(param.voteType == 1)
         {
            this.myVoteTypeTF.text = Dict.VOTE_KICK_PLAYER;
         }
         else if(param.voteType == 2)
         {
            this.myVoteTypeTF.text = Dict.VOTE_KILL;
         }
         this.refreshLayout();
      }
      
      public function cppStatusChange(param:Object) : void
      {
         this.myAgreeRatioTF.text = param.agree.toString() + "/" + param.total.toString();
         this.updateVoteState(param.votedState);
      }
      
      public function cppResult(param:Object) : void
      {
         this.setStarter(param.starterClientNum,param.starterName,param.voteType);
         this.setTarget(param.targetClientNum,param.targetName);
         this.setReason(param.reason,param.additionalText,param.voteType);
         this.updateVoteResult(param.success);
         if(Boolean(param.success))
         {
            this.setRatio(param.agree,param.total);
         }
         else
         {
            this.myAgreeRatioTF.text = "";
         }
         this.myCountDownTF.visible = false;
         this.refreshLayout();
      }
      
      public function cppUpdateCoundDown(val:int) : void
      {
         this.myCountDownTF.text = val.toString();
      }
      
      private function setStarter(clientNum:int, name:String, voteType:int) : void
      {
         this.myStarterNick.visible = this.displayNicknameIcon();
         this.myStarterNick.nickname = (clientNum + 1).toString();
         name = name.length > 10 ? name.slice(0,8) + ".." : name;
         this.myStarterNameTF.text = name;
         if(!this.myStarterNick.visible)
         {
            this.myStarterNameTF.x = this.myStarterNick.x;
         }
         this.myStaticSuggestTF.x = this.myStarterNameTF.x + this.myStarterNameTF.textWidth + 5;
      }
      
      private function setTarget(clientNum:int, name:String) : void
      {
         this.myTargetNick.visible = this.displayNicknameIcon();
         this.myTargetNick.nickname = (clientNum + 1).toString();
         this.myTargetNameTF.text = name;
         if(!this.myTargetNick.visible)
         {
            this.myTargetNameTF.x = this.myTargetNick.x;
         }
      }
      
      private function setReason(reason:int, additionalText:String, voteType:int) : void
      {
         var reasonTypeString:String = CFunctionInGameContainer.AS_GetVoteReasonByVoteTypeAndReasonID(reason,voteType);
         additionalText = additionalText;
         var haveAdditionalText:Boolean = false;
         if(additionalText != "+")
         {
            haveAdditionalText = true;
            additionalText = additionalText.substring(1);
         }
         var innerReason:String = "";
         if(Boolean(reasonTypeString))
         {
            innerReason += LocalizeUtil.localize("@" + reasonTypeString);
         }
         if(haveAdditionalText)
         {
            if(Boolean(innerReason))
            {
               innerReason += "-";
            }
            innerReason += additionalText;
         }
         if(!innerReason)
         {
            innerReason = LocalizeUtil.localize(Dict.NOT_APPLICABLE);
         }
         LocalizeUtil.paramColorized(this.myReasonTF,Dict.VOTE_REASON_LONG,[innerReason],[52428]);
      }
      
      private function setRatio(agree:int, total:int) : void
      {
         this.myAgreeRatioTF.text = agree.toString() + "/" + total.toString();
         this.myAgreeRatioTF.y = this.myOptionsTF.y = this.myReasonTF.y + this.myReasonTF.textHeight + PADDING;
      }
      
      private function updateVoteState(voteState:int) : void
      {
         if(!CFunctionInGameContainer.AS_CurrentPlayerCanVote())
         {
            this.myOptionsTF.text = "";
         }
         else if(voteState == VOTE_STATE_NONE)
         {
            this.myOptionsTF.text = Dict.VOTE_OPTIONS;
         }
         else if(voteState == VOTE_STATE_AGREED)
         {
            this.myOptionsTF.text = Dict.VOTE_AGREED;
         }
         else if(voteState == VOTE_STATE_REJECTED)
         {
            this.myOptionsTF.text = Dict.VOTE_REJECTED;
         }
         else if(voteState == VOTE_STATE_PASSED)
         {
            this.myOptionsTF.text = Dict.VOTE_PASSED;
         }
      }
      
      private function updateVoteResult(success:int) : void
      {
         if(Boolean(success))
         {
            this.myOptionsTF.text = Dict.VOTE_PASSED;
         }
         else
         {
            this.myOptionsTF.text = Dict.VOTE_NOT_PASSED;
         }
      }
      
      private function refreshLayout() : void
      {
         var pos:Number = this.myStarterNick.height + PADDING + this.myTargetNick.height + PADDING + this.myReasonTF.textHeight + PADDING;
         this.myOptionsTF.y = pos;
         this.myAgreeRatioTF.y = pos;
         pos += this.myOptionsTF.height + PADDING;
         this.myBg.height = pos;
      }
      
      private function displayNicknameIcon() : Boolean
      {
         if(Boolean(DataManager.getInstance().getDP(DataInGameID.IS_SPY)))
         {
            return true;
         }
         return false;
      }
   }
}

