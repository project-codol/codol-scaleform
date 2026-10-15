package codo.views.hudSpy
{
   import codo.localization.DictHud;
   import codo.objects.SpyGameMessageObj;
   import codo.style.GlobalGuide;
   import codo.utils.LocalizeUtil;
   import codo.utils.Logger;
   import codo.utils.SpyUtil;
   import flash.display.MovieClip;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.utils.Timer;
   
   public class GameHistoryEntry extends MovieClip
   {
      
      private static const MESSAGE_TYPE_TEXT:int = 0;
      
      private static const MESSAGE_TYPE_BODY_INSPECT:int = 1;
      
      private static const MESSAGE_TYPE_PLAYER_MISSING:int = 2;
      
      private static const MESSAGE_TYPE_BEING_KILLED:int = 3;
      
      private static const MESSAGE_TYPE_DEPUTY_DETECTIVE:int = 4;
      
      private static const MESSAGE_TYPE_JUSTICE_SWORD_KILL:int = 5;
      
      private static const MESSAGE_FADE_OUT_INTERVAL:int = 30000;
      
      private static const CONTROL_WIDTH:int = 600;
      
      private static const XMARGIN_LEFT:int = 2;
      
      private static const XMARGIN_RIGHT:int = 4;
      
      private static const ROLE_ICON_PADDING:int = 4;
      
      private static const RETRY_MAX_COUNT:int = 10;
      
      private static const RETRY_INTERVAL:int = 200;
      
      public var myBG:MovieClip;
      
      public var myText:TextField;
      
      public var myBackendText:TextField;
      
      public var myNickname:PlayerNickname;
      
      public var myVictimNickname:PlayerNickname;
      
      public var myBodyRoleIcon:MovieClip;
      
      public var myRoleNameBg:MovieClip;
      
      private var mVisibleTimer:Timer;
      
      private var mRetryFillDataTimer:Timer;
      
      private var mTextArray:Vector.<TextField>;
      
      private var mBackendTextIndex:int;
      
      private var mMessageObject:SpyGameMessageObj;
      
      public function GameHistoryEntry()
      {
         super();
         this.init();
         this.mVisibleTimer = new Timer(MESSAGE_FADE_OUT_INTERVAL);
         this.mVisibleTimer.addEventListener(TimerEvent.TIMER,this.onVisibleTimerTick);
         this.mRetryFillDataTimer = new Timer(RETRY_INTERVAL,RETRY_MAX_COUNT);
         this.mRetryFillDataTimer.addEventListener(TimerEvent.TIMER,this.retryFillMessageData);
      }
      
      private function init() : void
      {
         this.myText.autoSize = this.myBackendText.autoSize = TextFieldAutoSize.RIGHT;
         this.mTextArray = new Vector.<TextField>();
         this.mTextArray.push(this.myText);
         this.mTextArray.push(this.myBackendText);
         this.mBackendTextIndex = 0;
         this.swapBackFrontTextField();
         this.hideAllChild();
      }
      
      private function hideAllChild() : void
      {
         this.myNickname.visible = this.myVictimNickname.visible = this.myBodyRoleIcon.visible = this.myRoleNameBg.visible = false;
         this.myNickname.gotoAndStop(1);
      }
      
      public function setMessageData(message:SpyGameMessageObj) : void
      {
         this.mMessageObject = message;
         if(!this.fillMessageData(this.mMessageObject))
         {
            if(this.mRetryFillDataTimer.running)
            {
               this.mRetryFillDataTimer.reset();
            }
            this.mRetryFillDataTimer.start();
         }
         else
         {
            this.mRetryFillDataTimer.stop();
         }
      }
      
      private function fillMessageData(message:SpyGameMessageObj) : Boolean
      {
         var indices:Vector.<Point> = null;
         var roleNameRectLeft:Rectangle = null;
         var textField:TextField = null;
         var victimRect:Rectangle = null;
         var murderRect:Rectangle = null;
         textField = this.getBackendText();
         if(message.type == MESSAGE_TYPE_TEXT)
         {
            this.hideAllChild();
            textField.text = LocalizeUtil.localize(message.message);
            this.myRoleNameBg.visible = this.myNickname.visible = this.myVictimNickname.visible = this.myBodyRoleIcon.visible = false;
            textField.width = textField.textWidth;
            textField.x = CONTROL_WIDTH - textField.width - XMARGIN_RIGHT;
            this.myBG.x = textField.x - XMARGIN_LEFT;
            this.myBG.width = CONTROL_WIDTH - this.myBG.x;
         }
         else if(message.type == MESSAGE_TYPE_BODY_INSPECT)
         {
            indices = LocalizeUtil.paramTextFieldInput(textField,DictHud.SPY_GAME_HISTORY_BODY_FOUND,[message.inspector,message.victim,SpyUtil.getLocalizedRoleName(message.victimRole)],[GlobalGuide.WHITE,GlobalGuide.WHITE,SpyUtil.getRoleColor(message.victimRole)]);
            victimRect = textField.getCharBoundaries(indices[1].x);
            roleNameRectLeft = textField.getCharBoundaries(indices[2].x);
            if(victimRect == null || roleNameRectLeft == null)
            {
               Logger.print("GameHistoryEntry Message:[" + textField.text + textField.text.length + "] failed, " + (victimRect == null ? "victimRect null " + indices[1].x : "") + (roleNameRectLeft == null ? "roleNameRectLeft null" + indices[2].x : ""));
               return false;
            }
            this.hideAllChild();
            textField.x = CONTROL_WIDTH - textField.width - XMARGIN_RIGHT;
            this.myNickname.nickname = message.inspectorNickname;
            this.myNickname.x = textField.x - this.myNickname.width;
            this.myNickname.visible = true;
            this.myVictimNickname.x = textField.x + victimRect.left - this.myVictimNickname.width - XMARGIN_LEFT;
            this.myVictimNickname.visible = true;
            this.myVictimNickname.nickname = message.victimNickname;
            this.myBodyRoleIcon.gotoAndStop(message.victimRole);
            this.myBodyRoleIcon.x = textField.x + roleNameRectLeft.left - this.myBodyRoleIcon.width + ROLE_ICON_PADDING;
            this.myBodyRoleIcon.visible = true;
            this.myRoleNameBg.x = this.myBodyRoleIcon.x + ROLE_ICON_PADDING - XMARGIN_LEFT;
            this.myRoleNameBg.width = CONTROL_WIDTH - this.myRoleNameBg.x;
            this.myRoleNameBg.visible = true;
            this.myBG.x = this.myNickname.x - XMARGIN_RIGHT;
            this.myBG.width = CONTROL_WIDTH - this.myBG.x;
         }
         else if(message.type == MESSAGE_TYPE_PLAYER_MISSING)
         {
            this.hideAllChild();
            textField.text = LocalizeUtil.param(DictHud.SPY_GAME_HISTORY_PLAYER_MISSING,[message.victim]);
            this.myNickname.nickname = message.victimNickname;
            textField.width = textField.textWidth;
            textField.x = CONTROL_WIDTH - textField.width - XMARGIN_RIGHT;
            this.myNickname.x = textField.x - this.myNickname.width;
            this.myNickname.visible = textField.visible = true;
            this.myBG.x = this.myNickname.x - XMARGIN_LEFT;
            this.myBG.width = CONTROL_WIDTH - this.myBG.x;
         }
         else if(message.type == MESSAGE_TYPE_BEING_KILLED)
         {
            indices = LocalizeUtil.paramTextFieldInput(textField,DictHud.SPY_GAME_HISTORY_PLAYER_KILLED,[message.murder,SpyUtil.getLocalizedRoleName(message.murderRole)],[GlobalGuide.WHITE,SpyUtil.getRoleColor(message.murderRole)]);
            roleNameRectLeft = textField.getCharBoundaries(indices[1].x);
            murderRect = textField.getCharBoundaries(indices[0].x);
            if(roleNameRectLeft == null || murderRect == null)
            {
               Logger.print("GameHistoryEntry Message:[" + textField.text + textField.text.length + "] failed, " + (murderRect == null ? "murderRect null " + indices[0].x : "") + (roleNameRectLeft == null ? "roleNameRectLeft null" + indices[1].x : ""));
               return false;
            }
            this.hideAllChild();
            textField.x = CONTROL_WIDTH - textField.width - XMARGIN_RIGHT;
            this.myBodyRoleIcon.x = textField.x + roleNameRectLeft.left - this.myBodyRoleIcon.width + ROLE_ICON_PADDING;
            this.myBodyRoleIcon.gotoAndStop(message.murderRole);
            this.myBodyRoleIcon.visible = true;
            this.myRoleNameBg.x = this.myBodyRoleIcon.x + ROLE_ICON_PADDING - XMARGIN_LEFT;
            this.myRoleNameBg.width = CONTROL_WIDTH - this.myRoleNameBg.x;
            this.myRoleNameBg.visible = true;
            this.myNickname.nickname = message.murderNickname;
            this.myNickname.x = textField.x + murderRect.left - this.myNickname.width - XMARGIN_LEFT;
            this.myNickname.visible = true;
            this.myBG.x = textField.x - XMARGIN_RIGHT;
            this.myBG.width = CONTROL_WIDTH - this.myBG.x;
         }
         else if(message.type == MESSAGE_TYPE_DEPUTY_DETECTIVE)
         {
            this.hideAllChild();
            textField.text = LocalizeUtil.param(DictHud.SPY_BECOME_DEPUTY_DETECTIVE_MESSAGE,[message.name]);
            textField.x = CONTROL_WIDTH - textField.width - XMARGIN_RIGHT;
            this.myNickname.nickname = message.nickname;
            this.myNickname.x = textField.x - this.myNickname.width;
            this.myNickname.visible = textField.visible = true;
            this.myBG.x = this.myNickname.x - XMARGIN_LEFT;
            this.myBG.width = CONTROL_WIDTH - this.myBG.x;
         }
         else if(message.type == MESSAGE_TYPE_JUSTICE_SWORD_KILL)
         {
            this.hideAllChild();
            textField.text = LocalizeUtil.param(DictHud.SPY_JUSTICE_SWORD_KILL_MESSAGE,[message.name]);
            textField.x = CONTROL_WIDTH - textField.width - XMARGIN_RIGHT;
            this.myNickname.nickname = message.nickname;
            this.myNickname.x = textField.x - this.myNickname.width;
            this.myNickname.visible = textField.visible = true;
            this.myBG.x = this.myNickname.x - XMARGIN_LEFT;
            this.myBG.width = CONTROL_WIDTH - this.myBG.x;
         }
         if(this.mVisibleTimer.running)
         {
            this.mVisibleTimer.reset();
         }
         this.swapBackFrontTextField();
         visible = true;
         this.mVisibleTimer.start();
         return true;
      }
      
      private function onVisibleTimerTick(evt:TimerEvent) : void
      {
         this.visible = false;
         this.mVisibleTimer.stop();
      }
      
      private function retryFillMessageData(evt:TimerEvent) : void
      {
         if(this.fillMessageData(this.mMessageObject))
         {
            this.mRetryFillDataTimer.stop();
         }
      }
      
      private function getBackendText() : TextField
      {
         return this.mTextArray[this.mBackendTextIndex];
      }
      
      private function swapBackFrontTextField() : void
      {
         var frontIndex:int = this.mBackendTextIndex;
         this.mBackendTextIndex = 1 - this.mBackendTextIndex;
         this.mTextArray[frontIndex].visible = true;
         this.mTextArray[this.mBackendTextIndex].visible = false;
      }
   }
}

