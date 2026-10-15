package components.gvoice
{
   import codo.common.CFunctionCommonContainer;
   import codo.component.CloseButton;
   import codo.constants.BCCommonEvent;
   import codo.constants.DataCommonID;
   import codo.constants.GameInfo;
   import codo.event.ParaEvent;
   import codo.localization.Dict;
   import codo.manager.DataManager;
   import codo.manager.EventManager;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class GVoiceSettingsPanel extends MovieClip
   {
      
      public var myCloseButton:CloseButton;
      
      public var myTitle:TextField;
      
      public var mySpeakerKeyTitle:TextField;
      
      public var mySpeakerSwitchTitle:TextField;
      
      public var myRoomMembers:GVoiceSettingsRoomMemberList;
      
      public var mySpeakerVolumeSlider:GVoiceOptionSliderBar;
      
      public var myMicrophoneVolumeSlider:GVoiceOptionSliderBar;
      
      public var mySpeakerKey:TextField;
      
      public var mySpeakerSwitchKey:TextField;
      
      public function GVoiceSettingsPanel()
      {
         super();
         this.myTitle.text = Dict.GVOICE_BAN_HINT;
         this.mySpeakerKeyTitle.text = Dict.GVOICE_TALK_KEY;
         this.mySpeakerSwitchTitle.text = Dict.GVOICE_SWITCH;
         this.mySpeakerKey.text = "V";
         this.mySpeakerSwitchKey.text = "Alt + V";
         this.myCloseButton.setClickCallback(this.onClosePanel);
         this.mySpeakerVolumeSlider.setProgressChangedCallback(this.onSpeakerVolumeChanged);
         this.myMicrophoneVolumeSlider.setProgressChangedCallback(this.onMicrophoneVolumeChanged);
         this.setSpeakerVolume(CFunctionCommonContainer.AS_GVoice_GetSpeakerVolume());
         this.setMicrophoneVolume(CFunctionCommonContainer.AS_GVoice_GetMicrophoneVolume());
      }
      
      public function show() : void
      {
         x = GameInfo.stagePosition.x + (GameInfo.stageSize.x - width) / 2;
         y = GameInfo.stagePosition.y + (GameInfo.stageSize.y - height) / 2;
         visible = true;
         this.mySpeakerVolumeSlider.registerMouseEvents();
         this.myMicrophoneVolumeSlider.registerMouseEvents();
         EventManager.getInstance().listen(BCCommonEvent.EVT_GVOICE_REFRESH_MEMBERS,this.onUpdateMembers);
         this.onUpdateMembers(null);
      }
      
      public function hide() : void
      {
         visible = false;
         this.mySpeakerVolumeSlider.unregisterMouseEvents();
         this.myMicrophoneVolumeSlider.unregisterMouseEvents();
         EventManager.getInstance().unlisten(BCCommonEvent.EVT_GVOICE_REFRESH_MEMBERS,this.onUpdateMembers);
      }
      
      public function setSpeakerVolume(volume:int) : void
      {
         this.mySpeakerVolumeSlider.progress = volume / 100;
      }
      
      public function setMicrophoneVolume(volume:int) : void
      {
         this.myMicrophoneVolumeSlider.progress = volume / 100;
      }
      
      private function onClosePanel() : void
      {
         EventManager.getInstance().broadcast(BCCommonEvent.TRY_TOGGLE_GVOICE_SETTING);
      }
      
      private function onUpdateMembers(cEvt:ParaEvent) : void
      {
         var members:Array = DataManager.getInstance().getDP(DataCommonID.GVOICE_MEMBER_INFO);
         this.myRoomMembers.setData(members);
      }
      
      private function onSpeakerVolumeChanged(volume:Number) : void
      {
         CFunctionCommonContainer.AS_GVoice_SetSpeakerVolume(int(volume * 100));
      }
      
      private function onMicrophoneVolumeChanged(volume:Number) : void
      {
         CFunctionCommonContainer.AS_GVoice_SetMicrophoneVolume(int(volume * 100));
      }
   }
}

