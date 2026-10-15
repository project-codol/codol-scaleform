package codo.views.hud.popups
{
   import codo.common.CFunctionCommonContainer;
   import codo.constants.BCInGameEvent;
   import codo.constants.GameInfo;
   import codo.constants.HUDPopupComponentTypes;
   import codo.event.ParaEvent;
   import codo.localization.Dict;
   import codo.utils.LocalizeUtil;
   import codo.utils.ScaleformUtil;
   import codo.views.hud.HUDPopupComponent;
   import codo.views.hud.popups.HudVotePopup_parts.HudSystemVotePanel;
   import codo.views.hud.popups.HudVotePopup_parts.HudVotePanel;
   import flash.geom.Point;
   import flash.text.TextField;
   
   public class HudVotePopup extends HUDPopupComponent
   {
      
      private static const Y_ROTATION:int = -8;
      
      private static const MARGIN_LEFT:int = 28;
      
      public var myVotePanel:HudVotePanel;
      
      public var mySystemVotePanel:HudSystemVotePanel;
      
      public var myErrorNoticeTF:TextField;
      
      private var mCanVote:Boolean;
      
      public function HudVotePopup()
      {
         super();
         mBlurView = false;
         mShowMask = false;
         var stagePosition:Point = new Point(0,0);
         if(ScaleformUtil.isScaleform)
         {
            stagePosition = GameInfo.stagePosition;
         }
         this.myVotePanel.x = stagePosition.x + MARGIN_LEFT;
         this.myVotePanel.rotationY = Y_ROTATION;
         this.mySystemVotePanel.x = stagePosition.x + MARGIN_LEFT;
         this.mySystemVotePanel.rotationY = Y_ROTATION;
         this.myErrorNoticeTF.x = stagePosition.x + MARGIN_LEFT;
         this.myErrorNoticeTF.rotationY = Y_ROTATION;
         this.myErrorNoticeTF.width = 350;
      }
      
      override protected function showView() : void
      {
         super.showView();
         listen(BCInGameEvent.EVT_PLAYER_VOTE,this.onPlayerVote);
      }
      
      override protected function hideView() : void
      {
         super.hideView();
         unlisten(BCInGameEvent.EVT_PLAYER_VOTE,this.onPlayerVote);
      }
      
      override public function get CompType() : int
      {
         return HUDPopupComponentTypes.VOTE;
      }
      
      public function set canVote(canVote:Boolean) : void
      {
         this.mCanVote = canVote;
      }
      
      public function get canVote() : Boolean
      {
         return this.mCanVote;
      }
      
      private function onPlayerVote(evt:ParaEvent) : void
      {
         if(!this.canVote)
         {
            return;
         }
         var input:String = evt.myPara;
         input = input.toUpperCase();
         if(input != "Y" && input != "N")
         {
            return;
         }
         CFunctionCommonContainer.ScriptMenuResponse("vote_selection","vote|" + input);
         this.canVote = false;
      }
      
      public function cppShowVoteKickWarning(params:Object) : void
      {
         if(params.errorCode == 1)
         {
            this.myErrorNoticeTF.text = Dict.VOTE_FAILED_CONFLICT;
         }
         else
         {
            this.myErrorNoticeTF.text = LocalizeUtil.param(Dict.VOTE_FAILED_TOO_FREQUENT,[params.param.toString()]);
         }
      }
   }
}

