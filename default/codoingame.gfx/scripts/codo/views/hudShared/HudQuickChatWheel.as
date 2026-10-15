package codo.views.hudShared
{
   import codo.common.CFunctionInGameContainer;
   import codo.component.core.UIInteractiveComponent;
   import codo.constants.BCInGameEvent;
   import codo.event.ParaEvent;
   import codo.manager.EventManager;
   import codo.utils.LocalizeUtil;
   import flash.display.MovieClip;
   import flash.events.KeyboardEvent;
   import flash.filters.ColorMatrixFilter;
   import fsg.util.FsgImageHolder;
   
   public class HudQuickChatWheel extends UIInteractiveComponent
   {
      
      public var myPart1:HudQuickChatWheelPart;
      
      public var myPart2:HudQuickChatWheelPart;
      
      public var myPart3:HudQuickChatWheelPart;
      
      public var myPart4:HudQuickChatWheelPart;
      
      public var myPart5:HudQuickChatWheelPart;
      
      public var myPart6:HudQuickChatWheelPart;
      
      public var myPart7:HudQuickChatWheelPart;
      
      public var myPart8:HudQuickChatWheelPart;
      
      public var myImage:FsgImageHolder;
      
      public var myCenter:MovieClip;
      
      public var mParts:Vector.<HudQuickChatWheelPart>;
      
      public function HudQuickChatWheel()
      {
         super();
         this.mParts = new <HudQuickChatWheelPart>[this.myPart1,this.myPart2,this.myPart3,this.myPart4,this.myPart5,this.myPart6,this.myPart7,this.myPart8];
      }
      
      public function show(channel:int) : void
      {
         var i:int = 0;
         var slot:int = 0;
         var title:String = null;
         var message:String = null;
         EventManager.getInstance().listen(BCInGameEvent.EVT_SET_ACTIVE_QUICK_CHAT_PART,this.onSetActiveQuickChatPart);
         parent.stage.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDownHandler);
         var quickChatInfo:Object = CFunctionInGameContainer.AS_GetQuickChatInfo(channel);
         var deactiveBgColor:uint = uint(quickChatInfo.deactiveBgColor);
         var activeBgColor:uint = uint(quickChatInfo.activeBgColor);
         var deactiveTextColor:uint = uint(quickChatInfo.deactiveTextColor);
         var activeTextColor:uint = uint(quickChatInfo.activeTextColor);
         var isRoomMessage:Boolean = Boolean(quickChatInfo.isRoomMessage);
         var redChannel:Number = (deactiveBgColor >> 16 & 0xFF) / 255;
         var greenChannel:Number = (deactiveBgColor >> 8 & 0xFF) / 255;
         var blueChannel:Number = (deactiveBgColor & 0xFF) / 255;
         var colorMat:Array = [redChannel,0,0,0,0,0,greenChannel,0,0,0,0,0,blueChannel,0,0,0,0,0,1,0];
         this.myCenter.filters = [new ColorMatrixFilter(colorMat)];
         this.myCenter.alpha = 0.7;
         this.myImage.setImage(quickChatInfo.icon);
         for(i = 0; i < this.mParts.length; i++)
         {
            this.mParts[i].index = i + 1;
            this.mParts[i].deactiveBgColor = deactiveBgColor;
            this.mParts[i].activeBgColor = activeBgColor;
            this.mParts[i].deactiveTextColor = deactiveTextColor;
            this.mParts[i].activeTextColor = activeTextColor;
            this.mParts[i].isRoomMessage = isRoomMessage;
            this.mParts[i].text = "";
            this.mParts[i].channel = channel;
            this.mParts[i].isActive = false;
         }
         for(i = 0; i < quickChatInfo.commands.length; i++)
         {
            slot = int(quickChatInfo.commands[i].slot);
            title = quickChatInfo.commands[i].title;
            message = quickChatInfo.commands[i].message;
            if(slot > 0 && slot <= this.mParts.length)
            {
               this.mParts[slot - 1].text = LocalizeUtil.localize(title);
               this.mParts[slot - 1].message = LocalizeUtil.localize(message);
               this.mParts[slot - 1].isActive = false;
            }
         }
      }
      
      public function hide() : void
      {
         parent.stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDownHandler);
         for(var i:int = 0; i < this.mParts.length; i++)
         {
            if(this.mParts[i].isActive)
            {
               this.mParts[i].SendCommandToDS();
               this.mParts[i].isActive = false;
            }
            this.mParts[i].channel = 0;
         }
      }
      
      private function onKeyDownHandler(cEvt:KeyboardEvent) : void
      {
         var cmd:int = 0;
         var beginCharCode:int = "1".charCodeAt();
         var endCharCode:int = "8".charCodeAt();
         if(cEvt.charCode >= beginCharCode && cEvt.charCode <= endCharCode)
         {
            cmd = cEvt.charCode - beginCharCode;
            this.mParts[cmd].SendCommandToDS();
            CFunctionInGameContainer.AS_HideQuickChatView();
         }
         for(var i:int = 0; i < this.mParts.length; i++)
         {
            if(this.mParts[i].isActive)
            {
               this.mParts[i].isActive = false;
               break;
            }
         }
      }
      
      private function onSetActiveQuickChatPart(evt:ParaEvent) : void
      {
         var index:int = evt.myPara as int;
         for(var i:int = 0; i < this.mParts.length; i++)
         {
            this.mParts[i].isActive = false;
            if(i == index - 1)
            {
               this.mParts[i].isActive = true;
            }
         }
      }
   }
}

