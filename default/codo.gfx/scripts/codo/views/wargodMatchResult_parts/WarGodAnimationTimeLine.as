package codo.views.wargodMatchResult_parts
{
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.utils.getTimer;
   
   public class WarGodAnimationTimeLine extends Sprite
   {
      
      private var mSortedElements:Vector.<ElementWrapper>;
      
      private var mTriggeredElements:Vector.<ElementWrapper>;
      
      private var mPlayingElements:Vector.<ElementWrapper>;
      
      private var mHeadElementIndex:int = -1;
      
      private var mStartTimeStamp:uint;
      
      private var mCompleteHandler:Function;
      
      private var mSubElementCompleteHandler:Function;
      
      private var mSubElementPauseHandler:Function;
      
      public function WarGodAnimationTimeLine()
      {
         super();
         this.mSortedElements = new Vector.<ElementWrapper>();
         this.mTriggeredElements = new Vector.<ElementWrapper>();
         this.mPlayingElements = new Vector.<ElementWrapper>();
      }
      
      public function registerCompleteHandler(handler:Function) : void
      {
         this.mCompleteHandler = handler;
      }
      
      public function registerSubElementComplete(handler:Function) : void
      {
         this.mSubElementCompleteHandler = handler;
      }
      
      public function registerSubElementPause(handler:Function) : void
      {
         this.mSubElementPauseHandler = handler;
      }
      
      public function start() : void
      {
         if(this.mSortedElements.length > 0)
         {
            this.mHeadElementIndex = 0;
            this.mStartTimeStamp = getTimer();
            addEventListener(Event.ENTER_FRAME,this.onEnterFrameHandler);
         }
      }
      
      public function stop() : void
      {
         var num:int = int(this.mPlayingElements.length);
         for(var i:int = 0; i < num; i++)
         {
            this.mPlayingElements[i].element.stopAni();
         }
         this.cleanUp();
      }
      
      public function add(element:WarGodAnimateElement, seconds:Number) : void
      {
         var newElement:ElementWrapper = new ElementWrapper();
         newElement.element = element;
         newElement.started = false;
         newElement.startSecond = seconds;
         var elementsCount:int = int(this.mSortedElements.length);
         var added:Boolean = false;
         for(var i:int = 0; i < elementsCount; i++)
         {
            if(this.mSortedElements[i].startSecond >= seconds)
            {
               this.mSortedElements.splice(i,0,newElement);
               element.registerCompleteHandler(this.onElementAnimationComplete);
               element.registerPauseHandler(this.onElementAnimationPause);
               added = true;
               break;
            }
         }
         if(!added)
         {
            this.mSortedElements.push(newElement);
            element.registerCompleteHandler(this.onElementAnimationComplete);
            element.registerPauseHandler(this.onElementAnimationPause);
         }
      }
      
      public function addBehindElement(element:WarGodAnimateElement, previousElement:WarGodAnimateElement) : void
      {
         element.registerCompleteHandler(this.onElementAnimationComplete);
         element.registerPauseHandler(this.onElementAnimationPause);
         var newElement:ElementWrapper = new ElementWrapper();
         newElement.element = element;
         newElement.previousElement = previousElement;
         this.mTriggeredElements.push(newElement);
      }
      
      public function manualTriggerAni(element:WarGodAnimateElement) : void
      {
         for(var i:int = 0; i < this.mTriggeredElements.length; i++)
         {
            if(this.mTriggeredElements[i].element == element)
            {
               element.startAni();
               this.mPlayingElements.push(this.mTriggeredElements[i]);
               break;
            }
         }
      }
      
      public function get duration() : Number
      {
         return (getTimer() - this.mStartTimeStamp) / 1000;
      }
      
      private function onEnterFrameHandler(e:Event) : void
      {
         if(this.mHeadElementIndex >= this.mSortedElements.length)
         {
            return;
         }
         var offset:Number = (getTimer() - this.mStartTimeStamp) / 1000;
         while(offset >= this.mSortedElements[this.mHeadElementIndex].startSecond && !this.mSortedElements[this.mHeadElementIndex].started)
         {
            this.mSortedElements[this.mHeadElementIndex].element.startAni();
            this.mSortedElements[this.mHeadElementIndex].started = true;
            this.mPlayingElements.push(this.mSortedElements[this.mHeadElementIndex]);
            ++this.mHeadElementIndex;
            if(this.mHeadElementIndex >= this.mSortedElements.length)
            {
               break;
            }
         }
      }
      
      private function onElementAnimationPause(comElem:WarGodAnimateElement) : void
      {
         if(null != this.mSubElementPauseHandler)
         {
            this.mSubElementPauseHandler(comElem);
         }
      }
      
      private function onElementAnimationComplete(comElem:WarGodAnimateElement) : void
      {
         var elementWrapper:ElementWrapper = null;
         var index:int = -1;
         for(var i:int = 0; i < this.mPlayingElements.length; i++)
         {
            if(this.mPlayingElements[i].element == comElem)
            {
               index = i;
               break;
            }
         }
         if(index != -1)
         {
            this.mPlayingElements.splice(index,1);
            for(i = this.mTriggeredElements.length - 1; i >= 0; i--)
            {
               if(this.mTriggeredElements[i].previousElement == comElem)
               {
                  elementWrapper = this.mTriggeredElements[i];
                  this.mPlayingElements.push(elementWrapper);
                  elementWrapper.element.startAni();
               }
            }
         }
         if(null != this.mSubElementCompleteHandler)
         {
            this.mSubElementCompleteHandler(comElem);
         }
         if(this.mPlayingElements.length <= 0 && this.mHeadElementIndex >= this.mSortedElements.length)
         {
            this.animationComplete();
         }
      }
      
      private function animationComplete() : void
      {
         this.cleanUp();
         if(this.mCompleteHandler != null)
         {
            this.mCompleteHandler();
         }
      }
      
      private function cleanUp() : void
      {
         var num:int = int(this.mSortedElements.length);
         for(var i:int = 0; i < num; i++)
         {
            this.mSortedElements[i].element.registerCompleteHandler(null);
         }
         this.mSortedElements.length = 0;
         this.mPlayingElements.length = 0;
         this.mTriggeredElements.length = 0;
         this.mHeadElementIndex = -1;
         this.mStartTimeStamp = 0;
         this.mCompleteHandler = null;
         this.mSubElementCompleteHandler = null;
         removeEventListener(Event.ENTER_FRAME,this.onEnterFrameHandler);
      }
   }
}

import codo.views.wargodMatchResult_parts.WarGodAnimateElement;

class ElementWrapper
{
   
   public var startSecond:Number;
   
   public var started:Boolean;
   
   public var element:WarGodAnimateElement;
   
   public var previousElement:WarGodAnimateElement;
   
   public function ElementWrapper()
   {
      super();
   }
}
