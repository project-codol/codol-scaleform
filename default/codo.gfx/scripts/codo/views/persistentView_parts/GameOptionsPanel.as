package codo.views.persistentView_parts
{
   import codo.base.BaseSubElement;
   import codo.constants.BCEvent;
   import codo.constants.ButtonTLog;
   import codo.utils.TLogUtil;
   import flash.geom.ColorTransform;
   
   public class GameOptionsPanel extends BaseSubElement
   {
      
      public var myQuitBtn:GameOptionBtn;
      
      public var myOptionBtn:GameOptionBtn;
      
      public var myResultsBtn:GameOptionBtn;
      
      public function GameOptionsPanel()
      {
         super();
         this.myQuitBtn.addClickCallback(this.onQuit,"ui_exitgame_button_click_01");
         this.myOptionBtn.addClickCallback(this.onDisplayOptions,"ui_settingsgear_button_click_01");
         this.myResultsBtn.addClickCallback(this.onSummaryOptions);
      }
      
      public function set resultBtnVisible(cSwi:Boolean) : void
      {
         this.myResultsBtn.visible = cSwi;
      }
      
      public function setButtonColor(col:uint) : void
      {
         var colTrans:ColorTransform = new ColorTransform();
         colTrans.color = col;
         this.myQuitBtn.transform.colorTransform = colTrans;
         this.myOptionBtn.transform.colorTransform = colTrans;
         this.myResultsBtn.transform.colorTransform = colTrans;
      }
      
      private function onQuit() : void
      {
         TLogUtil.TLog_UserInput(ButtonTLog.BUTTON_EXIT_GAME);
         this.broadcast(BCEvent.TRYOPEN_QUESTIONNAIRE);
      }
      
      private function onDisplayOptions() : void
      {
         TLogUtil.TLog_UserInput(ButtonTLog.BUTTON_SETTINGS);
         this.broadcast(BCEvent.EVT_GOTO_OPTION);
      }
      
      private function onSummaryOptions() : void
      {
         this.broadcast(BCEvent.EVT_LOBBY_SUMMARY);
      }
   }
}

