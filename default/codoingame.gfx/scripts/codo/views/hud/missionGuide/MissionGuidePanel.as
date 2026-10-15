package codo.views.hud.missionGuide
{
   import codo.constants.HUDComponentTypes;
   import codo.views.hud.HUDComponent;
   import com.greensock.TimelineLite;
   import com.greensock.TweenLite;
   
   public class MissionGuidePanel extends HUDComponent
   {
      
      private static var ANCHOR:Number = 52;
      
      public var myMission1:MissionGuide;
      
      public var myMission2:MissionGuide;
      
      private var mCurrentMission:MissionGuide = null;
      
      private var mTimeline:TimelineLite;
      
      public function MissionGuidePanel()
      {
         super();
         this.myMission1.visible = this.myMission2.visible = false;
      }
      
      override public function get CompType() : int
      {
         return HUDComponentTypes.MISSION_GUIDE;
      }
      
      public function onAnimationComplete(nextMission:MissionGuide) : void
      {
         if(this.mCurrentMission != null)
         {
            this.mCurrentMission.visible = false;
            this.mCurrentMission.alpha = 1;
            this.mCurrentMission.myDeleteLine.visible = false;
            this.mCurrentMission.myCorner.visible = true;
         }
         this.mCurrentMission = nextMission;
         if(this.mCurrentMission != null)
         {
            this.mCurrentMission.Blink();
         }
      }
      
      public function setMissionGuide(missionGuide:String) : void
      {
         var myNextMission:MissionGuide = null;
         if(this.mTimeline != null)
         {
            this.mTimeline.complete();
            this.mTimeline = null;
         }
         myNextMission = null;
         if(missionGuide.length > 0)
         {
            if(this.mCurrentMission == this.myMission1)
            {
               myNextMission = this.myMission2;
            }
            else
            {
               myNextMission = this.myMission1;
            }
            myNextMission.setMissionGuide(missionGuide);
            myNextMission.visible = true;
            myNextMission.x = -myNextMission.width;
            myNextMission.y = this.mCurrentMission == null ? 0 : ANCHOR;
         }
         this.mTimeline = new TimelineLite({
            "onComplete":this.onAnimationComplete,
            "onCompleteParams":[myNextMission]
         });
         if(this.mCurrentMission != null)
         {
            this.mCurrentMission.myDeleteLine.visible = true;
            this.mCurrentMission.myDeleteLine.scaleX = 0;
            this.mCurrentMission.myCorner.visible = false;
         }
         if(myNextMission != null)
         {
            this.mTimeline.append(TweenLite.to(myNextMission,0.25,{"x":0}));
         }
         if(this.mCurrentMission != null)
         {
            this.mTimeline.append(TweenLite.to(this.mCurrentMission.myDeleteLine,0.5,{"scaleX":1}));
            this.mTimeline.append(TweenLite.to(this.mCurrentMission,0.25,{"scaleX":1}));
            this.mTimeline.append(TweenLite.to(this.mCurrentMission,0.25,{"alpha":0}));
            if(myNextMission != null)
            {
               this.mTimeline.append(TweenLite.to(myNextMission,0.25,{"y":0}));
            }
         }
         else if(myNextMission != null)
         {
            this.mTimeline.append(TweenLite.to(myNextMission,0.25,{"x":0}));
         }
         this.mTimeline.play();
      }
   }
}

