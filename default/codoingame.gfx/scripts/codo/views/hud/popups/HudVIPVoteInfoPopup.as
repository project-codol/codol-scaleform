package codo.views.hud.popups
{
   import codo.constants.GameInfo;
   import codo.constants.HUDPopupComponentTypes;
   import codo.views.hud.HUDPopupComponent;
   import codo.views.hud.popups.HudVIPVoteInfoPopup_parts.HudVIPVoteInfoPanel;
   import com.greensock.TweenLite;
   import flash.events.KeyboardEvent;
   
   public class HudVIPVoteInfoPopup extends HUDPopupComponent
   {
      
      public static const VOTE_STATE_VOTING:int = 0;
      
      public static const VOTE_STATE_ACCEPTED:int = 1;
      
      public static const VOTE_STATE_DECLINE:int = 2;
      
      private const MSG_SELECTION:int = 1;
      
      public var myPanel:HudVIPVoteInfoPanel;
      
      public function HudVIPVoteInfoPopup()
      {
         super();
         mBlurView = false;
         mShowMask = false;
      }
      
      override public function get CompType() : int
      {
         return HUDPopupComponentTypes.VIP_VOTE_INFO;
      }
      
      override protected function showView() : void
      {
         super.showView();
         TweenLite.killTweensOf(this);
         this.myPanel.x = GameInfo.stagePosition.x - this.myPanel.width;
         this.myPanel.y = 600;
         TweenLite.to(this.myPanel,0.2,{"x":GameInfo.stagePosition.x});
      }
      
      override public function onKeyboardEvent(cEvt:KeyboardEvent) : void
      {
         if(this.myPanel.voteState != VOTE_STATE_VOTING)
         {
            return;
         }
         var input:String = String.fromCharCode(cEvt.charCode).toUpperCase();
         trace(input);
         if(input == "Y" || input == "N")
         {
            Notify(this.MSG_SELECTION,{"input":input});
         }
      }
   }
}

