package codo.views
{
   import codo.base.BaseView;
   import codo.constants.BCEvent;
   import codo.constants.DataID;
   import codo.constants.GameInfo;
   import codo.localization.DictClan;
   import codo.localization.DictInGame;
   import components.Input;
   import flash.display.MovieClip;
   import fsg.shared.BarDialogButton;
   import fsg.shared.BehaviourAnimatedClickable;
   import fsg.shared.BehaviourAudio;
   import fsg.shared.BehaviourClickable;
   
   public class FsgEditClanMottoView extends BaseView
   {
      
      private static const POS_X_ORIGIN:int = 410;
      
      private static const POS_Y_ORIGIN:int = 320;
      
      public var myAddNameTextField:Input;
      
      public var myCloseButton:MovieClip;
      
      public var myContinueItemBtn:BarDialogButton;
      
      public var myCancelBtn:BarDialogButton;
      
      public var myChangeTitle:MovieClip;
      
      public var myChangeTip:MovieClip;
      
      private var m_exitButtonClickable:BehaviourClickable;
      
      private var m_exitButtonAnimated:BehaviourAnimatedClickable;
      
      private var m_exitButtonAudio:BehaviourAudio;
      
      private var m_cancelButtonClickable:BehaviourClickable;
      
      private var m_cancelButtonAudio:BehaviourAudio;
      
      private var m_nextButtonClickable:BehaviourClickable;
      
      private var m_nextButtonAudio:BehaviourAudio;
      
      public function FsgEditClanMottoView()
      {
         super();
         this.m_exitButtonClickable = new BehaviourClickable(this.myCloseButton);
         this.m_exitButtonAnimated = new BehaviourAnimatedClickable(this.myCloseButton,this.m_exitButtonClickable,1,2,1);
         this.m_exitButtonAudio = new BehaviourAudio(this.m_exitButtonClickable,"ui_general_rollover","ui_general_back");
         this.m_cancelButtonClickable = new BehaviourClickable(this.myCancelBtn);
         this.m_cancelButtonAudio = new BehaviourAudio(this.m_cancelButtonClickable,"ui_general_rollover","ui_general_back");
         this.m_nextButtonClickable = new BehaviourClickable(this.myContinueItemBtn);
         this.m_nextButtonAudio = new BehaviourAudio(this.m_nextButtonClickable,"ui_general_rollover","ui_general_proceed");
      }
      
      override protected function onInit() : void
      {
         x = POS_X_ORIGIN;
         y = POS_Y_ORIGIN;
         super.onInit();
         this.m_exitButtonClickable.addClickCallback(this.onCancelClickHandle);
         this.myCancelBtn.setText(DictInGame.Cancel);
         this.myCancelBtn.registerClickEvent(this.onCancelClickHandle);
         this.myContinueItemBtn.setText(DictClan.EDIT_CLAN_MOTTO_CONFIRM);
         this.myContinueItemBtn.registerClickEvent(this.onAdvanceBtnClickHandle);
         this.myAddNameTextField.lengthLimit = GameInfo.MOTTO_MODO_LEN_MAX;
         this.myAddNameTextField.regExpLimit = /^[0-9a-zA-Z一-龥][0-9a-zA-Z_一-龥]{0,99}/;
         this.myAddNameTextField.restrict = "_0-9a-zA-Z一-龥";
         this.myAddNameTextField.addEventListener(Input.EVT_PRESS_ENTER,this.onAdvanceBtnClickHandle);
         this.myChangeTitle.myTextTF.text = DictClan.EDIT_CLAN_MOTTO_TITLE;
         this.myChangeTip.myTextTF.text = DictClan.EDIT_CLAN_MOTTO_SUBTITLE;
      }
      
      public function onAdvanceBtnClickHandle() : void
      {
         var tempIptText:String = this.myAddNameTextField.text;
         if(tempIptText != "")
         {
         }
      }
      
      public function onCancelClickHandle() : void
      {
         broadcast(BCEvent.EVT_EXIT_RENAME_LOADOUT);
      }
      
      override protected function showView() : void
      {
         super.showView();
         this.myAddNameTextField.text = getDP(DataID.CURRENT_CLAN_MOTTO);
         this.myAddNameTextField.enable = true;
         this.myAddNameTextField.focusIn();
      }
   }
}

