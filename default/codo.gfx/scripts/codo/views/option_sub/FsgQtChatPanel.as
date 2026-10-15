package codo.views.option_sub
{
   import codo.common.CFunctionContainer;
   import codo.component.Button;
   import codo.component.CheckBox;
   import codo.constants.BCCommonEvent;
   import codo.constants.BCEvent;
   import codo.event.ParaEvent;
   import codo.localization.Dict;
   import codo.localization.DictSetting;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import fsg.shared.BehaviourAnimatedClickable;
   import fsg.shared.BehaviourClickable;
   
   public class FsgQtChatPanel extends FsgOptionPanel
   {
      
      public var myDialogButton01:Button;
      
      public var myOpenQTSettingButton:MovieClip;
      
      public var myQTSettingMask:MovieClip;
      
      private var m_qtClickable:BehaviourClickable;
      
      private var m_qtAnimated:BehaviourAnimatedClickable;
      
      private var m_qtSettingShowing:Boolean = false;
      
      public var myTitle:TextField;
      
      public var myOption1:CheckBox;
      
      public var myOption2:CheckBox;
      
      public var myOption3:CheckBox;
      
      private var _selected:int = 0;
      
      public function FsgQtChatPanel()
      {
         super();
      }
      
      override protected function onInit() : void
      {
         this.myDialogButton01.label = DictSetting.CLOSE_SETTING;
         this.myOpenQTSettingButton.myQTTextTF.text = Dict.QT_OPT_PANEL;
         this.m_qtClickable = new BehaviourClickable(this.myOpenQTSettingButton.myHitArea);
         this.m_qtAnimated = new BehaviourAnimatedClickable(this.myOpenQTSettingButton,this.m_qtClickable,1,2,2);
         this.m_qtClickable.addClickCallback(this.onQtButtonClicked,"");
         this.myQTSettingMask.visible = false;
         this.myTitle.text = DictSetting.EXIT_POPUP;
         var checkData:Object = {};
         checkData.label = DictSetting.EXIT_POPUP_EVERYTIME;
         checkData.canUnselectClick = false;
         checkData.checkEvent = this.onCheckBoxChecked1;
         this.myOption1.setData(checkData);
         checkData.label = DictSetting.EXIT_POPUP_WEEKLY;
         checkData.checkEvent = this.onCheckBoxChecked2;
         this.myOption2.setData(checkData);
         checkData.label = DictSetting.EXIT_POPUP_MONTHLY;
         checkData.checkEvent = this.onCheckBoxChecked3;
         this.myOption3.setData(checkData);
         listen(BCEvent.QT_SETTING_STATE_CHANGED,this.onQtSettingStateChanged);
         listen(BCEvent.TRYOPEN_QUESTIONNAIRE,this.onQuitSummaryPopup);
      }
      
      override public function showView() : void
      {
         super.showView();
         this._selected = CFunctionContainer.GetExitPopupSelect();
         if(this._selected == 2)
         {
            this.myOption3.checked = true;
         }
         else if(this._selected == 1)
         {
            this.myOption2.checked = true;
         }
         else
         {
            this.myOption1.checked = true;
         }
         this.myDialogButton01.registerClickEvent(this.onAcceptSettings);
      }
      
      override public function hideView() : void
      {
         super.hideView();
         broadcast(BCCommonEvent.TRY_FORCE_CLOSE_GVOICE_SETTING);
      }
      
      override public function onAcceptSettings() : void
      {
         CFunctionContainer.SetExitPopupSelect(this._selected);
         broadcast(BCEvent.EVT_CLOSE_OPTION);
      }
      
      private function onQtButtonClicked() : void
      {
         broadcast(BCCommonEvent.TRY_TOGGLE_GVOICE_SETTING);
      }
      
      private function onQtSettingStateChanged(cEvt:ParaEvent) : void
      {
         var isShow:Boolean = false;
         isShow = cEvt.myPara as Boolean;
         this.myQTSettingMask.visible = isShow;
         this.m_qtSettingShowing = isShow;
      }
      
      private function onQuitSummaryPopup(cEvt:ParaEvent) : void
      {
         broadcast(BCCommonEvent.TRY_FORCE_CLOSE_GVOICE_SETTING);
      }
      
      private function onCheckBoxChecked1() : void
      {
         this._selected = 0;
         this.myOption2.checked = false;
         this.myOption3.checked = false;
      }
      
      private function onCheckBoxChecked2() : void
      {
         this._selected = 1;
         this.myOption1.checked = false;
         this.myOption3.checked = false;
      }
      
      private function onCheckBoxChecked3() : void
      {
         this._selected = 2;
         this.myOption1.checked = false;
         this.myOption2.checked = false;
      }
   }
}

