package codo.views
{
   import codo.base.BaseView;
   import codo.constants.BCCommonEvent;
   import components.gvoice.GVoiceSettingsPanel;
   import flash.display.MovieClip;
   import flash.events.KeyboardEvent;
   import flash.ui.Keyboard;
   
   public class GVoiceSettingsView extends BaseView
   {
      
      public var myPanel:GVoiceSettingsPanel;
      
      public var myBg:MovieClip;
      
      public function GVoiceSettingsView()
      {
         super();
      }
      
      override protected function showView() : void
      {
         this.myPanel.show();
         this.myBg.visible = true;
      }
      
      override protected function hideView() : void
      {
         this.myPanel.hide();
         this.myBg.visible = false;
      }
      
      override public function onKeyboardEvent(cEvt:KeyboardEvent) : void
      {
         if(cEvt.keyCode == Keyboard.ESCAPE)
         {
            broadcast(BCCommonEvent.TRY_TOGGLE_GVOICE_SETTING);
         }
      }
   }
}

