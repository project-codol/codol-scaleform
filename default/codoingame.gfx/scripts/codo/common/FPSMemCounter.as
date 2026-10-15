package codo.common
{
   import codo.constants.GameInfo;
   import codo.interfaces.ICommManager;
   import codo.utils.ScaleformUtil;
   import flash.events.Event;
   import flash.filters.DropShadowFilter;
   import flash.system.System;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.utils.getTimer;
   
   public class FPSMemCounter extends TextField
   {
      
      private static const UPDATE_INTERVAL:Number = 1000;
      
      private var fontSize:Number;
      
      private var lastUpdate:Number;
      
      private var frameCount:Number;
      
      private var currentTime:Number;
      
      private var commManager:ICommManager;
      
      public function FPSMemCounter(commManager:ICommManager = null, textColor:Number = 16777215, fontSize:Number = 25)
      {
         super();
         this.commManager = commManager;
         this.textColor = textColor;
         this.alpha = 0.5;
         this.fontSize = 12;
         var txt_k:TextFormat = new TextFormat();
         txt_k.font = GameInfo.GAME_FONT_L;
         this.defaultTextFormat = txt_k;
         this.setTextFormat(txt_k);
         this.embedFonts = true;
         var txtFilter:DropShadowFilter = new DropShadowFilter(0,45,0,0.8,3,3,3);
         var txtFilterAry:Array = [];
         txtFilterAry.push(txtFilter);
         this.filters = txtFilterAry;
         autoSize = TextFieldAutoSize.LEFT;
         selectable = false;
         mouseEnabled = false;
         addEventListener(Event.ADDED_TO_STAGE,this.setFPSUpdate);
         addEventListener(Event.REMOVED_FROM_STAGE,this.clearFPSUpdate);
      }
      
      private function setFPSUpdate(event:Event) : void
      {
         addEventListener(Event.ENTER_FRAME,this.updateFPS);
         this.frameCount = 0;
         this.updateText(this.frameCount);
         this.lastUpdate = getTimer();
      }
      
      private function clearFPSUpdate(event:Event) : void
      {
         removeEventListener(Event.ENTER_FRAME,this.updateFPS);
      }
      
      private function updateFPS(event:Event) : void
      {
         this.currentTime = getTimer();
         ++this.frameCount;
         if(this.currentTime >= this.lastUpdate + UPDATE_INTERVAL)
         {
            this.lastUpdate = this.currentTime;
            this.updateText(this.frameCount);
            this.frameCount = 0;
         }
      }
      
      private function updateText(frameNum:Number) : void
      {
         var mem:String = Number(System.totalMemory / 1024 / 1024).toFixed(5) + "Mb";
         text = "FPS : " + frameNum + " / Total : " + mem;
         if(ScaleformUtil.isScaleform == false)
         {
            if(this.commManager != null)
            {
               this.commManager.cppUpdate(frameNum / 50);
            }
         }
      }
   }
}

