package codo.views.hudSpy
{
   import codo.localization.DictHud;
   import codo.utils.LocalizeUtil;
   import codo.utils.SpyUtil;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class SpeakerContainer extends MovieClip
   {
      
      public static const TALKING_STATE_NONE:int = 0;
      
      public static const TALKING_STATE_ALL:int = 1;
      
      public static const TALKING_STATE_SPY:int = 2;
      
      private const MAX_TALKING_CLIENTS:int = 5;
      
      public var mySpeaker1:VoiceSpeaker;
      
      public var mySpeaker2:VoiceSpeaker;
      
      public var mySpeaker3:VoiceSpeaker;
      
      public var mySpeaker4:VoiceSpeaker;
      
      public var mySpeaker5:VoiceSpeaker;
      
      public var myChannelHotKey:TextField;
      
      public var myChannelLabel:TextField;
      
      public var myVolumeSignal:MovieClip;
      
      public var myMarkerBG:MovieClip;
      
      public var myMarkerHotKey:TextField;
      
      public var myMarkerLabel:TextField;
      
      public var mySpyChannelBg:MovieClip;
      
      public var mySpyChannelLabel:TextField;
      
      public var mySpyChannelHotKeyBG:MovieClip;
      
      public var mySpyChannelHotKey:TextField;
      
      public var mySpyVolumeSignal:MovieClip;
      
      public var mySpyMarkerBG:MovieClip;
      
      public var mySpyMarkerHotKey:TextField;
      
      public var mySpyMarkerLabel:TextField;
      
      private var mySpeakers:Vector.<VoiceSpeaker>;
      
      private var mTalkingClients:Array;
      
      private var mSpyChannelEnabled:Boolean;
      
      public function SpeakerContainer()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         this.mySpeakers = new <VoiceSpeaker>[this.mySpeaker1,this.mySpeaker2,this.mySpeaker3,this.mySpeaker4,this.mySpeaker5];
         for(var i:int = 0; i < this.mySpeakers.length; i++)
         {
            this.mySpeakers[i].visible = false;
         }
         this.myChannelLabel.text = LocalizeUtil.localize(DictHud.SPY_NORMAL_CHANNEL);
         this.mTalkingClients = [-1,-1,-1,-1,-1];
         this.mySpyChannelLabel.text = LocalizeUtil.localize(DictHud.SPY_SPY_CHANNEL);
         this.mySpyChannelHotKey.text = "X";
         this.myMarkerHotKey.text = "M";
         this.mySpyMarkerHotKey.text = "N";
         this.myMarkerLabel.text = LocalizeUtil.localize(DictHud.SPY_MARKER);
         this.mySpyMarkerLabel.text = LocalizeUtil.localize(DictHud.SPY_SPY_MARKER);
         this.setSpyChannelSpeaking(false);
         this.setNormalChannelSpeaking(false);
         this.cppEnableSpyChannel(false);
      }
      
      public function cppSetMuted(muted:Boolean) : void
      {
         if(muted)
         {
            this.myChannelLabel.text = LocalizeUtil.localize(DictHud.SPY_MUTED);
            this.mySpyChannelLabel.text = LocalizeUtil.localize(DictHud.SPY_MUTED);
         }
         else
         {
            this.myChannelLabel.text = LocalizeUtil.localize(DictHud.SPY_NORMAL_CHANNEL);
            this.mySpyChannelLabel.text = LocalizeUtil.localize(DictHud.SPY_SPY_CHANNEL);
         }
      }
      
      private function setNormalChannelSpeaking(speaking:Boolean) : void
      {
         this.myVolumeSignal.visible = speaking;
         this.myChannelLabel.visible = !speaking;
         if(speaking)
         {
            this.myVolumeSignal.gotoAndPlay(1);
         }
         else
         {
            this.myVolumeSignal.stop();
         }
      }
      
      private function setSpyChannelSpeaking(speaking:Boolean) : void
      {
         if(this.mSpyChannelEnabled)
         {
            this.mySpyVolumeSignal.visible = speaking;
            this.mySpyChannelLabel.visible = !speaking;
            if(speaking)
            {
               this.mySpyVolumeSignal.gotoAndPlay(1);
            }
            else
            {
               this.mySpyVolumeSignal.stop();
            }
         }
      }
      
      public function cppSetChannelSpeaking(talkingState:int) : void
      {
         var isSpyChannelSpeaking:Boolean = false;
         var isNormalChannelSpeaking:Boolean = false;
         if(talkingState == TALKING_STATE_ALL)
         {
            isNormalChannelSpeaking = true;
         }
         else if(talkingState == TALKING_STATE_SPY)
         {
            isSpyChannelSpeaking = true;
         }
         this.setNormalChannelSpeaking(isNormalChannelSpeaking);
         this.setSpyChannelSpeaking(isSpyChannelSpeaking);
      }
      
      public function cppEnableSpyChannel(enable:Boolean) : void
      {
         this.mySpyChannelBg.visible = this.mySpyChannelLabel.visible = this.mySpyChannelHotKey.visible = this.mySpyChannelHotKeyBG.visible = this.mySpyMarkerBG.visible = this.mySpyMarkerHotKey.visible = this.mySpyMarkerLabel.visible = enable;
         this.mySpyVolumeSignal.visible = false;
         this.mSpyChannelEnabled = enable;
      }
      
      private function fillVoiceSpeakerData(speakerIndex:int, obj:Object) : void
      {
         this.mySpeakers[speakerIndex].playerName = obj.playerName;
         this.mySpeakers[speakerIndex].playerNickname = obj.nickname;
         this.mySpeakers[speakerIndex].myName.textColor = SpyUtil.getRoleColor(obj.role);
         this.mySpeakers[speakerIndex].visible = true;
      }
      
      public function cppUpdateSpeakingClients(talkingClients:Array) : void
      {
         var currentFrame:int = 0;
         var i:int = 0;
         var clientNum:int = -1;
         var talkingClientsBuffer:Array = [];
         var index:int = 0;
         var mcIndex:int = 0;
         var newTalkingClients:Array = [];
         for(i = 0; i < talkingClients.length; i++)
         {
            clientNum = int(talkingClients[i].clientNum);
            newTalkingClients.push(clientNum);
         }
         for(i = 0; i < this.mTalkingClients.length; i++)
         {
            clientNum = int(this.mTalkingClients[i]);
            if(clientNum == -1)
            {
               break;
            }
            if(newTalkingClients.indexOf(clientNum) > 0)
            {
               talkingClientsBuffer.push(clientNum);
               currentFrame = this.mySpeakers[i].mySignal.currentFrame;
               this.mySpeakers[talkingClientsBuffer.length - 1].startAnimation(currentFrame);
               index = newTalkingClients.indexOf(clientNum);
               mcIndex = talkingClientsBuffer.length - 1;
               this.fillVoiceSpeakerData(mcIndex,talkingClients[index]);
            }
         }
         for(i = 0; i < newTalkingClients.length; i++)
         {
            clientNum = int(newTalkingClients[i]);
            if(talkingClientsBuffer.indexOf(clientNum) < 0)
            {
               talkingClientsBuffer.push(clientNum);
               index = newTalkingClients.indexOf(clientNum);
               mcIndex = talkingClientsBuffer.length - 1;
               this.fillVoiceSpeakerData(mcIndex,talkingClients[index]);
               this.mySpeakers[talkingClientsBuffer.length - 1].startAnimation();
            }
         }
         for(i = int(talkingClientsBuffer.length); i < this.MAX_TALKING_CLIENTS; i++)
         {
            this.mySpeakers[i].stopAnimation();
            this.mySpeakers[i].visible = false;
         }
         this.mTalkingClients = talkingClientsBuffer;
      }
   }
}

