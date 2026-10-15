package codo.views
{
   import codo.base.BaseView;
   import codo.common.CFunctionCommonContainer;
   import codo.constants.GameInfo;
   import codo.constants.TweenParam;
   import codo.localization.Dict;
   import codo.localization.DictSystem;
   import codo.utils.CommonUtil;
   import codo.utils.LocalizeUtil;
   import codo.utils.Logger;
   import codo.utils.ScaleformUtil;
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   import flash.events.TimerEvent;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.utils.Timer;
   import fsg.shared.BarDialogButton;
   import fsg.util.FsgAudioUtil;
   import fsg.util.RandomDataGenerator;
   
   public class FsgServerFullView extends BaseView
   {
      
      public var myQuitBtn:BarDialogButton;
      
      public var myHeaderClip:MovieClip;
      
      public var myTitleText:MovieClip;
      
      public var myLayout:MovieClip;
      
      public var mySpinner:MovieClip;
      
      public var myExitText:MovieClip;
      
      private var m_Timer:Timer = new Timer(1000);
      
      private var m_asVIP:Boolean = false;
      
      private var m_visible:Boolean;
      
      public function FsgServerFullView()
      {
         super();
      }
      
      private function isVIP() : Boolean
      {
         return false;
      }
      
      override protected function onInit() : void
      {
         this.x = (GameInfo.DEFAULT_WIDTH - this.width) * 0.5;
         this.y = (GameInfo.DEFAULT_HEIGHT - this.height) * 0.5;
         this.m_asVIP = this.isVIP();
         this.poleEstimatedTime();
         this.m_visible = false;
         this.myExitText.visible = false;
      }
      
      override protected function showView() : void
      {
         this.myTitleText.visible = false;
         this.myTitleText.myTextTF.text = Dict.LOGIN_QUEUE_TITLE;
         this.myQuitBtn.setText(DictSystem.QUIT);
         this.myLayout.myTF01.myTF1.myTF.defaultTextFormat = this.myLayout.myTF01.myTF1.myTF.getTextFormat();
         this.myExitText.myTF.text = Dict.LOGIN_QUEUE_EXIT;
         if(this.m_asVIP == true)
         {
            this.myHeaderClip.myTF.text = "YOU ARE IN THE VIP QUEUE, THERE ARE 10 VIP\x03PLAYERS AHEAD OF YOU.";
            this.setLabelData(this.myLayout.myTF01,"NORMAL QUEUE LENGTH:","",true);
            this.setLabelData(this.myLayout.myTF02,"VIP QUEUE LENGTH:","",true);
            this.setLabelData(this.myLayout.myTF03,"CALCULATING WAITING TIME...",null,true);
         }
         else
         {
            this.myHeaderClip.myTF.text = Dict.LOGIN_QUEUE_HEADER;
            this.myLayout.gotoAndStop(2);
            this.setLabelData(this.myLayout.myTF01,Dict.LOGIN_QUEUE_POSITION_LABEL,"",false);
            this.setLabelData(this.myLayout.myTF02,Dict.LOGIN_QUEUE_CALCULATING,null,false);
         }
         trace("showing Log In Queue UI***************************");
         this.alpha = 0;
         this.scaleX = this.scaleY = 1;
         TweenLite.to(this,TweenParam.SPD_SCALE,{
            "autoAlpha":1,
            "scaleX":1,
            "scaleY":1,
            "delay":0.5,
            "onComplete":this.onShowComplete
         });
         this.mySpinner.play();
         FsgAudioUtil.getInstance().playSound("ui_login_q_appear");
      }
      
      override protected function hideView() : void
      {
         this.m_visible = false;
         TweenLite.to(this,TweenParam.SPD_SCALE,{
            "autoAlpha":0,
            "scaleX":1,
            "scaleY":1,
            "onComplete":this.onHideComplete
         });
      }
      
      private function onShowComplete() : void
      {
         this.m_visible = true;
      }
      
      private function onHideComplete() : void
      {
      }
      
      private function poleEstimatedTime() : void
      {
         this.m_Timer.addEventListener(TimerEvent.TIMER,this.updateEstimatedTime);
         this.m_Timer.start();
      }
      
      private function updateEstimatedTime(event:TimerEvent) : void
      {
         var data:Object = this.getEstimatedTimeFromServer();
         if(Boolean(data.inQueue))
         {
            if(Boolean(data.waitTimePending))
            {
               this.setLabelData(this.myLayout.myTF02,Dict.LOGIN_QUEUE_CALCULATING,null,false);
               this.setLabelData(this.myLayout.myTF01,null,"-",true,15);
               this.myTitleText.visible = false;
            }
            else
            {
               this.setTimeRemaining(data.queuePosition,data.days,data.hours,data.minutes,data.seconds);
               this.setQueuePosition(data.queuePosition);
               this.myTitleText.visible = true;
            }
         }
         else
         {
            this.m_Timer.stop();
            this.myHeaderClip.visible = false;
            this.setLabelData(this.myLayout.myTF01,"","",false);
            this.setLabelData(this.myLayout.myTF02,"","",false);
            this.myExitText.visible = true;
            this.myTitleText.visible = false;
            FsgAudioUtil.getInstance().playSound("ui_login_q_exit");
         }
      }
      
      public function setTimeRemaining(queuePosition:int, days:int, hours:int, minutes:int, seconds:int) : void
      {
         var timeStr:String = "";
         var lessThanAMinute:Boolean = days == 0 && hours == 0 && minutes == 0 ? true : false;
         if(queuePosition <= 1 || lessThanAMinute == true)
         {
            timeStr = Dict.LOGIN_QUEUE_LOW_TIME_REMAINING;
         }
         else if(hours > 0 || minutes >= 30)
         {
            timeStr = Dict.LOGIN_QUEUE_LONG_TIME_REMAINING;
         }
         else if(minutes > 0)
         {
            timeStr = LocalizeUtil.param(Dict.LOGIN_QUEUE_MINS_SECS,[minutes,seconds]);
         }
         else if(seconds > 0)
         {
            timeStr = LocalizeUtil.param(Dict.LOGIN_QUEUE_SECS,[seconds]);
         }
         else
         {
            timeStr = "-";
         }
         this.setLabelData(this.myLayout.myTF02,Dict.LOGIN_QUEUE_TIME_LABEL,"" + timeStr,true);
      }
      
      public function setQueuePosition(queuePosition:int) : void
      {
         var strQueuePos:String = "";
         if(queuePosition >= 0)
         {
            strQueuePos += queuePosition;
         }
         else
         {
            strQueuePos = "-";
         }
         this.setLabelData(this.myLayout.myTF01,null,strQueuePos,true,15);
      }
      
      private function getEstimatedTimeFromServer() : Object
      {
         var queueData:Object = null;
         if(ScaleformUtil.isScaleform)
         {
            return CFunctionCommonContainer.GetLogInQueueInfo();
         }
         Logger.print("getEstimatedTimeFromServer - returning dummy data");
         return this.dummySeverData();
      }
      
      private function dummySeverData() : Object
      {
         var minutes:int = RandomDataGenerator.randomRange(0,10);
         var seconds:int = RandomDataGenerator.randomRange(0,59);
         return {
            "days":0,
            "hours":0,
            "minutes":minutes,
            "seconds":seconds,
            "queuePosition":24,
            "inQueue":true
         };
      }
      
      private function getQueuePos() : Number
      {
         var last:Number = -1;
         try
         {
            last = Number(this.myLayout.myTF01.myTF2.myNumberTF.text);
         }
         catch(error:Error)
         {
         }
         return last;
      }
      
      private function getVIPQueuePos() : Number
      {
         var last:Number = -1;
         try
         {
            if(this.m_asVIP == true)
            {
               last = Number(this.myLayout.myTF02.myTF2.myNumberTF.text);
            }
         }
         catch(error:Error)
         {
         }
         return last;
      }
      
      override protected function onInitListener() : void
      {
         this.myQuitBtn.registerClickEvent(this.onQuitBtnClickHandle);
      }
      
      private function onQuitBtnClickHandle() : void
      {
         FsgAudioUtil.getInstance().playSound("ui_general_back");
         CommonUtil.quit();
      }
      
      private function setLabelData(clip:MovieClip, strA:String = null, strB:String = null, asNumber:Boolean = true, offset:int = 5) : void
      {
         var tf2:TextField = null;
         if(clip != null)
         {
            if(strA != null)
            {
               clip.myTF1.myTF.text = strA;
               clip.myTF1.myTF.autoSize = TextFieldAutoSize.LEFT;
            }
            if(strB != null)
            {
               tf2 = this.setClipAsNumber(clip,asNumber);
               clip.myTF2.visible = true;
               if(tf2 != null)
               {
                  tf2.defaultTextFormat = tf2.getTextFormat();
                  tf2.text = strB;
                  tf2.autoSize = TextFieldAutoSize.LEFT;
               }
            }
            else
            {
               clip.myTF2.visible = false;
            }
            clip.myTF2.x = clip.myTF1.x + (clip.myTF1.myTF.textWidth + offset);
         }
      }
      
      private function setClipAsNumber(clip:MovieClip, asNumber:Boolean) : TextField
      {
         var tf2:TextField = null;
         if(asNumber == true)
         {
            clip.myTF2.myStringTF.visible = false;
            clip.myTF2.myNumberTF.visible = true;
            tf2 = clip.myTF2.myNumberTF;
         }
         else
         {
            clip.myTF2.myNumberTF.visible = false;
            clip.myTF2.myStringTF.visible = true;
            tf2 = clip.myTF2.myStringTF;
         }
         return tf2;
      }
   }
}

