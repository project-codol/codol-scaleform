package codo.views.hud.shared
{
   import codo.views.hud.HUDComponent;
   import com.greensock.TimelineLite;
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   
   public class CollapsibleRankPanel extends HUDComponent
   {
      
      public var myCollapseHint:MovieClip;
      
      public var myCollapsedHint:MovieClip;
      
      protected var mRankBars:Array;
      
      protected var mCollapsed:Boolean;
      
      protected var mEnabledRankBar:int;
      
      protected var mTimeline:TimelineLite;
      
      protected var mSliceAnimationDuration:Number = 0.08;
      
      protected var mRankBarHeight:Number = 38;
      
      public function CollapsibleRankPanel()
      {
         super();
      }
      
      public function toggleCollapse(animate:Boolean) : void
      {
         var targetScale:Number = NaN;
         animate = true;
         if(this.mTimeline != null && this.mTimeline.active)
         {
            return;
         }
         var i:int = 0;
         if(animate)
         {
            this.mTimeline = new TimelineLite({"onComplete":this.onAnimationDone});
            targetScale = this.mCollapsed ? 1 : 0;
            if(this.mCollapsed)
            {
               for(i = 0; i < this.mEnabledRankBar; i++)
               {
                  this.mRankBars[i].visible = true;
               }
               this.myCollapseHint.visible = true;
               this.mTimeline.append(TweenLite.to(this.myCollapsedHint,this.mSliceAnimationDuration,{"scaleX":1 - targetScale}));
            }
            for(i = 0; i < this.mEnabledRankBar; i++)
            {
               this.mTimeline.append(TweenLite.to(this.mRankBars[i],this.mSliceAnimationDuration,{"scaleX":targetScale}));
            }
            this.mTimeline.append(TweenLite.to(this.myCollapseHint,this.mSliceAnimationDuration,{"scaleX":targetScale}));
            if(!this.mCollapsed)
            {
               this.mTimeline.append(TweenLite.to(this.myCollapsedHint,this.mSliceAnimationDuration,{"scaleX":1 - targetScale}));
            }
         }
         else
         {
            this.ToggleCollapseUnAnimate();
         }
      }
      
      public function onAnimationDone() : void
      {
         if(!this.mCollapsed)
         {
            this.ToggleCollapseUnAnimate();
         }
         else
         {
            this.mCollapsed = false;
         }
         TweenLite.killTweensOf(this.myCollapseHint);
         TweenLite.killTweensOf(this.myCollapsedHint);
         for(var i:int = 0; i < this.mRankBars.length; i++)
         {
            TweenLite.killTweensOf(this.mRankBars[i]);
         }
         this.mTimeline = null;
      }
      
      protected function ToggleCollapseUnAnimate() : void
      {
         var visible:Boolean = false;
         var scale:Number = NaN;
         this.mCollapsed = !this.mCollapsed;
         visible = !this.mCollapsed;
         scale = this.mCollapsed ? 0 : 1;
         for(var i:int = 0; i < this.mEnabledRankBar; i++)
         {
            this.mRankBars[i].visible = visible;
            this.mRankBars[i].scaleX = scale;
         }
         this.myCollapseHint.visible = visible;
         this.myCollapseHint.scaleX = scale;
         this.myCollapsedHint.visible = !visible;
         this.myCollapsedHint.scaleX = 1 - scale;
      }
      
      public function setEnabledRanks(num:int) : void
      {
         if(num == this.mEnabledRankBar)
         {
            return;
         }
         var index:int = 0;
         if(!this.mCollapsed)
         {
            for(index = 0; index < num; index++)
            {
               this.mRankBars[index].visible = true;
               this.mRankBars[index].scaleX = 1;
            }
            for(index = num; index < this.mRankBars.length; index++)
            {
               this.mRankBars[index].visible = false;
            }
         }
         var hintOffset:Number = 0;
         if(num > 0)
         {
            hintOffset = this.mRankBars[num - 1].y + this.mRankBarHeight;
         }
         this.myCollapseHint.y = hintOffset;
         this.mEnabledRankBar = num;
      }
   }
}

