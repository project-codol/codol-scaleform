package codo.views.hud.popups.HudVIPVoteInfoPopup_parts
{
   import codo.constants.GameInfo;
   import codo.localization.Dict;
   import codo.localization.DictVIP;
   import codo.views.hud.popups.HudVIPVoteInfoPopup;
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class HudVIPVoteInfoPanel extends MovieClip
   {
      
      public var myTitle:TextField;
      
      public var myHint:TextField;
      
      public var myYesText:TextField;
      
      public var myYesBtn:MovieClip;
      
      public var myNoText:TextField;
      
      public var myNoBtn:MovieClip;
      
      public var myAcceptSign:MovieClip;
      
      public var myDeclineSign:MovieClip;
      
      public var myBg:MovieClip;
      
      private var mVoteState:int;
      
      public function HudVIPVoteInfoPanel()
      {
         super();
         this.myTitle.text = DictVIP.VOTE_TITLE;
         this.myHint.text = DictVIP.VOTE_HINT;
         this.myYesText.text = Dict.SYS_ACCEPT;
         this.myNoText.text = Dict.SYS_REFUSE;
         this.voteState = HudVIPVoteInfoPopup.VOTE_STATE_VOTING;
      }
      
      protected function show() : void
      {
         TweenLite.killTweensOf(this);
         x = GameInfo.stagePosition.x - width;
         TweenLite.to(this,0.2,{"x":GameInfo.stagePosition.x});
      }
      
      public function set voteState(state:int) : void
      {
         this.mVoteState = state;
         TweenLite.killTweensOf(this.myAcceptSign);
         TweenLite.killTweensOf(this.myDeclineSign);
         switch(state)
         {
            case HudVIPVoteInfoPopup.VOTE_STATE_VOTING:
               this.myYesBtn.visible = this.myNoBtn.visible = this.myYesText.visible = this.myNoText.visible = true;
               this.myAcceptSign.visible = this.myDeclineSign.visible = false;
               break;
            case HudVIPVoteInfoPopup.VOTE_STATE_ACCEPTED:
               this.myYesBtn.visible = this.myNoBtn.visible = this.myYesText.visible = this.myNoText.visible = this.myDeclineSign.visible = false;
               this.myAcceptSign.visible = true;
               this.myAcceptSign.gotoAndStop(0);
               TweenLite.to(this.myAcceptSign,0.2,{
                  "onComplete":this.playAnimation,
                  "onCompleteParams":[this.myAcceptSign]
               });
               break;
            case HudVIPVoteInfoPopup.VOTE_STATE_DECLINE:
               this.myYesBtn.visible = this.myNoBtn.visible = this.myYesText.visible = this.myNoText.visible = this.myAcceptSign.visible = false;
               this.myDeclineSign.visible = true;
               this.myDeclineSign.gotoAndStop(0);
               TweenLite.to(this.myDeclineSign,0.2,{
                  "onComplete":this.playAnimation,
                  "onCompleteParams":[this.myDeclineSign]
               });
         }
      }
      
      public function get voteState() : int
      {
         return this.mVoteState;
      }
      
      private function playAnimation(mc:MovieClip) : void
      {
         mc.gotoAndPlay(0);
      }
   }
}

