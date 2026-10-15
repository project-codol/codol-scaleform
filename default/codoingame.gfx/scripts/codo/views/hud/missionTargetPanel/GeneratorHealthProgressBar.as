package codo.views.hud.missionTargetPanel
{
   import components.hud.CircleProgressBar;
   import flash.display.MovieClip;
   
   public class GeneratorHealthProgressBar extends CircleProgressBar
   {
      
      public static const FILL_BAR_STYLE_NORMAL:int = 1;
      
      public static const FILL_BAR_STYLE_SECTION:int = 2;
      
      private static const PROGRESS_PER_SECTION:Number = 1 / 8;
      
      public var myDynamicBG:MovieClip;
      
      public var mySectionFill:MovieClip;
      
      public var mySectionMask:MovieClip;
      
      public function GeneratorHealthProgressBar()
      {
         super();
         this.myDynamicBG.gotoAndPlay(2);
         this.myDynamicBG.visible = false;
         this.setFillBarStyle(FILL_BAR_STYLE_NORMAL);
      }
      
      public function setFillBarStyle(style:int) : void
      {
         myFill.gotoAndStop(style);
         this.mySectionFill.visible = style == FILL_BAR_STYLE_SECTION;
      }
      
      override protected function doSetProgress(progress:Number, oldProgress:Number, animated:Boolean) : void
      {
         super.doSetProgress(progress,oldProgress,animated);
         if(animated && progress < oldProgress)
         {
            this.myDynamicBG.visible = true;
         }
      }
      
      override public function set maskFill(progress:Number) : void
      {
         var sectionProgress:Number = NaN;
         if(this.mySectionFill.visible)
         {
            this.mySectionFill.alpha = myFill.alpha = progress <= 0 ? 0 : 1;
            if(progress == maskFill)
            {
               return;
            }
            sectionProgress = Math.floor(maskFill / PROGRESS_PER_SECTION) * PROGRESS_PER_SECTION;
            this.mySectionMask = setFillProgressMask(this.mySectionFill,this.mySectionMask,sectionProgress);
            myMask = setFillProgressMask(myFill,myMask,progress - sectionProgress,SECTOR_START_OFFSET + sectionProgress * 360);
            mMaskFill = progress;
         }
         else
         {
            super.maskFill = progress;
         }
      }
      
      override public function onAnimateComplete() : void
      {
         super.onAnimateComplete();
         this.myDynamicBG.visible = false;
      }
   }
}

