package codo.views.hud.bossHealthBar
{
   import codo.constants.HUDComponentTypes;
   import codo.views.hud.HUDComponent;
   import com.greensock.TimelineLite;
   import com.greensock.TweenLite;
   import components.hud.StageProgressBar;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import fsg.util.FsgImageHolder;
   
   public class BossHealthBar extends HUDComponent
   {
      
      private static const ICON_PADDING:int = 5;
      
      private static const ICON_WIDTH:int = 56;
      
      private static const ANIMATION_DURATION:int = 0.1;
      
      private static const BOSS_HELATH_STAGE_NUM:int = 3;
      
      public var myWeakpoint1:FsgImageHolder;
      
      public var myWeakpoint2:FsgImageHolder;
      
      public var myWeakpoint3:FsgImageHolder;
      
      public var myHealth:StageProgressBar;
      
      private var mWeakpoints:Array;
      
      private var mWeakpointsCount:int;
      
      private var mTimeline:TimelineLite;
      
      private var mStageMarks:Array;
      
      public function BossHealthBar()
      {
         var mark:DisplayObject = null;
         super();
         this.mTimeline = new TimelineLite();
         this.mWeakpoints = [this.myWeakpoint1,this.myWeakpoint2,this.myWeakpoint3];
         this.resetWeakpoints();
         this.mStageMarks = new Array();
         for(var i:int = 0; true; i++)
         {
            mark = getChildByName("myStage".concat(i));
            if(mark == null)
            {
               break;
            }
            this.mStageMarks.push(mark);
         }
         this.myHealth.OnStageChangedCallback = this.onHPBarStageChanged;
         this.myHealth.StageNumber = BOSS_HELATH_STAGE_NUM;
      }
      
      override public function get CompType() : int
      {
         return HUDComponentTypes.BOSSHEALTH_BAR;
      }
      
      public function resetWeakpoints() : void
      {
         if(this.mTimeline.active)
         {
            this.mTimeline.complete();
         }
         for(var i:int = 0; i < this.mWeakpoints.length; i++)
         {
            this.mWeakpoints[i].visible = false;
         }
         this.mWeakpointsCount = 0;
      }
      
      public function showWeakpoint(image:String) : void
      {
         var totalWidth:int = 0;
         var iconStartX:int = 0;
         var i:int = 0;
         var newX:int = 0;
         if(this.mWeakpointsCount < this.mWeakpoints.length)
         {
            if(this.mTimeline.active)
            {
               this.mTimeline.complete();
            }
            this.mWeakpoints[this.mWeakpointsCount].visible = true;
            this.mWeakpoints[this.mWeakpointsCount].alpha = 0;
            this.mWeakpoints[this.mWeakpointsCount].setImage(image);
            ++this.mWeakpointsCount;
            totalWidth = this.mWeakpointsCount * ICON_WIDTH + (this.mWeakpointsCount - 1) * ICON_PADDING;
            iconStartX = (this.width - totalWidth) / 2;
            for(i = 0; i < this.mWeakpointsCount; i++)
            {
               newX = iconStartX + i * (ICON_PADDING + ICON_WIDTH);
               if(i != this.mWeakpointsCount - 1)
               {
                  this.mTimeline.append(TweenLite.to(this.mWeakpoints[i],ANIMATION_DURATION,{"x":newX}));
               }
               else
               {
                  this.mWeakpoints[i].x = newX;
                  this.mTimeline.append(TweenLite.to(this.mWeakpoints[i],ANIMATION_DURATION,{"alpha":1}));
               }
            }
            this.mTimeline.play();
         }
      }
      
      private function onHPBarStageChanged(oldStage:int, newStage:int) : void
      {
         var i:int = 0;
         var mark:MovieClip = null;
         if(newStage >= 0 && newStage < BOSS_HELATH_STAGE_NUM)
         {
            this.myHealth.myBG.gotoAndStop(BOSS_HELATH_STAGE_NUM - newStage);
            this.myHealth.myFill.gotoAndStop(BOSS_HELATH_STAGE_NUM - newStage);
            for(i = 0; i < this.mStageMarks.length; i++)
            {
               mark = this.mStageMarks[i] as MovieClip;
               if(i <= newStage)
               {
                  mark.gotoAndStop(i + 1);
               }
               else
               {
                  mark.gotoAndStop(4);
               }
            }
         }
      }
   }
}

