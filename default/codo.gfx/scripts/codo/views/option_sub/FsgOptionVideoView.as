package codo.views.option_sub
{
   import codo.component.Button;
   import codo.constants.BCEvent;
   import codo.constants.DataID;
   import codo.event.ParaEvent;
   import codo.localization.Dict;
   import codo.localization.DictSetting;
   import codo.objects.VideoObj;
   import codo.utils.ScaleformUtil;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import fsg.shared.TabBarDynamic;
   import view_fsg_options.fsgSubTabButton;
   
   public class FsgOptionVideoView extends FsgOptionPanel
   {
      
      public var myDialogButton01:Button;
      
      public var myDialogButton02:Button;
      
      public var myDialogButton03:Button;
      
      public var mySubTabBar:TabBarDynamic;
      
      private var TAB_LABELS:Vector.<String> = new <String>["Basic","Advanced"];
      
      private var TAB_NAMES:Vector.<String> = new <String>[DictSetting.VIDEO_TAB_BASIC,DictSetting.VIDEO_TAB_ADVANCED];
      
      private var myTabContent:Array = [];
      
      private var currentTabIndex:int = 0;
      
      private var _preVideoObj:VideoObj = null;
      
      private var _curVideoObj:VideoObj = null;
      
      public var myTitle:TextField;
      
      private const TITLE_NAMES:Vector.<String> = new <String>[Dict.OPTIONS_VIDEO_BASIC,Dict.OPTIONS_VIDEO_ADVANCED];
      
      public function FsgOptionVideoView()
      {
         super();
      }
      
      override protected function onInit() : void
      {
         this.myDialogButton01.label = DictSetting.RECOMMENDED_SETTING;
         this.myDialogButton02.label = DictSetting.APPLY_SETTING;
         this.myDialogButton03.label = DictSetting.CANCEL_SETTING;
         this.createTabs(this.TAB_LABELS);
         this.gotoTabPage(0);
      }
      
      override protected function onInitListener() : void
      {
         this.listen(BCEvent.EVT_VIDEOCHANGE_CONFIRMED,this.onVideoChangeConfirmed);
         this.listen(BCEvent.EVT_VIDEOCHANGE_CANCELLED,this.onVideoChangeCancelled);
         this.listen(BCEvent.EVT_ENABLE_VIDEO_RESTART,this.onVideoRestartEnabled);
      }
      
      override public function showView() : void
      {
         var tabName:String = null;
         super.showView();
         for(var i:int = 0; i < this.TAB_LABELS.length; i++)
         {
            tabName = "my" + this.TAB_LABELS[i] + "Options";
            this[tabName].showView();
         }
         this.videoSettings = this.getDP(DataID.VIDEO_SETTING);
         this.myDialogButton01.registerClickEvent(this.onRevertSettings);
         this.myDialogButton02.registerClickEvent(this.onAcceptSettings);
         this.myDialogButton03.registerClickEvent(this.onCancelSettings);
         this.myDialogButton03.enabled = true;
         if(ScaleformUtil.isScaleform)
         {
            this.onTabClicked();
         }
         this.broadcast(BCEvent.EVT_VIDEO_OPTIONS_OPEN,{"open":true});
      }
      
      override public function hideView() : void
      {
         var tabName:String = null;
         super.hideView();
         for(var i:int = 0; i < this.TAB_LABELS.length; i++)
         {
            tabName = "my" + this.TAB_LABELS[i] + "Options";
            this[tabName].hideView();
         }
         this._preVideoObj = null;
         this._curVideoObj = null;
         this.broadcast(BCEvent.EVT_VIDEO_OPTIONS_OPEN,{"open":false});
      }
      
      public function set videoSettings(settings:Object) : void
      {
         var vidOptionPanel:FsgOptionVideoBase = null;
         this._preVideoObj = new VideoObj(settings);
         for(var i:uint = 0; i < this.myTabContent.length; i++)
         {
            vidOptionPanel = this.myTabContent[i] as FsgOptionVideoBase;
            if(vidOptionPanel != null)
            {
               vidOptionPanel.RefreshSettings(this._preVideoObj);
            }
         }
         this._curVideoObj = new VideoObj(settings);
      }
      
      private function onTabClicked() : void
      {
         var index:int = int(this.mySubTabBar.selectedTabIndex);
         this.gotoTabPage(index);
         this.myTitle.text = this.TITLE_NAMES[index];
      }
      
      private function gotoTabPage(index:int) : void
      {
         var tabPanel:MovieClip = null;
         this.currentTabIndex = index;
         for(var i:uint = 0; i < this.myTabContent.length; i++)
         {
            tabPanel = this.myTabContent[i] as MovieClip;
            if(i == index)
            {
               tabPanel.visible = true;
               tabPanel.active();
            }
            else
            {
               tabPanel.visible = false;
               tabPanel.deactive();
            }
         }
      }
      
      private function createTabs(tabLabels:Vector.<String>) : void
      {
         var tabName:String = null;
         var len:uint = tabLabels.length;
         this.mySubTabBar.clearTabs();
         this.mySubTabBar.tabClass = fsgSubTabButton;
         if(ScaleformUtil.isScaleform)
         {
            this.mySubTabBar.tabStatesChangedCallback = this.onTabClicked;
         }
         for(var i:uint = 0; i < len; i++)
         {
            this.mySubTabBar.addTab(this.TAB_NAMES[i]);
            tabName = "my" + tabLabels[i] + "Options";
            this.myTabContent.push(this[tabName]);
         }
         this.mySubTabBar.setup();
      }
      
      override public function onAcceptSettings() : void
      {
         var i:uint = 0;
         var vidOptionPanel:FsgOptionVideoBase = null;
         if(this.getDP(DataID.VITAL_COMMANDS_BOUNDED) == true)
         {
            for(i = 0; i < this.myTabContent.length; i++)
            {
               vidOptionPanel = this.myTabContent[i] as FsgOptionVideoBase;
               if(vidOptionPanel != null)
               {
                  vidOptionPanel.ApplySettings(this._curVideoObj,i == this.currentTabIndex);
               }
            }
            this.broadcast(BCEvent.EVT_OPTION_VIDEO_APPLY,{
               "cur":this._curVideoObj,
               "pre":this._preVideoObj,
               "closeWhenDone":true
            });
         }
      }
      
      override public function onRevertSettings() : void
      {
         if(this.getDP(DataID.VITAL_COMMANDS_BOUNDED) == true)
         {
            this.broadcast(BCEvent.DEFAULT_VIDEO);
         }
      }
      
      override public function onCancelSettings() : void
      {
         super.onCancelSettings();
         this.broadcast(BCEvent.EVT_CLOSE_OPTION);
      }
      
      private function copySettings(destination:VideoObj, source:VideoObj) : void
      {
         destination.ui_r_displayMode = source.ui_r_displayMode;
         destination.ui_r_customMode = source.ui_r_customMode;
         destination.ui_r_graphicsQuality = source.ui_r_graphicsQuality;
         destination.ui_r_aspectRatio = source.ui_r_aspectRatio;
         destination.ui_r_aaSamples = source.ui_r_aaSamples;
         destination.ui_r_renderResolutionIndex = source.ui_r_renderResolutionIndex;
         destination.ui_r_fpsLimit = source.ui_r_fpsLimit;
         destination.ui_r_displayRefresh = source.ui_r_displayRefresh;
         destination.ui_r_vsync = source.ui_r_vsync;
         destination.ui_sm_enable = source.ui_sm_enable;
         destination.ui_r_specular = source.ui_r_specular;
         destination.ui_r_dof_enable = source.ui_r_dof_enable;
         destination.ui_r_zFeather = source.ui_r_zFeather;
         destination.ui_ragdoll_enable = source.ui_ragdoll_enable;
         destination.ui_fx_marks = source.ui_fx_marks;
         destination.ui_r_picmip_manual = source.ui_r_picmip_manual;
         destination.ui_r_picmip = source.ui_r_picmip;
         destination.ui_r_picmip_bump = source.ui_r_picmip_bump;
         destination.ui_r_picmip_spec = source.ui_r_picmip_spec;
         destination.ui_r_ssao = source.ui_r_ssao;
         destination.ui_r_dlightlimit = source.ui_r_dlightlimit;
         destination.ui_r_glow_allowed = source.ui_r_glow_allowed;
         destination.ui_r_distortion = source.ui_r_distortion;
      }
      
      private function onVideoChangeConfirmed(cEvt:ParaEvent) : void
      {
         var tabPanel:FsgOptionVideoBase = null;
         this.copySettings(this._preVideoObj,this._curVideoObj);
         for(var i:uint = 0; i < this.myTabContent.length; i++)
         {
            tabPanel = this.myTabContent[i] as FsgOptionVideoBase;
            tabPanel.RefreshSettings(this._curVideoObj);
         }
         if(Boolean(cEvt.myPara.closeWhenDone))
         {
            this.broadcast(BCEvent.EVT_CLOSE_OPTION);
         }
      }
      
      private function onVideoChangeCancelled(cEvt:ParaEvent) : void
      {
         var tabPanel:FsgOptionVideoBase = null;
         this.copySettings(this._curVideoObj,this._preVideoObj);
         for(var i:uint = 0; i < this.myTabContent.length; i++)
         {
            tabPanel = this.myTabContent[i] as FsgOptionVideoBase;
            tabPanel.RefreshSettings(this._curVideoObj);
         }
      }
      
      private function onVideoRestartEnabled(cEvt:ParaEvent) : void
      {
         var enable:Boolean = false;
         enable = Boolean(cEvt.myPara.canRestartVideo);
         if(this.myDialogButton01.enabled != enable)
         {
            this.myDialogButton01.enabled = enable;
            this.myDialogButton02.enabled = enable;
            this.mySubTabBar.setTabEnabled(0,enable);
            this.mySubTabBar.setTabEnabled(1,enable);
         }
      }
   }
}

