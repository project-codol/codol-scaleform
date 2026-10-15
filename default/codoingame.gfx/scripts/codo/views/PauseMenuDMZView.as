package codo.views
{
   import codo.common.CFunctionCommonContainer;
   import codo.common.CFunctionInGameContainer;
   import codo.constants.BCEvent;
   import codo.constants.BCInGameEvent;
   import codo.localization.DictDmz;
   import codo.utils.LocalizeUtil;
   import codo.utils.PauseUtil;
   import codo.views.hudDMZLoadout.HudDMZLoadoutPanel;
   import flash.text.TextField;
   import fsg.shared.CheckBox;
   
   public class PauseMenuDMZView extends FsgPauseMenuBaseView
   {
      
      public var myPauseTitle:TextField;
      
      public var myLoadout:HudDMZLoadoutPanel;
      
      public var myAutoPickupChk:CheckBox;
      
      private var mAutoPickupOld:Boolean;
      
      public function PauseMenuDMZView()
      {
         super();
         myFrame.visible = false;
         myTitle.visible = false;
         if(Boolean(CFunctionInGameContainer.AS_DMZ_IsBuddyMode()))
         {
            this.myAutoPickupChk.setText(DictDmz.AUTO_PICKUP_DUO);
         }
         else
         {
            this.myAutoPickupChk.setText(DictDmz.AUTO_PICKUP_SOLO);
         }
         if(!CFunctionCommonContainer.Dvar_GetBool("ui_enableDMZAutoPickup"))
         {
            this.myAutoPickupChk.visible = false;
         }
      }
      
      override protected function showView() : void
      {
         super.showView();
         this.myLoadout.onShow();
         PauseUtil.hidePauseMap(true);
         var matchStatus:Object = CFunctionInGameContainer.GetMatchStatus();
         if(matchStatus != null)
         {
            this.myPauseTitle.text = LocalizeUtil.localize(matchStatus.map);
         }
         this.mAutoPickupOld = CFunctionInGameContainer.AS_DMZ_IsAutoPickupEnabled() as Boolean;
         this.myAutoPickupChk.checked = this.mAutoPickupOld;
         myOptions.gotoAndStop(2);
      }
      
      override protected function hideView() : void
      {
         super.hideView();
         broadcast(BCEvent.EVT_COMPLAINT_CANCEL);
         this.myLoadout.onHide();
      }
      
      override protected function backToGame() : void
      {
         if(this.mAutoPickupOld != this.myAutoPickupChk.checked)
         {
            CFunctionInGameContainer.AS_DMZ_EnableAutoPickup(this.myAutoPickupChk.checked);
         }
         broadcast(BCInGameEvent.BACK_TO_GAME);
      }
   }
}

