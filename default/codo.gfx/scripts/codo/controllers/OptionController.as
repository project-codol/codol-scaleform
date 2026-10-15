package codo.controllers
{
   import codo.base.BaseController;
   import codo.common.CFunctionCommonContainer;
   import codo.common.CFunctionContainer;
   import codo.constants.BCEvent;
   import codo.constants.CODOVirtualKey;
   import codo.constants.CodoPageViewDB;
   import codo.constants.Common;
   import codo.constants.DataID;
   import codo.constants.MsgBtnCount;
   import codo.event.ParaEvent;
   import codo.localization.DictSetting;
   import codo.localization.DictSystem;
   import codo.objects.VideoObj;
   import codo.services.SettingsService;
   import codo.utils.LocalizeUtil;
   import codo.utils.Logger;
   import codo.utils.ScaleformUtil;
   import flash.events.TimerEvent;
   import flash.ui.Keyboard;
   import flash.utils.Timer;
   
   public class OptionController extends BaseController
   {
      
      private static var CONTROL_CMD_ALL:Array;
      
      private static var vital_commands_movement:Array = ["+forward","+back","+moveleft","+moveright","+gostand","+breath_sprint"];
      
      private static var vital_commands_toggle:Array = ["togglecrouch","toggleprone","+toggleads_throw"];
      
      private static var vital_commands_longpress:Array = ["+movedown","+prone","+speed_throw"];
      
      private static var vital_commands_action:Array = ["+attack","+reload","weapnext","weapprev","+melee","+activate","+frag","+smoke","+tact","weapalt","+actionslot 2","+actionslot 3","+actionslot 4","+actionslot 1","+scores"];
      
      private static var vital_commands_chat:Array = [];
      
      private static var CONTROL_CMD_LOOK:Array = ["+lookup","+lookdown","+mlook","centerview"];
      
      private static var CONTROL_CMD_ACTION:Array = ["+attack","+toggleads_throw","+reload","weapnext","weapprev","+melee","+activate","+frag","+smoke","+tact","weapalt","+actionslot 2","+actionslot 3","+actionslot 4","+actionslot 1","+scores","+switchscope"];
      
      private static var CONTROL_CMD_ACTION2:Array = ["+speed_throw"];
      
      private static var CONTROL_CMD_MOVEMENT:Array = ["+forward","+back","+moveleft","+moveright","+gostand","togglecrouch","toggleprone","+breath_sprint","+stance","+sprint","+holdbreath","+left","+right","+strafe"];
      
      private static var CONTROL_CMD_MOVEMENT2:Array = ["+movedown","+prone"];
      
      private static var CONTROL_CMD_CHAT:Array = ["chatmodeteam","toggletalk"];
      
      private static var CONTROL_CMD_CHAT2:Array = ["+talk"];
      
      private var _outputConfigurations:Array = null;
      
      private var _isMenuDvarsSetup:Boolean = false;
      
      private var _optionVideoApplyParams:Object;
      
      private var _needSndRestart:Boolean = false;
      
      private var keyNum:uint;
      
      private var cmd:String;
      
      private var unboundCommands:Array = [];
      
      public function OptionController()
      {
         super();
         CONTROL_CMD_ALL = CONTROL_CMD_LOOK.concat(CONTROL_CMD_ACTION);
         CONTROL_CMD_ALL = CONTROL_CMD_ALL.concat(CONTROL_CMD_ACTION2);
         CONTROL_CMD_ALL = CONTROL_CMD_ALL.concat(CONTROL_CMD_MOVEMENT);
         CONTROL_CMD_ALL = CONTROL_CMD_ALL.concat(CONTROL_CMD_MOVEMENT2);
         CONTROL_CMD_ALL = CONTROL_CMD_ALL.concat(CONTROL_CMD_CHAT);
         CONTROL_CMD_ALL = CONTROL_CMD_ALL.concat(CONTROL_CMD_CHAT2);
      }
      
      override protected function onInitialized() : void
      {
         this.addDP(DataID.GET_TOGGLE_SUBTITLE,this.getToggleSubtitle);
         this.addDP(DataID.GET_MASTER_VOLUME,this.getMasterVolume);
         this.addDP(DataID.GET_MUSIC_VOLUME,this.getMusicVolume);
         this.addDP(DataID.GET_VOCHANNELS_VOLUME,this.getVOChannelsVolume);
         this.addDP(DataID.GET_VOICE_CHAT_VOLUME,this.getVoiceChatVolume);
         this.addDP(DataID.GET_VOICE_MIC_VOLUME,this.getVoiceMicVolume);
         this.addDP(DataID.GET_CURRENT_OUTPUT_CONFIG,this.getCurrentOutputConfigurationID);
         this.addDP(DataID.GET_OUTPUT_CONFIGURATIONS,this.getOutputConfigurations);
         this.addDP(DataID.IS_VOICE_MIC_MUTE,this.isVoiceMicMute);
         this.addDP(DataID.GET_MOUSE_SENSITIVITY_X,this.getMouseSensitivityX);
         this.addDP(DataID.GET_MOUSE_SENSITIVITY_Y,this.getMouseSensitivityY);
         this.addDP(DataID.GET_MOUSE_INVERT,this.getMouseInvert);
         this.addDP(DataID.GET_MOUSE_SMOOTH,this.getMouseSmooth);
         this.addDP(DataID.GET_FREE_LOOK,this.getFreeLook);
         this.addDP(DataID.GET_KEYBOARD,this.getKeyboard);
         this.addDP(DataID.KEY_BINDING_COUNT_ON_COMMAND,this.getKeyBindingCountFromCommand);
         this.addDP(DataID.KEY_BINDING_NAMES_ON_COMMAND,this.getKeyBindingNamesFromCommand);
         this.addDP(DataID.MAPPING_KEY,this.getMappingKey);
         this.addDP(DataID.GAMMA_RANGE,this.getGammaRange);
         this.addDP(DataID.FOV_RANGE,this.getFOVRange);
         this.addDP(DataID.SENSITIVITY_RANGE,this.getSensitivityRange);
         this.addDP(DataID.VITAL_COMMANDS_BOUNDED,this.isVitalCommandsBounded);
         this.addDP(DataID.VIDEO_SETTING,this.retrieveVideoSettings);
         this.addDP(DataID.SHOUTCAST_OPT_NAME_QUICKPANEL,this.shoutcastOptionQuickPanel);
         this.addDP(DataID.SHOUTCAST_OPT_NAME_THIRDPERSON,this.shoutcastOptionThirdPerson);
         this.addDP(DataID.SHOUTCAST_OPT_NAME_PLAYERLIST,this.shoutcastOptionPlayerList);
         this.addDP(DataID.SHOUTCAST_OPT_NAME_SCOREPANEL,this.shoutcastOptionScorePanel);
         this.addDP(DataID.SHOUTCAST_OPT_PLAYERCARD,this.shoutcastOptionPlayerCard);
         this.addDP(DataID.SHOUTCAST_OPT_NAME_HUD,this.shoutcastOptionHUD);
         this.addDP(DataID.SHOUTCAST_OPT_NAME_TOOLBAR,this.shoutcastOptionToolBar);
         this.addDP(DataID.SHOUTCAST_OPT_NAME_MINIMAP,this.shoutcastOptionMiniMap);
         this.addDP(DataID.SHOUTCAST_OPT_NAME_SYSTEMMESSAGE,this.shoutcastOptionSystemMessage);
         this.listen(BCEvent.EVT_GOTO_OPTION,this.onGotoOptionHandle);
         this.listen(BCEvent.EVT_TOGGLE_SUBTITLE,this.onToggleSubtitleHandle);
         this.listen(BCEvent.EVT_SET_VOLUME,this.onSetVolumeHandle);
         this.listen(BCEvent.EVT_CHANGE_OUTPUT_CONFIG,this.onChangeOutputConfigHandle);
         this.listen(BCEvent.EVT_SET_SPECTATOR,this.onChangeSpectatorSettings);
         this.listen(BCEvent.EVT_SET_MOUSE_SENSITIVITY_X,this.onSetMouseSensitivityXHandle);
         this.listen(BCEvent.EVT_SET_MOUSE_SENSITIVITY_X,this.onSetMouseSensitivityYHandle);
         this.listen(BCEvent.EVT_SET_MOUSE_INVERT,this.onSetMouseInvertHandle);
         this.listen(BCEvent.EVT_SET_MOUSE_SMOOTH,this.onSetMouseSmoothHandle);
         this.listen(BCEvent.EVT_SET_FREE_LOOK,this.onSetFreeLookHandle);
         this.listen(BCEvent.ON_ROOM_JOINED,this.onVideoEnableChaged);
         this.listen(BCEvent.ON_ROOM_LEFT,this.onVideoEnableChaged);
         this.listen(BCEvent.RANKED_MATCH_STATUS_CHANGED,this.onVideoEnableChaged);
         this.listen(BCEvent.EVT_BIND_KEY_TO_HOLD_COMMAND,this.onBindKeyToHoldCommandHandle);
         this.listen(BCEvent.EVT_BIND_KEY_TO_COMMAND,this.onBindKeyToCommandHandle);
         this.listen(BCEvent.EVT_CLOSE_OPTION,this.onCloseOptionHandle);
         this.listen(BCEvent.EVT_RESET_AUDIO,this.onResetAudioHandle);
         this.listen(BCEvent.EVT_RESET_SPECTATOR,this.onResetSpectatorHandle);
         this.listen(BCEvent.EVT_PLAYER_STATS_READY,this.onPlayerStatsReadyHandle);
         this.listen(BCEvent.EVT_OPTION_VIDEO_APPLY,this.onOptionVideoApplyHandle);
         this.listen(BCEvent.DEFAULT_VIDEO,this.onSetDefaultVideo);
         this.listen(BCEvent.DEFAULT_CONTROL,this.onSetDefaultControl);
         this.listen(BCEvent.EVT_SET_BRIGHTNESS,this.onSetBrightnessHandle);
         this.listen(BCEvent.EVT_SET_FOV,this.onSetFovHandle);
         this.listen(BCEvent.CHOOSE_KEYBOARD,this.onChooseKeyboard);
      }
      
      private function getToggleSubtitle() : Boolean
      {
         return Boolean(CFunctionContainer.IsSubtitleToggled());
      }
      
      private function getMasterVolume() : Number
      {
         return CFunctionCommonContainer.Dvar_GetFloat("profileMenuOption_volume") * 100;
      }
      
      private function getMusicVolume() : Number
      {
         return CFunctionCommonContainer.Dvar_GetFloat("snd_musicChannelsVolumeScale") * 100;
      }
      
      private function getVOChannelsVolume() : Number
      {
         return CFunctionCommonContainer.Dvar_GetFloat("snd_voChannelsVolumeScale") * 100;
      }
      
      private function getVoiceChatVolume() : Number
      {
         return (CFunctionCommonContainer.Dvar_GetFloat("winvoice_mic_scaler") - 0.25) / (2 - 0.25) * 100;
      }
      
      private function getVoiceMicVolume() : Number
      {
         return CFunctionCommonContainer.Dvar_GetFloat("winvoice_mic_reclevel") / 65535 * 100;
      }
      
      private function getCurrentOutputConfigurationID() : int
      {
         return this.getDvarInt("snd_outputConfiguration");
      }
      
      private function getOutputConfigurations() : Array
      {
         if(this._outputConfigurations == null)
         {
            this._outputConfigurations = [];
            this._outputConfigurations.push({
               "label":DictSetting.OUTPUT_CONFIG_DEFAULT,
               "id":0
            });
            this._outputConfigurations.push({
               "label":DictSetting.OUTPUT_CONFIG_STEREO,
               "id":2
            });
            this._outputConfigurations.push({
               "label":DictSetting.OUTPUT_CONFIG_5_1_SPEAKERS,
               "id":4
            });
         }
         return this._outputConfigurations;
      }
      
      private function isVoiceMicMute() : Boolean
      {
         return this.getDvarBool("winvoice_mic_mute");
      }
      
      private function getGammaRange() : Object
      {
         return SettingsService.getInstance().gammaRange;
      }
      
      private function getFOVRange() : Object
      {
         return SettingsService.getInstance().FOVRange;
      }
      
      private function getSensitivityRange() : Object
      {
         return SettingsService.getInstance().sensitivityRange;
      }
      
      private function getMouseSensitivityX() : Number
      {
         return CFunctionCommonContainer.Dvar_GetFloat("cl_horizontal_sensitivity");
      }
      
      private function getMouseSensitivityY() : Number
      {
         return CFunctionCommonContainer.Dvar_GetFloat("cl_vertical_sensitivity");
      }
      
      private function getMouseInvert() : Number
      {
         return CFunctionCommonContainer.Dvar_GetFloat("m_pitch");
      }
      
      private function getMouseSmooth() : Boolean
      {
         return this.getDvarBool("m_filter");
      }
      
      private function getFreeLook() : Boolean
      {
         return this.getDvarBool("cl_freelook");
      }
      
      private function getKeyboard() : int
      {
         return this.keyboard;
      }
      
      private function getKeyBindingCountFromCommand(command:String) : uint
      {
         return CFunctionCommonContainer.GetKeyBindingCountFromCommand(command);
      }
      
      private function getKeyBindingNamesFromCommand(cmd:String) : String
      {
         var bind:String = null;
         var bindings:Array = CFunctionCommonContainer.GetKeyBindingNamesFromCommand(cmd);
         var name:String = "";
         for(var i:int = 0; i < bindings.length; i++)
         {
            bind = bindings[i];
            if(bind == "KEY_MOUSE1_ICON")
            {
               bindings[i] = "KEY_MOUSE1";
            }
            if(bind == "KEY_MOUSE2_ICON")
            {
               bindings[i] = "KEY_MOUSE2";
            }
            if(bind.indexOf("KEY_") >= 0)
            {
               bind = LocalizeUtil.localize("@" + bindings[i]);
            }
            name += bind;
            if(i == 0 && bindings.length > 1)
            {
               name += " ";
               name += LocalizeUtil.localize("@KEY_OR");
               name += " ";
            }
         }
         return name;
      }
      
      private function getMappingKey(keyNum:uint) : uint
      {
         keyNum = keyNum == CODOVirtualKey.K_KP_ENTER_SF ? uint(CODOVirtualKey.K_ENTER) : keyNum;
         return CFunctionCommonContainer.MapKey(keyNum);
      }
      
      private function onGotoOptionHandle(cEvt:ParaEvent) : void
      {
         this.gotoPage(CodoPageViewDB.PAGE_FSG_OPTIONS);
      }
      
      private function showOptionsPage() : void
      {
         this.gotoPage(CodoPageViewDB.PAGE_FSG_OPTIONS);
      }
      
      private function onToggleSubtitleHandle(cEvt:ParaEvent) : void
      {
         Logger.print("OptionController::onToggleSubtitleHandle cEvt.myPara: " + cEvt.myPara);
         CFunctionContainer.ToggleSubtitle(cEvt.myPara);
      }
      
      private function onSetVolumeHandle(cEvt:ParaEvent) : void
      {
         var volume:Number = Number(cEvt.myPara.volume);
         var dvar:String = cEvt.myPara.dvar;
         var mute:Boolean = Boolean(cEvt.myPara.mute);
         var fromMute:Boolean = Boolean(cEvt.myPara.fromMute);
         switch(dvar)
         {
            case "snd_volume":
               dvar = "";
               CFunctionCommonContainer.setdvar("profileMenuOption_volume",(volume / 100).toString());
               CFunctionCommonContainer.execnow("profile_menuDvarsFinish");
               break;
            case "snd_musicChannelsVolumeScale":
            case "snd_voChannelsVolumeScale":
               volume /= 100;
               break;
            case "winvoice_mic_scaler":
               volume = volume / 100 * (2 - 0.25) + 0.25;
               break;
            case "winvoice_mic_reclevel":
               volume = volume / 100 * 65535;
               if(fromMute)
               {
                  volume = 0;
                  CFunctionContainer.SetVoiceMicMute(mute);
               }
               else if(mute != this.isVoiceMicMute())
               {
                  CFunctionContainer.SetVoiceMicMute(mute);
               }
         }
         if(dvar != null && dvar.length > 0)
         {
            CFunctionCommonContainer.setdvar(dvar,volume.toString());
         }
      }
      
      private function setAudioOutput(id:int) : Boolean
      {
         var prevCfg:int = this.getCurrentOutputConfigurationID();
         if(prevCfg != id)
         {
            CFunctionCommonContainer.setdvar("snd_outputConfiguration",id.toString());
            return true;
         }
         return false;
      }
      
      private function onChangeOutputConfigHandle(cEvt:ParaEvent) : void
      {
         var newCfg:int = cEvt.myPara;
         this._needSndRestart = this.setAudioOutput(newCfg);
      }
      
      private function onChangeSpectatorSettings(cEvt:ParaEvent) : void
      {
         var settingsObj:Object = cEvt.myPara;
         CFunctionCommonContainer.setdvar("cl_shoutcastSettingsQuickPanel",Boolean(settingsObj["SHOUTCAST_OPT_QUICKPANEL"]) ? "1" : "0");
         CFunctionCommonContainer.setdvar("cl_shoutcastSettingsThirdPerson",Boolean(settingsObj["SHOUTCAST_OPT_NAME_THIRDPERSON"]) ? "1" : "0");
         CFunctionCommonContainer.setdvar("cl_shoutcastSettingsPlayerList",Boolean(settingsObj["SHOUTCAST_OPT_NAME_PLAYERLIST"]) ? "1" : "0");
         CFunctionCommonContainer.setdvar("cl_shoutcastSettingsScorePanel",Boolean(settingsObj["SHOUTCAST_OPT_NAME_SCOREPANEL"]) ? "1" : "0");
         CFunctionCommonContainer.setdvar("cl_shoutcastSettingsPlayerCard",Boolean(settingsObj["SHOUTCAST_OPT_PLAYERCARD"]) ? "1" : "0");
         CFunctionCommonContainer.setdvar("cl_shoutcastSettingsHUD",Boolean(settingsObj["SHOUTCAST_OPT_NAME_HUD"]) ? "1" : "0");
         CFunctionCommonContainer.setdvar("cl_shoutcastSettingsToolBar",Boolean(settingsObj["SHOUTCAST_OPT_NAME_TOOLBAR"]) ? "1" : "0");
         CFunctionCommonContainer.setdvar("cl_shoutcastSettingsMiniMap",Boolean(settingsObj["SHOUTCAST_OPT_NAME_MINIMAP"]) ? "1" : "0");
         CFunctionCommonContainer.setdvar("cl_shoutcastSettingsSystemMessage",Boolean(settingsObj["SHOUTCAST_OPT_NAME_SYSTEMMESSAGE"]) ? "1" : "0");
      }
      
      private function onOptionAudioRestartConfirm() : void
      {
         SettingsService.getInstance().restartAudio();
      }
      
      private function onOptionAudioRestartCancel() : void
      {
      }
      
      private function onSetMouseSensitivityXHandle(cEvt:ParaEvent) : void
      {
         if(cEvt.myPara != this.getMouseSensitivityX())
         {
            CFunctionCommonContainer.setdvar("cl_horizontal_sensitivity",cEvt.myPara.toString());
            CFunctionCommonContainer.As_markSettingChanged();
         }
      }
      
      private function onSetMouseSensitivityYHandle(cEvt:ParaEvent) : void
      {
         if(cEvt.myPara != this.getMouseSensitivityY())
         {
            CFunctionCommonContainer.setdvar("cl_vertical_sensitivity",cEvt.myPara.toString());
            CFunctionCommonContainer.As_markSettingChanged();
         }
      }
      
      private function onSetMouseInvertHandle(cEvt:ParaEvent) : void
      {
         CFunctionCommonContainer.setdvar("m_pitch",cEvt.myPara);
         CFunctionCommonContainer.As_markSettingChanged();
      }
      
      private function onSetMouseSmoothHandle(cEvt:ParaEvent) : void
      {
         CFunctionCommonContainer.setdvar("m_filter",cEvt.myPara);
         CFunctionCommonContainer.As_markSettingChanged();
      }
      
      private function onSetFreeLookHandle(cEvt:ParaEvent) : void
      {
         CFunctionCommonContainer.setdvar("cl_freelook",cEvt.myPara);
         CFunctionCommonContainer.As_markSettingChanged();
      }
      
      private function onBindKeyToHoldCommandHandle(cEvt:ParaEvent) : void
      {
         var i:uint = 0;
         var bind:Array = CFunctionCommonContainer.GetKeyBindingValuesFromCommand(cEvt.myPara.cmd0);
         if(bind.length > 0)
         {
            for(i = 0; i < bind.length; i++)
            {
               CFunctionCommonContainer.SetKeyBindingForCommand(bind[i],cEvt.myPara.cmd1);
            }
         }
      }
      
      private function onBindKeyToCommandHandle(cEvt:ParaEvent) : void
      {
         var keys:Array = null;
         var j:int = 0;
         this.keyNum = cEvt.myPara.key;
         this.cmd = cEvt.myPara.cmd;
         switch(this.keyNum)
         {
            case Keyboard.ESCAPE:
            case 98:
            case 167:
               return;
            case Keyboard.BACKSPACE:
            case 127:
               CFunctionCommonContainer.ClearKeyBindingForCommand(this.cmd);
               return;
            default:
               Logger.print("onBindKeyToCommandHandle:binding: " + this.keyNum + " to " + this.cmd);
               for(var i:int = 0; i < CONTROL_CMD_ALL.length; i++)
               {
                  keys = CFunctionCommonContainer.GetKeyBindingValuesFromCommand(CONTROL_CMD_ALL[i]);
                  j = 0;
                  while(j < keys.length)
                  {
                     if(this.keyNum == keys[j])
                     {
                        if(this.cmd != CONTROL_CMD_ALL[i])
                        {
                           this.showMsg(DictSetting.NOTE_KEYS_EXIST,MsgBtnCount.TWO,0,this.confirmBind);
                           return;
                        }
                        break;
                     }
                     j++;
                  }
               }
               this.confirmBind();
               return;
         }
      }
      
      private function confirmBind() : void
      {
         CFunctionCommonContainer.SetKeyBindingForCommand(this.keyNum,this.cmd);
         CFunctionCommonContainer.As_markSettingChanged();
         this.broadcast(BCEvent.EVT_BIND_KEY_FINISH);
      }
      
      private function onCloseOptionHandle(cEvt:ParaEvent) : void
      {
         if(this.isVitalCommandsBounded())
         {
            this.prevPage();
            CFunctionCommonContainer.execnow("updateGamerProfile");
            if(this._needSndRestart)
            {
               this._needSndRestart = false;
               this.showMsg(DictSetting.NOTE_RESTART_AUDIO,MsgBtnCount.TWO,0,this.onOptionAudioRestartConfirm,DictSetting.RESTART_NOW,this.onOptionAudioRestartCancel,DictSystem.CANCEL);
            }
         }
      }
      
      private function onResetAudioHandle(cEvt:ParaEvent) : void
      {
         this.showMsg(DictSetting.NOTE_RESTORE_AUDIO,MsgBtnCount.TWO,0,this.useDefaultAudio,DictSystem.CONFIRM,null,DictSystem.CANCEL);
      }
      
      private function onResetSpectatorHandle(cEvt:ParaEvent) : void
      {
         this.showMsg(DictSetting.NOTE_RESTORE_SPECTATOR,MsgBtnCount.TWO,0,this.userDefaultSpectator,DictSystem.CONFIRM,null,DictSystem.CANCEL);
      }
      
      private function onPlayerStatsReadyHandle(cEvt:ParaEvent) : void
      {
         if(!this._isMenuDvarsSetup)
         {
            this._isMenuDvarsSetup = true;
            CFunctionCommonContainer.execnow("profile_menuDvarsSetup");
         }
      }
      
      private function onVideoEnableChaged(cEvt:ParaEvent) : void
      {
         var enableVideo:Boolean = false;
         switch(cEvt.type)
         {
            case BCEvent.ON_ROOM_LEFT:
               enableVideo = true;
               break;
            case BCEvent.ON_ROOM_JOINED:
               enableVideo = false;
               break;
            case BCEvent.RANKED_MATCH_STATUS_CHANGED:
               enableVideo = !this.getDP(DataID.IS_IN_RANKED_MATCH);
         }
         this.broadcast(BCEvent.EVT_ENABLE_VIDEO,{"data":enableVideo});
      }
      
      private function onOptionVideoApplyHandle(cEvt:ParaEvent) : void
      {
         var warn:String = null;
         if(this.isVideoChanged(cEvt))
         {
            this._optionVideoApplyParams = cEvt.myPara;
            warn = Boolean(cEvt.myPara.pre.is_belowMinSpec) ? DictSetting.DO_YOU_WANT_SAVE_OPTION_BELOW_MSR : DictSetting.DO_YOU_WANT_SAVE_OPTION;
            this.showMsg(warn,MsgBtnCount.TWO,0,this.onOptionVideoApplyConfirm,DictSystem.CONFIRM,this.onOptionVideoApplyCancelled,DictSystem.CANCEL);
         }
         else if(Boolean(cEvt.myPara.closeWhenDone))
         {
            this.broadcast(BCEvent.EVT_CLOSE_OPTION);
         }
      }
      
      private function isVideoChanged(cEvt:ParaEvent) : Boolean
      {
         var settingsToCheck:Array = null;
         var i:int = 0;
         var preVideoObj:VideoObj = cEvt.myPara.pre as VideoObj;
         var curVideoObj:VideoObj = cEvt.myPara.cur as VideoObj;
         if(Boolean(CFunctionCommonContainer.IsDevelopmentBuild()))
         {
            Logger.print("--- OptionController::isVideoChanged() ---");
            settingsToCheck = ["ui_r_displayMode","ui_r_customMode","ui_r_graphicsQuality","ui_r_aspectRatio","ui_r_aaSamples","ui_r_fpsLimit","ui_r_displayRefresh","ui_r_vsync","ui_sm_enable","ui_r_specular","ui_r_dof_enable","ui_r_zFeather","ui_ragdoll_enable","ui_fx_marks","ui_r_picmip_manual","ui_r_picmip","ui_r_picmip_bump","ui_r_picmip_spec","ui_r_ssao","ui_r_dlightlimit","ui_r_glow_allowed","ui_r_distortion","ui_r_renderResolutionIndex"];
            for(i = 0; i < settingsToCheck.length; i++)
            {
               if(preVideoObj[settingsToCheck[i]] != curVideoObj[settingsToCheck[i]])
               {
                  Logger.print(settingsToCheck[i] + " changed from " + preVideoObj[settingsToCheck[i]] + " to " + curVideoObj[settingsToCheck[i]] + ".");
               }
            }
            Logger.print("------");
         }
         return preVideoObj.ui_r_displayMode != curVideoObj.ui_r_displayMode || preVideoObj.ui_r_customMode != curVideoObj.ui_r_customMode || preVideoObj.ui_r_graphicsQuality != curVideoObj.ui_r_graphicsQuality || preVideoObj.ui_r_aspectRatio != curVideoObj.ui_r_aspectRatio || preVideoObj.ui_r_aaSamples != curVideoObj.ui_r_aaSamples || preVideoObj.ui_r_fpsLimit != curVideoObj.ui_r_fpsLimit || preVideoObj.ui_r_displayRefresh != curVideoObj.ui_r_displayRefresh || preVideoObj.ui_r_vsync != curVideoObj.ui_r_vsync || preVideoObj.ui_sm_enable != curVideoObj.ui_sm_enable || preVideoObj.ui_r_specular != curVideoObj.ui_r_specular || preVideoObj.ui_r_dof_enable != curVideoObj.ui_r_dof_enable || preVideoObj.ui_r_zFeather != curVideoObj.ui_r_zFeather || preVideoObj.ui_ragdoll_enable != curVideoObj.ui_ragdoll_enable || preVideoObj.ui_fx_marks != curVideoObj.ui_fx_marks || preVideoObj.ui_r_picmip_manual != curVideoObj.ui_r_picmip_manual || preVideoObj.ui_r_picmip != curVideoObj.ui_r_picmip || preVideoObj.ui_r_picmip_bump != curVideoObj
         .ui_r_picmip_bump || preVideoObj.ui_r_picmip_spec != curVideoObj.ui_r_picmip_spec || preVideoObj.ui_r_ssao != curVideoObj.ui_r_ssao || preVideoObj.ui_r_dlightlimit != curVideoObj.ui_r_dlightlimit || preVideoObj.ui_r_glow_allowed != curVideoObj.ui_r_glow_allowed || preVideoObj.ui_r_distortion != curVideoObj.ui_r_distortion || preVideoObj.ui_r_renderResolutionIndex != curVideoObj.ui_r_renderResolutionIndex;
      }
      
      private function onOptionVideoApplyConfirm() : void
      {
         SettingsService.getInstance().applyVideoSetting({
            "cur":this._optionVideoApplyParams.cur,
            "pre":this._optionVideoApplyParams.pre
         });
         this.broadcast(BCEvent.EVT_VIDEOCHANGE_CONFIRMED,{"closeWhenDone":this._optionVideoApplyParams.closeWhenDone});
      }
      
      private function onOptionVideoApplyCancelled() : void
      {
         this.broadcast(BCEvent.EVT_VIDEOCHANGE_CANCELLED);
      }
      
      private function useDefaultAudio() : void
      {
         var defaultAudio:int = 0;
         this.hideMsg();
         CFunctionCommonContainer.setdvar("profileMenuOption_volume",String(0.8));
         CFunctionCommonContainer.execnow("profile_menuDvarsFinish");
         CFunctionCommonContainer.setdvar("snd_voChannelsVolumeScale",String(0.5));
         CFunctionCommonContainer.setdvar("snd_musicChannelsVolumeScale",String(0.5));
         CFunctionCommonContainer.setdvar("winvoice_mic_scaler",String(1));
         CFunctionCommonContainer.setdvar("winvoice_mic_reclevel",String(65535));
         CFunctionContainer.SetVoiceMicMute(false);
         CFunctionContainer.ToggleSubtitle(true);
         if(this._outputConfigurations.length > 0)
         {
            defaultAudio = int(this._outputConfigurations[0].id);
            if(this.setAudioOutput(defaultAudio))
            {
               this.showMsg(DictSetting.NOTE_RESTART_AUDIO,MsgBtnCount.TWO,0,this.onOptionAudioRestartConfirm,DictSetting.RESTART_NOW,this.onDefaultAudioRestartCancel,DictSystem.CANCEL);
               return;
            }
         }
         this.useDefaultAudioFinish();
      }
      
      private function userDefaultSpectator() : void
      {
         this.hideMsg();
         CFunctionCommonContainer.setdvar("cl_shoutcastSettingsQuickPanel","0");
         CFunctionCommonContainer.setdvar("cl_shoutcastSettingsThirdPerson","0");
         CFunctionCommonContainer.setdvar("cl_shoutcastSettingsPlayerList","1");
         CFunctionCommonContainer.setdvar("cl_shoutcastSettingsScorePanel","1");
         CFunctionCommonContainer.setdvar("cl_shoutcastSettingsPlayerCard","1");
         CFunctionCommonContainer.setdvar("cl_shoutcastSettingsHUD","1");
         CFunctionCommonContainer.setdvar("cl_shoutcastSettingsToolBar","1");
         CFunctionCommonContainer.setdvar("cl_shoutcastSettingsMiniMap","1");
         CFunctionCommonContainer.setdvar("cl_shoutcastSettingsSystemMessage","1");
         broadcast(BCEvent.EVT_REFRESH_SPECTATOR_VIEW);
      }
      
      private function onDefaultAudioRestartCancel() : void
      {
         this.useDefaultAudioFinish();
      }
      
      private function useDefaultAudioFinish() : void
      {
         this.showMsg(DictSetting.NOTE_RESET_AUDIOS);
         var defaultControlTimer:Timer = new Timer(2000,1);
         defaultControlTimer.addEventListener(TimerEvent.TIMER,this.onRefreshDefaultAudios);
         defaultControlTimer.start();
      }
      
      private function useDefaultVideo() : void
      {
         this.hideMsg();
         CFunctionContainer.SetRecommendedSetting();
         SettingsService.getInstance().applyBrightness(SettingsService.getInstance().gammaRange.val);
         SettingsService.getInstance().restartVideo();
      }
      
      private function useDefaultControl() : void
      {
         this.hideMsg();
         this.showMsg(DictSetting.NOTE_RESET_CONTROLS);
         this.broadcast(BCEvent.EVT_RESET_CONTROLSHANDLE);
         this.keyboard = Common.KEYBOARD_CODO;
         this.keyboardSet = true;
         var sensitivityDefault:Number = 1;
         if(SettingsService.getInstance().sensitivityRange != null)
         {
            sensitivityDefault = Number(SettingsService.getInstance().sensitivityRange.val);
         }
         CFunctionCommonContainer.setdvar("cl_horizontal_sensitivity",sensitivityDefault.toString());
         CFunctionCommonContainer.setdvar("cl_vertical_sensitivity",sensitivityDefault.toString());
         CFunctionCommonContainer.setdvar("m_pitch","0.022");
         CFunctionCommonContainer.setdvar("m_filter","0");
         CFunctionCommonContainer.setdvar("cl_freelook","1");
         CFunctionCommonContainer.As_markSettingChanged();
         var defaultControlTimer:Timer = new Timer(2000,1);
         defaultControlTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onRefreshDefaultControls);
         defaultControlTimer.start();
      }
      
      private function onRefreshDefaultAudios(cEvt:TimerEvent) : void
      {
         this.hideMsg();
         this.broadcast(BCEvent.EVT_REFRESH_AUDIO_VIEW);
      }
      
      private function onRefreshDefaultControls(cEvt:TimerEvent) : void
      {
         if(Boolean(this.getDP(DataID.IS_DEV_BUILD)))
         {
            CFunctionCommonContainer.execnow("bind f4 devgui");
         }
         this.hideMsg();
         this.broadcast(BCEvent.EVT_REFRESH_CONTROL_VIEW);
      }
      
      private function isVitalCommandsBounded(cShowMsg:Boolean = true) : Boolean
      {
         if(!ScaleformUtil.isScaleform)
         {
            return true;
         }
         var commandsToCheck:Array = vital_commands_movement.concat(vital_commands_action).concat(vital_commands_chat);
         this.unboundCommands.splice(0);
         for(var i:int = 0; i < commandsToCheck.length; i++)
         {
            if(this.getDP(DataID.KEY_BINDING_COUNT_ON_COMMAND,[commandsToCheck[i]]) == 0)
            {
               Logger.print("OptionController::isVitalCommandsBinded(): unbound command" + commandsToCheck[i]);
               this.unboundCommands.push(commandsToCheck[i]);
            }
         }
         for(i = 0; i < vital_commands_toggle.length; i++)
         {
            if(this.getDP(DataID.KEY_BINDING_COUNT_ON_COMMAND,[vital_commands_toggle[i]]) == 0)
            {
               if(this.getDP(DataID.KEY_BINDING_COUNT_ON_COMMAND,[vital_commands_longpress[i]]) == 0)
               {
                  this.unboundCommands.push(vital_commands_toggle[i]);
               }
            }
         }
         if(this.unboundCommands.length > 0)
         {
            if(cShowMsg)
            {
               showMsg(DictSetting.NOTE_KEYS_UNBOUNDED,MsgBtnCount.ONE,0,null,DictSystem.CONFIRM);
            }
            Logger.print("OptionController::isVitalCommandsBounded:" + this.unboundCommands);
            this.broadcast(BCEvent.EVT_OPTION_COMMANDS_UNBOUND,this.unboundCommands);
            return false;
         }
         this.broadcast(BCEvent.EVT_OPTION_COMMANDS_UNBOUND,this.unboundCommands);
         return true;
      }
      
      private function retrieveVideoSettings() : Object
      {
         if(this.keyboard == Common.KEYBOARD_NONE)
         {
            this.keyboard = Common.KEYBOARD_CODO;
         }
         return SettingsService.getInstance().retrieveVideoSetting();
      }
      
      private function shoutcastOptionQuickPanel() : Boolean
      {
         return this.getDvarBool("cl_shoutcastSettingsQuickPanel");
      }
      
      private function shoutcastOptionThirdPerson() : Boolean
      {
         return this.getDvarBool("cl_shoutcastSettingsThirdPerson");
      }
      
      private function shoutcastOptionPlayerList() : Boolean
      {
         return this.getDvarBool("cl_shoutcastSettingsPlayerList");
      }
      
      private function shoutcastOptionScorePanel() : Boolean
      {
         return this.getDvarBool("cl_shoutcastSettingsScorePanel");
      }
      
      private function shoutcastOptionPlayerCard() : Boolean
      {
         return this.getDvarBool("cl_shoutcastSettingsPlayerCard");
      }
      
      private function shoutcastOptionHUD() : Boolean
      {
         return this.getDvarBool("cl_shoutcastSettingsHUD");
      }
      
      private function shoutcastOptionToolBar() : Boolean
      {
         return this.getDvarBool("cl_shoutcastSettingsToolBar");
      }
      
      private function shoutcastOptionMiniMap() : Boolean
      {
         return this.getDvarBool("cl_shoutcastSettingsMiniMap");
      }
      
      private function shoutcastOptionSystemMessage() : Boolean
      {
         return this.getDvarBool("cl_shoutcastSettingsSystemMessage");
      }
      
      private function onSetDefaultVideo(cEvt:ParaEvent) : void
      {
         this.showMsg(DictSetting.NOTE_RESTORE_VIDEO,MsgBtnCount.TWO,0,this.useDefaultVideo);
      }
      
      private function onSetDefaultControl(cEvt:ParaEvent) : void
      {
         this.showMsg(DictSetting.NOTE_RESTORE_CONTROL,MsgBtnCount.TWO,0,this.useDefaultControl);
      }
      
      private function onSetBrightnessHandle(cEvt:ParaEvent) : void
      {
         SettingsService.getInstance().applyBrightness(cEvt.myPara);
      }
      
      private function onSetFovHandle(cEvt:ParaEvent) : void
      {
         SettingsService.getInstance().applyFOV(cEvt.myPara);
      }
      
      private function onChooseKeyboard(cEvt:ParaEvent) : void
      {
         var codo:Boolean = cEvt.myPara.keyboard == Common.KEYBOARD_CODO;
         this.keyboard = codo ? Common.KEYBOARD_CODO : Common.KEYBOARD_CROSSFIRE;
         this.keyboardSet = codo;
         if(Boolean(this.getDP(DataID.IS_DEV_BUILD)))
         {
            CFunctionCommonContainer.execnow("exec autoexec_pc_dev_mp.cfg");
         }
      }
      
      private function get keyboard() : int
      {
         var keyboard:int = this.getDvarInt("ui_current_keyboard");
         if(keyboard == Common.KEYBOARD_NONE)
         {
            keyboard = Common.KEYBOARD_CODO;
            this.keyboard = keyboard;
         }
         return keyboard;
      }
      
      private function set keyboard(keyboard:int) : void
      {
         CFunctionCommonContainer.setdvar("ui_current_keyboard",keyboard.toString());
         CFunctionCommonContainer.As_markSettingChanged();
      }
      
      private function set keyboardSet(isCodoSet:Boolean) : void
      {
         CFunctionCommonContainer.execnow("exec default_mp_controls" + (isCodoSet ? "" : "_2") + ".cfg");
         CFunctionCommonContainer.As_markSettingChanged();
      }
   }
}

