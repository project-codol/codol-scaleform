package codo.component.onboarding
{
   import com.greensock.TweenLite;
   import flash.display.Sprite;
   import flash.text.TextField;
   
   public class CharacterSelectModuleStat extends Sprite
   {
      
      private static const COUNT_DURATION:Number = 0.2;
      
      public var myStatTF:TextField;
      
      public var myLabelTF:TextField;
      
      private var mLabel:String;
      
      private var mStat:uint;
      
      public var mStatCounter:uint;
      
      public function CharacterSelectModuleStat()
      {
         super();
      }
      
      public function configStat(label:String, value:uint) : void
      {
         this.mStat = value;
         this.mLabel = label;
         this.myLabelTF.text = label;
      }
      
      public function get statWidth() : uint
      {
         var tmpField:TextField = null;
         tmpField = new TextField();
         tmpField.alpha = 0;
         addChild(tmpField);
         tmpField.text = this.mStat.toString();
         var valueWidth:Number = tmpField.textWidth;
         tmpField.text = this.mLabel;
         var labelWidth:Number = tmpField.textWidth;
         removeChild(tmpField);
         return Math.max(labelWidth,valueWidth);
      }
      
      public function prepareForAnimateFromZero() : void
      {
         this.mStatCounter = 0;
         this.onCounterUpdate();
      }
      
      public function startAnimateFromZero(delay:Number = 0) : void
      {
         TweenLite.to(this,COUNT_DURATION,{
            "mStatCounter":this.mStat,
            "onUpdate":this.onCounterUpdate,
            "delay":delay
         });
      }
      
      public function skipAnimation() : void
      {
         this.myStatTF.text = this.mStat.toString();
      }
      
      private function onCounterUpdate() : void
      {
         this.myStatTF.text = this.mStatCounter.toString();
      }
   }
}

