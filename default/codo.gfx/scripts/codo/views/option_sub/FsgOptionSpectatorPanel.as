package codo.views.option_sub
{
   import codo.component.Button;
   import codo.constants.BCEvent;
   import codo.constants.DataID;
   import codo.event.ParaEvent;
   import codo.localization.Dict;
   import codo.localization.DictSetting;
   import codo.utils.ScaleformUtil;
   import flash.text.TextField;
   import fsg.shared.CheckBox;
   
   public class FsgOptionSpectatorPanel extends FsgOptionPanel
   {
      
      public var quickPanel:CheckBox;
      
      public var thridPerson:CheckBox;
      
      public var playerList:CheckBox;
      
      public var ScorePanel:CheckBox;
      
      public var playerCard:CheckBox;
      
      public var HUD:CheckBox;
      
      public var shoutcastToolBar:CheckBox;
      
      public var minimap:CheckBox;
      
      public var killfeed:CheckBox;
      
      public var myDialogButton01:Button;
      
      public var myDialogButton02:Button;
      
      public var myDialogButton03:Button;
      
      public var myTitle:TextField;
      
      public function FsgOptionSpectatorPanel()
      {
         super();
      }
      
      override protected function onInit() : void
      {
         if(ScaleformUtil.isScaleform)
         {
            this.myTitle.text = Dict.SHOUTCAST_OPT_TITLE_DEFAULT;
         }
         this.myDialogButton01.label = DictSetting.DEFAULT_SETTING;
         this.myDialogButton02.label = DictSetting.APPLY_SETTING;
         this.myDialogButton03.label = DictSetting.CANCEL_SETTING;
         this.quickPanel.setText(Dict.SHOUTCAST_OPT_QUICKPANEL,null);
         this.thridPerson.setText(Dict.SHOUTCAST_OPT_NAME_THIRDPERSON,null);
         this.playerList.setText(Dict.SHOUTCAST_OPT_NAME_PLAYERLIST,null);
         this.ScorePanel.setText(Dict.SHOUTCAST_OPT_NAME_SCOREPANEL,null);
         this.playerCard.setText(Dict.SHOUTCAST_OPT_PLAYERCARD,null);
         this.HUD.setText(Dict.SHOUTCAST_OPT_NAME_HUD,null);
         this.shoutcastToolBar.setText(Dict.SHOUTCAST_OPT_NAME_TOOLBAR,null);
         this.minimap.setText(Dict.SHOUTCAST_OPT_NAME_MINIMAP,null);
         this.killfeed.setText(Dict.SHOUTCAST_OPT_NAME_SYSTEMMESSAGE,null);
      }
      
      override protected function onInitListener() : void
      {
         super.onInitListener();
         listen(BCEvent.EVT_REFRESH_SPECTATOR_VIEW,this.onRefreshSpectatorViewHandle);
      }
      
      override public function showView() : void
      {
         super.showView();
         this.myDialogButton01.registerClickEvent(this.onRevertSettings);
         this.myDialogButton02.registerClickEvent(this.onAcceptSettings);
         this.myDialogButton03.registerClickEvent(this.onCancelSettings);
         this.myDialogButton03.enabled = true;
         this.quickPanel.checked = getDP(DataID.SHOUTCAST_OPT_NAME_QUICKPANEL);
         this.thridPerson.checked = getDP(DataID.SHOUTCAST_OPT_NAME_THIRDPERSON);
         this.playerList.checked = getDP(DataID.SHOUTCAST_OPT_NAME_PLAYERLIST);
         this.ScorePanel.checked = getDP(DataID.SHOUTCAST_OPT_NAME_SCOREPANEL);
         this.playerCard.checked = getDP(DataID.SHOUTCAST_OPT_PLAYERCARD);
         this.HUD.checked = getDP(DataID.SHOUTCAST_OPT_NAME_HUD);
         this.shoutcastToolBar.checked = getDP(DataID.SHOUTCAST_OPT_NAME_TOOLBAR);
         this.minimap.checked = getDP(DataID.SHOUTCAST_OPT_NAME_MINIMAP);
         this.killfeed.checked = getDP(DataID.SHOUTCAST_OPT_NAME_SYSTEMMESSAGE);
      }
      
      override public function onAcceptSettings() : void
      {
         var settingsObj:Object = new Object();
         settingsObj["SHOUTCAST_OPT_QUICKPANEL"] = this.quickPanel.checked;
         settingsObj["SHOUTCAST_OPT_NAME_THIRDPERSON"] = this.thridPerson.checked;
         settingsObj["SHOUTCAST_OPT_NAME_PLAYERLIST"] = this.playerList.checked;
         settingsObj["SHOUTCAST_OPT_NAME_SCOREPANEL"] = this.ScorePanel.checked;
         settingsObj["SHOUTCAST_OPT_PLAYERCARD"] = this.playerCard.checked;
         settingsObj["SHOUTCAST_OPT_NAME_HUD"] = this.HUD.checked;
         settingsObj["SHOUTCAST_OPT_NAME_TOOLBAR"] = this.shoutcastToolBar.checked;
         settingsObj["SHOUTCAST_OPT_NAME_MINIMAP"] = this.minimap.checked;
         settingsObj["SHOUTCAST_OPT_NAME_SYSTEMMESSAGE"] = this.killfeed.checked;
         broadcast(BCEvent.EVT_SET_SPECTATOR,settingsObj);
         broadcast(BCEvent.EVT_CLOSE_OPTION);
      }
      
      override public function onRevertSettings() : void
      {
         broadcast(BCEvent.EVT_RESET_SPECTATOR);
      }
      
      override public function onCancelSettings() : void
      {
         this.myDialogButton03.enabled = false;
         broadcast(BCEvent.EVT_CLOSE_OPTION);
      }
      
      private function onRefreshSpectatorViewHandle(cEvt:ParaEvent) : void
      {
         if(visible == true)
         {
            this.showView();
         }
      }
   }
}

