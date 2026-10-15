package codo.views.wargodMatchResult_parts
{
   import codo.views.wargod_parts.HeroicValueMeter;
   import com.greensock.TimelineLite;
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   import fsg.util.FsgAudioUtil;
   
   public class HeroicValueMeterAnimation extends WarGodAnimateElement
   {
      
      public var myHeroicGlow:MovieClip;
      
      public var myHeroicValue:HeroicValueMeter;
      
      private var mStartValue:Number;
      
      private var mEndValue:Number;
      
      private var mFullValue:Number;
      
      private var mFullValue2:Number;
      
      private var mProtectionValue:Number;
      
      private var mProtectionValue2:Number;
      
      private var mTweenLite:TweenLite;
      
      public function HeroicValueMeterAnimation()
      {
         super();
      }
      
      public function setData(startValue:Number, endValue:Number, fullValue:Number, fullValue2:Number, hvProtectionValue:Number, hvProtectionValue2:Number) : void
      {
         this.mStartValue = startValue;
         this.mEndValue = endValue;
         this.mFullValue = fullValue;
         this.mFullValue2 = fullValue2;
         this.mProtectionValue = hvProtectionValue;
         this.mProtectionValue2 = hvProtectionValue2;
         this.myHeroicValue.setData(this.mStartValue,this.mFullValue,this.mProtectionValue);
      }
      
      override public function startAni() : void
      {
         super.startAni();
         this.myHeroicValue.gotoAndPlay(1);
         var timeline:TimelineLite = new TimelineLite();
         timeline.append(TweenLite.to(this,0.5,{}));
         this.mTweenLite = TweenLite.to(this,1,{
            "onUpdate":this.onMeterUpdate,
            "onComplete":this.onMeterComplete
         });
         timeline.append(this.mTweenLite);
      }
      
      private function onMeterUpdate() : void
      {
         var percent:Number = this.mTweenLite.currentTime / this.mTweenLite.duration;
         var curValue:Number = this.mStartValue + percent * (this.mEndValue - this.mStartValue);
         this.myHeroicValue.setData(curValue,this.mFullValue,this.mProtectionValue);
         FsgAudioUtil.getInstance().playSound("ui_star_match_counter");
      }
      
      private function onMeterComplete() : void
      {
         if(this.mEndValue == this.mFullValue)
         {
            this.myHeroicGlow.gotoAndPlay(1);
            this.myHeroicValue.setData(0,this.mFullValue2,this.mProtectionValue2);
         }
         complete();
      }
   }
}

