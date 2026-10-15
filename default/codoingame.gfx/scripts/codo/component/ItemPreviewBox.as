package codo.component
{
   import codo.constants.GameInfo;
   import codo.localization.Dict;
   import codo.objects.ProductObj;
   import codo.style.GlobalGuide;
   import codo.utils.LocalizeUtil;
   import codo.views.UITutorialBaseView;
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.utils.Timer;
   
   public class ItemPreviewBox extends MovieClip
   {
      
      private static const PREVIEW_BOX_X_OFFSET:Number = 40;
      
      private static const PREVIEW_BOX_TOP_STOP:Number = 150;
      
      private static const FADE_DURATION:Number = 0.15;
      
      private static const SHOW_DELAY:Number = 0.3;
      
      private static const HIDE_DELAY:Number = 0;
      
      private static const DUAL_STATS_SWITCH_INTERVAL:Number = 4000;
      
      public var myPreviewCard:ItemPreviewCard;
      
      public var myComparisonCard:ItemPreviewCard;
      
      public var myComparisonLabel:TextField;
      
      private var mBoxHeight:Number = 0;
      
      private var mBoxWidth:Number = 0;
      
      private var mShowing:Boolean;
      
      private var mPreviewItem:ProductObj;
      
      private var mComparisonItem:ProductObj;
      
      private var myStatsTimer:Timer;
      
      public function ItemPreviewBox()
      {
         super();
         mouseEnabled = mouseChildren = false;
         alpha = 0;
         visible = false;
         this.mPreviewItem = null;
         this.mComparisonItem = null;
         this.myPreviewCard.useBaseData = false;
         this.myComparisonCard.useBaseData = true;
         this.myComparisonLabel.fontSize = GlobalGuide.FONT_SIZE_EXTRA_SMALL;
         this.myComparisonLabel.fontColor = GlobalGuide.BLACK;
         this.myComparisonLabel.text = LocalizeUtil.localize(Dict.LOADOUT_EQUIPPED_ITEM).toUpperCase();
         this.myStatsTimer = new Timer(DUAL_STATS_SWITCH_INTERVAL);
         this.myStatsTimer.addEventListener(TimerEvent.TIMER,this.onDualStatsTimer);
      }
      
      private function onDualStatsTimer(e:TimerEvent) : void
      {
         var newState:int = 0;
         var hideComparison:Boolean = false;
         var curState:int = this.myPreviewCard.statsState;
         if(curState != ItemPreviewCard.STATS_BASIC)
         {
            newState = curState == ItemPreviewCard.STATS_DUAL_BASE ? int(ItemPreviewCard.STATS_DUAL_CLASH) : int(ItemPreviewCard.STATS_DUAL_BASE);
            this.myPreviewCard.statsState = newState;
            if(this.mComparisonItem != null)
            {
               this.myComparisonCard.statsState = newState;
               hideComparison = newState == ItemPreviewCard.STATS_DUAL_CLASH && this.myComparisonCard.statsState != newState;
               this.myComparisonCard.visible = this.myComparisonLabel.visible = !hideComparison;
            }
         }
      }
      
      private function onStageMouseMoveHandle(cEvt:MouseEvent) : void
      {
         this.setPosition();
      }
      
      public function setPosition() : void
      {
         var mousePoint:Point = new Point(stage.mouseX,stage.mouseY);
         var targetGlobalPos:Point = new Point();
         targetGlobalPos.x = mousePoint.x + PREVIEW_BOX_X_OFFSET;
         if(targetGlobalPos.x + this.width > GameInfo.DEFAULT_WIDTH)
         {
            targetGlobalPos.x = mousePoint.x - PREVIEW_BOX_X_OFFSET - this.width;
         }
         targetGlobalPos.y = mousePoint.y - this.mBoxHeight * 0.5;
         var downStop:Number = GameInfo.DEFAULT_HEIGHT - this.mBoxHeight;
         if(targetGlobalPos.y > downStop)
         {
            targetGlobalPos.y = downStop;
         }
         else if(targetGlobalPos.y < PREVIEW_BOX_TOP_STOP)
         {
            targetGlobalPos.y = PREVIEW_BOX_TOP_STOP;
         }
         var localPos:Point = parent.globalToLocal(targetGlobalPos);
         x = localPos.x;
         y = localPos.y;
      }
      
      public function setItemData(data:ProductObj, comparisonItem:ProductObj = null) : void
      {
         this.mPreviewItem = data;
         this.mComparisonItem = Boolean(comparisonItem) && comparisonItem.id != data.id ? comparisonItem : null;
         if(this.mShowing)
         {
            this.populatePreviewData();
            this.setPosition();
         }
      }
      
      private function setPreviewData() : void
      {
         visible = true;
         this.mShowing = true;
         if(stage.hasEventListener(MouseEvent.MOUSE_MOVE) == false)
         {
            stage.addEventListener(MouseEvent.MOUSE_MOVE,this.onStageMouseMoveHandle);
         }
         parent.setChildIndex(this,parent.numChildren - 1);
         this.populatePreviewData();
         this.setPosition();
      }
      
      private function populatePreviewData() : void
      {
         var comparisonCardHeight:Number = NaN;
         this.myPreviewCard.setData(this.mPreviewItem,this.mComparisonItem);
         this.mBoxHeight = this.myPreviewCard.height;
         this.mBoxWidth = this.myPreviewCard.width;
         this.myComparisonCard.visible = this.myComparisonLabel.visible = this.mComparisonItem != null;
         if(this.myComparisonCard.visible)
         {
            this.myComparisonCard.setData(this.mComparisonItem,null);
            comparisonCardHeight = this.myComparisonCard.height;
            if(comparisonCardHeight > this.mBoxHeight)
            {
               this.mBoxHeight = comparisonCardHeight;
            }
            this.mBoxWidth = this.myComparisonCard.x + this.myComparisonCard.width;
         }
         this.myStatsTimer.reset();
         if(this.myPreviewCard.statsState != ItemPreviewCard.STATS_BASIC)
         {
            this.myStatsTimer.start();
         }
      }
      
      public function showBox() : void
      {
         if(this.mShowing || UITutorialBaseView.isTutorialShowing())
         {
            return;
         }
         TweenLite.to(this,FADE_DURATION,{
            "alpha":1,
            "delay":SHOW_DELAY,
            "onStart":this.setPreviewData
         });
      }
      
      public function hideBox(animated:Boolean = true) : void
      {
         this.mShowing = false;
         this.myStatsTimer.reset();
         var duration:Number = animated ? FADE_DURATION : 0;
         var delay:Number = animated ? HIDE_DELAY : 0;
         TweenLite.killTweensOf(this);
         TweenLite.to(this,duration,{
            "alpha":0,
            "delay":delay,
            "onComplete":this.onHideComplete
         });
      }
      
      private function onHideComplete() : void
      {
         stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onStageMouseMoveHandle);
         this.myPreviewCard.disableData();
         this.myComparisonCard.disableData();
         visible = false;
      }
      
      override public function get width() : Number
      {
         return this.mBoxWidth;
      }
   }
}

