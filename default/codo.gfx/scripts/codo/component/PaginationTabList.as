package codo.component
{
   import codo.component.factory.ButtonFactory;
   import codo.event.ParaEvent;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import flash.utils.getDefinitionByName;
   
   public class PaginationTabList extends MovieClip
   {
      
      private static const AUTO_PAGE_FLIP_INTERVAL:uint = 5000;
      
      private static const AUTO_PAGE_FLIP_STEP:uint = 50;
      
      private static const TAB_PADDING:uint = 2;
      
      private static const TAB_MARGIN:uint = 6;
      
      public var myTabMount:MovieClip;
      
      public var myBackground:MovieClip;
      
      private var mNumItems:int = 0;
      
      private var mAutoPageTimer:Timer;
      
      private var mCurrentPage:int = 0;
      
      private var mTabs:Vector.<NumberButton>;
      
      private var mAutoPaged:Boolean = false;
      
      public function PaginationTabList()
      {
         super();
         this.mAutoPageTimer = new Timer(AUTO_PAGE_FLIP_INTERVAL);
         this.mAutoPageTimer.addEventListener(TimerEvent.TIMER,this.onAutoPageTimerTick);
      }
      
      public function setNumPages(n:int) : void
      {
         var tab:NumberButton = null;
         var i:int = 0;
         this.clear();
         this.mNumItems = n;
         this.mTabs = new Vector.<NumberButton>();
         var tabClass:Class = getDefinitionByName(ButtonFactory.NUMBER_BUTTON_LINKAGE) as Class;
         var curPos:Number = 0;
         for(i = 0; i < this.mNumItems; i++)
         {
            tab = new tabClass() as NumberButton;
            this.myTabMount.addChild(tab);
            tab.x = curPos;
            tab.label = (i + 1).toString();
            tab.index = i;
            tab.setClickCallback(this.onTabClicked);
            curPos += tab.width + TAB_PADDING;
            this.mTabs.push(tab);
         }
         if(this.mTabs.length > 1)
         {
            this.mAutoPageTimer.reset();
            this.mAutoPageTimer.start();
         }
         this.myBackground.width = this.myTabMount.width + TAB_MARGIN;
         this.myBackground.height = this.myTabMount.height;
         this.mCurrentPage = 0;
         this.updateCurrentPage(this.mCurrentPage,true);
      }
      
      public function nextPage() : void
      {
         var newIdx:int = this.mCurrentPage;
         newIdx++;
         if(newIdx >= this.mNumItems)
         {
            newIdx = 0;
         }
         this.updateCurrentPage(newIdx);
      }
      
      public function previousPage() : void
      {
         var newIdx:int = this.mCurrentPage;
         newIdx--;
         if(newIdx < 0)
         {
            newIdx = this.mNumItems - 1;
         }
         this.updateCurrentPage(newIdx);
      }
      
      public function clear() : void
      {
         while(this.myTabMount.numChildren > 0)
         {
            this.myTabMount.removeChildAt(0);
         }
      }
      
      public function get autoPaged() : Boolean
      {
         return this.mAutoPaged;
      }
      
      public function get currentPage() : int
      {
         return this.mCurrentPage;
      }
      
      public function updateCurrentPage(idx:int, reset:Boolean = false) : void
      {
         this.mTabs[this.mCurrentPage].enabled = true;
         this.mCurrentPage = idx;
         this.mTabs[this.mCurrentPage].enabled = false;
         dispatchEvent(new ParaEvent(Event.CHANGE,{"bListReset":reset}));
      }
      
      private function onAutoPageTimerTick(e:TimerEvent) : void
      {
         this.mAutoPageTimer.reset();
         this.mAutoPageTimer.start();
         this.mAutoPaged = true;
         this.nextPage();
      }
      
      private function onTabClicked(tab:NumberButton) : void
      {
         for(var i:int = 0; i < this.mNumItems; i++)
         {
            if(this.mTabs[i] == tab)
            {
               this.mAutoPaged = false;
               this.updateCurrentPage(i);
            }
         }
         this.mAutoPageTimer.reset();
         this.mAutoPageTimer.start();
      }
      
      public function stopTimer() : void
      {
         this.mAutoPageTimer.stop();
      }
      
      public function startTimer() : void
      {
         if(this.mNumItems > 0)
         {
            this.mAutoPageTimer.reset();
            this.mAutoPageTimer.start();
         }
      }
   }
}

