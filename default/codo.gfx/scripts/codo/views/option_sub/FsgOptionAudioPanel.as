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
   import flash.utils.Dictionary;
   import fsg.shared.CheckBox;
   import fsg.shared.ComboBox;
   import fsg.shared.ConfigSlider;
   
   public class FsgOptionAudioPanel extends FsgOptionPanel
   {
      
      public var myVoice:ConfigSlider;
      
      public var myMusicVolume:ConfigSlider;
      
      public var myMasterVolume:ConfigSlider;
      
      public var myDevice:ComboBox;
      
      public var mySubtitle:CheckBox;
      
      public var myDialogButton01:Button;
      
      public var myDialogButton02:Button;
      
      public var myDialogButton03:Button;
      
      private var _volumeComponentBind:Dictionary = new Dictionary();
      
      public var myTitle:TextField;
      
      public function FsgOptionAudioPanel()
      {
         super();
      }
      
      override protected function onInit() : void
      {
         if(ScaleformUtil.isScaleform)
         {
            this.myTitle.text = Dict.OPTIONS_AUDIO_BASIC;
         }
         this.myDialogButton01.label = DictSetting.DEFAULT_SETTING;
         this.myDialogButton02.label = DictSetting.APPLY_SETTING;
         this.myDialogButton03.label = DictSetting.CANCEL_SETTING;
         this.myVoice.setText(DictSetting.SETTING_VOICE,null);
         this.myMusicVolume.setText(DictSetting.SETTING_VOLUME_MUSIC,null);
         this.myMasterVolume.setText(DictSetting.SETTING_VOLUME,null);
         this.myVoice.registerValueChangedEvent(this.onVoiceVolumeChanged);
         this.myMusicVolume.registerValueChangedEvent(this.onMusicVolumeChanged);
         this.myMasterVolume.registerValueChangedEvent(this.onMasterVolumeChanged);
         this.myDevice.label = DictSetting.SETTING_SOUND_DEVICE;
         this.mySubtitle.setText(DictSetting.SETTING_SUBTITLE,null);
         this._volumeComponentBind[this.myVoice] = {
            "dvar":"snd_voChannelsVolumeScale",
            "cb":this.myVoice,
            "volume":80
         };
         this._volumeComponentBind[this.myMusicVolume] = {
            "dvar":"snd_musicChannelsVolumeScale",
            "cb":this.myMusicVolume,
            "volume":80
         };
         this._volumeComponentBind[this.myMasterVolume] = {
            "dvar":"snd_volume",
            "cb":this.myMasterVolume,
            "volume":80
         };
      }
      
      override protected function onInitListener() : void
      {
         listen(BCEvent.EVT_REFRESH_AUDIO_VIEW,this.onRefreshAudioViewHandle);
      }
      
      override public function showView() : void
      {
         var len:int = 0;
         var i:uint = 0;
         super.showView();
         this.myDialogButton01.registerClickEvent(this.onRevertSettings);
         this.myDialogButton02.registerClickEvent(this.onAcceptSettings);
         this.myDialogButton03.registerClickEvent(this.onCancelSettings);
         this.myDialogButton03.enabled = true;
         this.myMasterVolume.initialise(getDP(DataID.GET_MASTER_VOLUME),0,100);
         this._volumeComponentBind[this.myMasterVolume].volume = this.myMasterVolume.getValue();
         this.myMusicVolume.initialise(getDP(DataID.GET_MUSIC_VOLUME),0,100);
         this._volumeComponentBind[this.myMusicVolume].volume = this.myMusicVolume.getValue();
         this.myVoice.initialise(getDP(DataID.GET_VOCHANNELS_VOLUME),0,100);
         this._volumeComponentBind[this.myVoice].volume = this.myVoice.getValue();
         var tempDeviceID:int = getDP(DataID.GET_CURRENT_OUTPUT_CONFIG);
         var deviceProvider:Array = getDP(DataID.GET_OUTPUT_CONFIGURATIONS) as Array;
         if(deviceProvider != null)
         {
            len = int(deviceProvider.length);
            this.myDevice.dataProvider = deviceProvider;
            for(i = 0; i < len; i++)
            {
               if(this.myDevice.dataProvider[i].id == tempDeviceID)
               {
                  this.myDevice.selectedIndex = i;
                  break;
               }
            }
         }
         this.mySubtitle.checked = getDP(DataID.GET_TOGGLE_SUBTITLE);
      }
      
      private function onVoiceVolumeChanged() : void
      {
         var value:Number = this.myVoice.getValue();
         this.changeVolume(this._volumeComponentBind[this.myVoice].dvar,value,value <= 0);
      }
      
      private function onMusicVolumeChanged() : void
      {
         var value:Number = this.myMusicVolume.getValue();
         this.changeVolume(this._volumeComponentBind[this.myMusicVolume].dvar,value,value <= 0);
      }
      
      private function onMasterVolumeChanged() : void
      {
         var value:Number = this.myMasterVolume.getValue();
         this.changeVolume(this._volumeComponentBind[this.myMasterVolume].dvar,value,value <= 0);
      }
      
      override public function onAcceptSettings() : void
      {
         this._volumeComponentBind[this.myMasterVolume].volume = this.myMasterVolume.getValue();
         this._volumeComponentBind[this.myMusicVolume].volume = this.myMusicVolume.getValue();
         this._volumeComponentBind[this.myVoice].volume = this.myVoice.getValue();
         broadcast(BCEvent.EVT_CHANGE_OUTPUT_CONFIG,this.myDevice.selectedValue.id);
         broadcast(BCEvent.EVT_TOGGLE_SUBTITLE,this.mySubtitle.checked);
         broadcast(BCEvent.EVT_CLOSE_OPTION);
      }
      
      override public function onRevertSettings() : void
      {
         broadcast(BCEvent.EVT_RESET_AUDIO);
      }
      
      override public function onCancelSettings() : void
      {
         var restoredMasterVolume:Number = Number(this._volumeComponentBind[this.myMasterVolume].volume);
         var restoredMusicVolume:Number = Number(this._volumeComponentBind[this.myMusicVolume].volume);
         var restoredVoiceVolume:Number = Number(this._volumeComponentBind[this.myVoice].volume);
         this.changeVolume(this._volumeComponentBind[this.myMasterVolume].dvar,restoredMasterVolume,restoredMasterVolume <= 0);
         this.changeVolume(this._volumeComponentBind[this.myMusicVolume].dvar,restoredMusicVolume,restoredMusicVolume <= 0);
         this.changeVolume(this._volumeComponentBind[this.myVoice].dvar,restoredVoiceVolume,restoredVoiceVolume <= 0);
         this.myDialogButton03.enabled = false;
         broadcast(BCEvent.EVT_CLOSE_OPTION);
      }
      
      private function onRefreshAudioViewHandle(cEvt:ParaEvent) : void
      {
         if(visible == true)
         {
            this.showView();
         }
      }
      
      private function changeVolume(dvar:String, volume:Number, mute:Boolean, fromMute:Boolean = false) : void
      {
         broadcast(BCEvent.EVT_SET_VOLUME,{
            "dvar":dvar,
            "volume":volume,
            "mute":mute,
            "fromMute":fromMute
         });
      }
   }
}

