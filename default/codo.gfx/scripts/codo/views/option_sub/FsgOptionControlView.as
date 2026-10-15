package codo.views.option_sub
{
   import codo.component.Button;
   import codo.constants.BCEvent;
   import codo.constants.Common;
   import codo.constants.DataID;
   import codo.localization.Dict;
   import codo.localization.DictSetting;
   import codo.utils.ScaleformUtil;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import fsg.component.FsgKeyboardPanel;
   import fsg.shared.TabBarDynamic;
   import view_fsg_options.fsgSubTabButton;
   
   public class FsgOptionControlView extends FsgOptionPanel
   {
      
      public var myDialogButton01:Button;
      
      public var myDialogButton02:Button;
      
      public var myDialogButton03:Button;
      
      public var myKeyboardOptions:FsgKeyboardPanel;
      
      public var mySubTabBar:TabBarDynamic;
      
      public var myTitle:TextField;
      
      private var TAB_LABELS:Vector.<String> = new <String>["Look","Keyboard","Movement","Actions","Chat"];
      
      private var TAB_NAMES:Vector.<String> = new <String>[DictSetting.CONTROL_TAB_LOOK,DictSetting.CONTROL_TAB_KEYBOARD_LAYOUT,DictSetting.CONTROL_TAB_MOVEMENT,DictSetting.CONTROL_TAB_ACTION,DictSetting.CONTROL_TAB_MISC];
      
      private var myTabContent:Array = [];
      
      private const TITLE_NAMES:Vector.<String> = new <String>[Dict.OPTIONS_MOUSE,Dict.OPTIONS_KEYBAORD_BASIC,Dict.OPTIONS_KEYBOARD_MOVEMENT,Dict.OPTIONS_KEYBOARD_ACTIONS,Dict.OPTIONS_KEYBAORD_MISC];
      
      public function FsgOptionControlView()
      {
         super();
      }
      
      override protected function onInit() : void
      {
         this.myDialogButton01.label = DictSetting.DEFAULT_SETTING;
         this.myDialogButton02.label = DictSetting.APPLY_SETTING;
         this.myDialogButton03.label = DictSetting.CANCEL_SETTING;
         this.createTabs(this.TAB_LABELS);
         this.gotoTabPage(0);
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
         this.myDialogButton01.registerClickEvent(this.onRevertSettings);
         this.myDialogButton02.registerClickEvent(this.onAcceptSettings);
         this.myDialogButton03.registerClickEvent(this.onCancelSettings);
         this.myDialogButton03.enabled = true;
         if(ScaleformUtil.isScaleform)
         {
            this.onTabClicked();
         }
         var keyboardType:uint = this.getDP(DataID.GET_KEYBOARD) != null ? uint(this.getDP(DataID.GET_KEYBOARD) as int) : uint(Common.KEYBOARD_CODO);
         this.myKeyboardOptions.setUserDefinedKeyboardType(keyboardType);
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
         var tabName:String = null;
         var len:uint = this.TAB_LABELS.length;
         this.broadcast(BCEvent.EVT_CLOSE_OPTION);
         for(var i:uint = 0; i < len; i++)
         {
            tabName = "my" + this.TAB_LABELS[i] + "Options";
            this[tabName].onAcceptSettings();
         }
         if(this.myKeyboardOptions.isDirty)
         {
            this.broadcast(BCEvent.CHOOSE_KEYBOARD,{"keyboard":this.myKeyboardOptions.keyboard});
         }
      }
      
      override public function onRevertSettings() : void
      {
         var tabName:String = null;
         this.broadcast(BCEvent.DEFAULT_CONTROL);
         for(var i:int = 0; i < this.TAB_LABELS.length; i++)
         {
            tabName = "my" + this.TAB_LABELS[i] + "Options";
            this[tabName].onRevertSettings();
         }
      }
      
      override public function onCancelSettings() : void
      {
         var tabName:String = null;
         super.onCancelSettings();
         this.myDialogButton03.enabled = false;
         for(var i:int = 0; i < this.TAB_LABELS.length; i++)
         {
            tabName = "my" + this.TAB_LABELS[i] + "Options";
            this[tabName].onCancelSettings();
         }
         this.broadcast(BCEvent.EVT_CLOSE_OPTION);
      }
   }
}

