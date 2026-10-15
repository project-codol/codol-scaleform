package components.gvoice
{
   import codo.common.CFunctionCommonContainer;
   import codo.localization.Dict;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class GVoiceChatBar extends MovieClip
   {
      
      public var myHint:TextField;
      
      public var myBatterySignal1:MovieClip;
      
      public var myBatterySignal2:MovieClip;
      
      public var myBatterySignal3:MovieClip;
      
      public var myBatterySignal4:MovieClip;
      
      public var myBatterySignal5:MovieClip;
      
      public var myBatterySignal6:MovieClip;
      
      public var myBatterySignal7:MovieClip;
      
      public var mySpeakVolumeBar:GVoiceChatBarSpeakerVolumeBar;
      
      private var mBatterySignals:Vector.<MovieClip>;
      
      public function GVoiceChatBar()
      {
         super();
         this.myHint.text = Dict.GVOICE_CHAT_HINT;
         this.mBatterySignals = new <MovieClip>[this.myBatterySignal1,this.myBatterySignal2,this.myBatterySignal3,this.myBatterySignal4,this.myBatterySignal5,this.myBatterySignal6,this.myBatterySignal7];
         gotoAndStop(1);
         this.mySpeakVolumeBar.gotoAndStop(1);
      }
      
      public function show() : void
      {
         visible = true;
         this.mySpeakVolumeBar.show();
      }
      
      public function hide() : void
      {
         visible = false;
         this.mySpeakVolumeBar.hide();
      }
      
      public function set currentTalkingMember(memberID:int) : void
      {
         var found:Boolean = false;
         var members:Array = null;
         var member:Object = null;
         if(memberID == 0)
         {
            this.myHint.text = Dict.GVOICE_CHAT_HINT;
            this.mySpeakVolumeBar.stopVoiceAnim();
         }
         else
         {
            found = false;
            members = CFunctionCommonContainer.AS_GVoice_GetRoomMembers();
            for each(member in members)
            {
               if(member.memberID == memberID)
               {
                  this.myHint.text = member.name;
                  this.mySpeakVolumeBar.startVoiceAnim();
                  found = true;
                  break;
               }
            }
            if(!found)
            {
               this.myHint.text = Dict.GVOICE_CHAT_HINT;
               this.mySpeakVolumeBar.stopVoiceAnim();
            }
         }
      }
      
      public function setBattery(value:int) : void
      {
         var batterySignals:int = int(Math.round(value * this.mBatterySignals.length / 100));
         for(var i:int = 0; i < this.mBatterySignals.length; i++)
         {
            if(i < batterySignals)
            {
               this.mBatterySignals[i].visible = true;
            }
            else
            {
               this.mBatterySignals[i].visible = false;
            }
         }
      }
   }
}

