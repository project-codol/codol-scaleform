package codo.views.hud.messages
{
   import codo.constants.GameInfo;
   import codo.constants.HUDComponentTypes;
   import codo.utils.ScaleformUtil;
   import codo.views.hud.HUDComponent;
   import com.greensock.TimelineLite;
   import com.greensock.TweenLite;
   import flash.geom.Point;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class HudTopPopupMessage extends HUDComponent
   {
      
      public var myMessage:TextField;
      
      private var mPendingMessages:Array;
      
      private var mDisplayingMessage:Boolean;
      
      public function HudTopPopupMessage()
      {
         super();
         mouseEnabled = false;
         this.mPendingMessages = [];
         TweenLite.killTweensOf(this.myMessage);
         this.myMessage.visible = false;
         this.mDisplayingMessage = false;
      }
      
      override public function get CompType() : int
      {
         return HUDComponentTypes.TOP_POPUP_MESSAGE;
      }
      
      public function cppShowMessage(message:String, color:int, xPos:Number, yPos:Number, fontSize:int) : void
      {
         if(!this.mDisplayingMessage)
         {
            this.showMessage(message,color,xPos,yPos,fontSize);
         }
         else
         {
            this.mPendingMessages.push({
               "message":message,
               "color":color,
               "xPos":xPos,
               "yPos":yPos,
               "fontSize":fontSize
            });
         }
      }
      
      public function showMessage(message:String, color:int, xPos:Number, yPos:Number, fontSize:int) : void
      {
         var timelineLite:TimelineLite = null;
         this.mDisplayingMessage = true;
         this.myMessage.visible = true;
         TweenLite.killTweensOf(this.myMessage);
         timelineLite = new TimelineLite({"onComplete":this.onShowMessageComplete});
         this.myMessage.text = message;
         this.myMessage.textColor = color;
         this.myMessage.alpha = 0;
         var stageSize:Point = new Point(1280,960);
         var stagePosition:Point = new Point(0,0);
         if(ScaleformUtil.isScaleform)
         {
            stageSize = GameInfo.stageSize;
            stagePosition = GameInfo.stagePosition;
         }
         this.myMessage.x = stagePosition.x + (stageSize.x - 800) / 2 + xPos;
         this.myMessage.y = stagePosition.y + yPos;
         var format:TextFormat = this.myMessage.getTextFormat();
         format.size = fontSize;
         this.myMessage.setTextFormat(format);
         timelineLite.append(TweenLite.to(this.myMessage,0.3,{"alpha":1}));
         timelineLite.append(TweenLite.to(this.myMessage,0.3,{
            "delay":0.6,
            "alpha":0
         }));
      }
      
      public function onShowMessageComplete() : void
      {
         var messageInfo:Object = null;
         var message:String = null;
         var color:int = 0;
         var xPos:Number = NaN;
         var yPos:Number = NaN;
         var fontSize:int = 0;
         this.myMessage.visible = false;
         this.mDisplayingMessage = false;
         if(this.mPendingMessages.length > 0)
         {
            messageInfo = this.mPendingMessages[0];
            this.mPendingMessages = this.mPendingMessages.slice(1);
            message = messageInfo.message;
            color = int(messageInfo.color);
            xPos = Number(messageInfo.xPos);
            yPos = Number(messageInfo.yPos);
            fontSize = int(messageInfo.fontSize);
            this.showMessage(message,color,xPos,yPos,fontSize);
         }
      }
   }
}

