package codo.views.hud.popups.HudVotePopup_parts
{
   import codo.localization.Dict;
   import codo.utils.LocalizeUtil;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class HudSystemVotePanel extends MovieClip
   {
      
      public static const VOTE_STATE_NONE:int = 0;
      
      public static const VOTE_STATE_AGREED:int = 1;
      
      public static const VOTE_STATE_REJECTED:int = 2;
      
      public static const VOTE_STATE_PASSED:int = 3;
      
      public var myTitleTF:TextField;
      
      public var myHintTF:TextField;
      
      public var myOptionsTF:TextField;
      
      public var myAgreeRatioTF:TextField;
      
      public var myCountDownTF:TextField;
      
      public var myBg:MovieClip;
      
      public function HudSystemVotePanel()
      {
         super();
      }
      
      public function cppPropose(param:Object) : void
      {
         this.myTitleTF.text = Dict.VOTE_SYSTEM_DETECTED_INACTIVE_PLAYER;
         LocalizeUtil.paramColorized(this.myHintTF,Dict.VOTE_WHETHER_KICK_PLAYER,[param.targetName],[16777164]);
         this.myCountDownTF.visible = true;
         this.updateVoteState(param.votedState);
         this.setRatio(param.agree,param.total);
         this.refreshLayout();
      }
      
      public function cppStatusChange(param:Object) : void
      {
         this.setRatio(param.agree,param.total);
         this.updateVoteState(param.votedState);
      }
      
      public function cppResult(param:Object) : void
      {
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
         this.myOptionsTF.y = this.myAgreeRatioTF.y = this.myHintTF.y + this.myHintTF.textHeight + 20;
         this.myBg.height = this.myOptionsTF.y + 20;
      }
      
      private function updateVoteState(voteState:int) : void
      {
         if(voteState == VOTE_STATE_NONE)
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
      
      private function setRatio(agree:int, total:int) : void
      {
         this.myAgreeRatioTF.text = agree.toString() + "/" + total.toString();
      }
   }
}

