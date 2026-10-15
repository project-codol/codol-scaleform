package codo.views
{
   import codo.base.BaseView;
   import codo.constants.BCCommonEvent;
   import codo.constants.DataID;
   import codo.localization.DictSetting;
   import codo.utils.Logger;
   import codo.views.option_sub.FsgOptionPanel;
   import codo.views.option_sub.FsgQtChatPanel;
   import flash.display.MovieClip;
   import flash.events.Event;
   import fsg.shared.TabBarDynamic;
   import fsg.shared.TabBase;
   import fsg.widgets.tabGeneric;
   
   public class FsgOptionsView extends BaseView
   {
      
      private static var TAB_VIDEO:uint = 0;
      
      private static var TAB_AUDIO:uint = 1;
      
      private static var TAB_CONTROLS:uint = 2;
      
      private static var POS_X_ORIGIN:int = 532;
      
      private static var POS_Y_ORIGIN:int = 270;
      
      private static const TAB_NAMES:Vector.<String> = new <String>[DictSetting.OPTION_TAB_VIDEO,DictSetting.OPTION_TAB_AUDIO,DictSetting.OPTION_TAB_CONTROL,DictSetting.OTHER_SETTINGS,DictSetting.OPTION_SPECTATOR];
      
      public var myTabBar:TabBarDynamic;
      
      public var myMovieClip:MovieClip;
      
      private var _videoTabEnabled:Boolean;
      
      private var _numTabs:int;
      
      public function FsgOptionsView()
      {
         super();
      }
      
      override protected function onInit() : void
      {
         this._videoTabEnabled = !this.getDP(DataID.IS_IN_ROOM) && !this.getDP(DataID.IS_IN_RANKED_MATCH) && !this.getDP(DataID.IS_IN_PARTY);
         this.createTabs();
         x = POS_X_ORIGIN;
         y = POS_Y_ORIGIN;
      }
      
      override protected function showView() : void
      {
         var panel:FsgOptionPanel = null;
         super.showView();
         Logger.print("===OPTION::is in room:" + this.getDP(DataID.IS_IN_ROOM),"|| is in ranked match:" + this.getDP(DataID.IS_IN_RANKED_MATCH),"||   is in party:" + this.getDP(DataID.IS_IN_PARTY));
         this._videoTabEnabled = !this.getDP(DataID.IS_IN_ROOM) && !this.getDP(DataID.IS_IN_RANKED_MATCH) && !this.getDP(DataID.IS_IN_PARTY);
         if(this._videoTabEnabled)
         {
            this.myTabBar.selectedTabIndex = TAB_VIDEO;
         }
         else
         {
            this.myTabBar.selectedTabIndex = TAB_AUDIO;
         }
         var len:int = int(this.myTabBar.numTabs);
         for(var i:int = 0; i < len; i++)
         {
            panel = this.myMovieClip["myOptionsPanel_" + i] as FsgOptionPanel;
            panel.showView();
         }
         if(this.hasEventListener(Event.ENTER_FRAME))
         {
            this.removeEventListener(Event.ENTER_FRAME,this.onShowViewComplete);
            this.removeEventListener(Event.ENTER_FRAME,this.onHideViewComplete);
            this.gotoAndStop(1);
         }
         if(this.currentFrame == 1)
         {
            this.addEventListener(Event.ENTER_FRAME,this.onShowViewComplete,false,0,true);
            this.gotoAndPlay(2);
         }
      }
      
      private function onShowViewComplete(evt:Event) : void
      {
         if(evt.currentTarget.currentFrame == 14)
         {
            this.removeEventListener(Event.ENTER_FRAME,this.onShowViewComplete);
         }
      }
      
      override protected function hideView() : void
      {
         var panel:FsgOptionPanel = null;
         var len:int = int(this.myTabBar.numTabs);
         for(var i:uint = 0; i < len; i++)
         {
            panel = this.myMovieClip["myOptionsPanel_" + i] as FsgOptionPanel;
            panel.hideView();
         }
         if(this.visible != false)
         {
            if(this.hasEventListener(Event.ENTER_FRAME))
            {
               this.removeEventListener(Event.ENTER_FRAME,this.onShowViewComplete);
               this.removeEventListener(Event.ENTER_FRAME,this.onHideViewComplete);
            }
            this.gotoAndPlay("close");
            this.addEventListener(Event.ENTER_FRAME,this.onHideViewComplete,false,0,true);
         }
      }
      
      private function onHideViewComplete(evt:Event) : void
      {
         if(evt.currentTarget.currentFrame == 1)
         {
            this.removeEventListener(Event.ENTER_FRAME,this.onHideViewComplete);
            super.hideView();
         }
      }
      
      private function createTabs() : void
      {
         var panel:FsgOptionPanel = null;
         var tab:TabBase = null;
         this.myTabBar.clearTabs();
         this.myTabBar.tabClass = tabGeneric;
         this.myTabBar.tabStatesChangedCallback = this.onTabIndexChanged;
         var len:int = int(TAB_NAMES.length);
         for(var i:uint = 0; i < len; i++)
         {
            tab = this.myTabBar.addTab(TAB_NAMES[i]);
            tab.audio.overrideMouseOverAudio("ui_primaryselect_rollover");
            tab.audio.overrideClickAudio("ui_primaryselect_proceed");
            panel = this.myMovieClip["myOptionsPanel_" + i] as FsgOptionPanel;
            panel.visible = false;
         }
         this.myTabBar.initialTabIndex = this._videoTabEnabled ? TAB_VIDEO : TAB_AUDIO;
         this.myTabBar.setup();
      }
      
      private function onTabIndexChanged() : void
      {
         this.gotoTabPage(this.myTabBar.selectedTabIndex);
      }
      
      private function gotoTabPage(index:int) : void
      {
         var panel:FsgOptionPanel = null;
         var activeTab:Boolean = false;
         if(index == TAB_VIDEO)
         {
            if(!this._videoTabEnabled)
            {
               this.showMsg(DictSetting.NOTE_VIDEO_LOCKED,1);
               this.myTabBar.selectedTabIndex = TAB_AUDIO;
               return;
            }
         }
         var len:int = int(TAB_NAMES.length);
         for(var i:uint = 0; i < len; i++)
         {
            panel = this.myMovieClip["myOptionsPanel_" + i] as FsgOptionPanel;
            activeTab = i == index;
            if(activeTab)
            {
               panel.active();
               if(panel is FsgQtChatPanel)
               {
                  broadcast(BCCommonEvent.TRY_TOGGLE_GVOICE_SETTING);
               }
            }
            else
            {
               panel.deactive();
            }
         }
      }
      
      private function onCancelBtnClick() : void
      {
         var myPanel:FsgOptionPanel = this.myMovieClip["myOptionsPanel_" + this.myTabBar.selectedTabIndex] as FsgOptionPanel;
         myPanel.onCancelSettings();
      }
   }
}

