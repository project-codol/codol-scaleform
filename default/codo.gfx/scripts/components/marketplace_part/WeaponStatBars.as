package components.marketplace_part
{
   import codo.component.SliderBar;
   import codo.component.TextField;
   import codo.objects.ProductObj;
   import codo.objects.WeaponStatsObj;
   import codo.style.GlobalGuide;
   import codo.style.TextStyle;
   import codo.utils.ScaleformUtil;
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   
   public class WeaponStatBars extends MovieClip
   {
      
      public static const LEFT_SIDE:int = 0;
      
      public static const RIGHT_SIDE:int = 1;
      
      private static const COUNT_DURATION:Number = 0.4;
      
      private static const BAR_WIDTH:Number = 112;
      
      private static const BAR_HEIGHT:Number = 18;
      
      public var myStat0:SliderBar;
      
      public var myStat1:SliderBar;
      
      public var myStat2:SliderBar;
      
      public var myStat3:SliderBar;
      
      public var myStat4:SliderBar;
      
      public var myStat5:SliderBar;
      
      public var myStatLabel0:TextField;
      
      public var myStatLabel1:TextField;
      
      public var myStatLabel2:TextField;
      
      public var myStatLabel3:TextField;
      
      public var myStatLabel4:TextField;
      
      public var myStatLabel5:TextField;
      
      private var mSliderBars:Vector.<SliderBar>;
      
      private var mLabels:Vector.<TextField>;
      
      private var mLabelValues:Vector.<Number>;
      
      private var mLabelValueCounter:Object;
      
      public function WeaponStatBars()
      {
         super();
         this.mSliderBars = new <SliderBar>[this.myStat0,this.myStat1,this.myStat2,this.myStat3,this.myStat4,this.myStat5];
         this.mLabels = new <TextField>[this.myStatLabel0,this.myStatLabel1,this.myStatLabel2,this.myStatLabel3,this.myStatLabel4,this.myStatLabel5];
         if(ScaleformUtil.isScaleform)
         {
            this.onResetValues();
         }
         else
         {
            this.myStat0.fillPercent = 0.2;
            this.myStatLabel0.text = "20";
            this.myStat1.fillPercent = 0.3;
            this.myStatLabel1.text = "30";
            this.myStat2.fillPercent = 0.6;
            this.myStatLabel2.text = "60";
            this.myStat3.fillPercent = 0.4;
            this.myStatLabel3.text = "40";
            this.myStat4.fillPercent = 0.9;
            this.myStatLabel4.text = "90";
            this.myStat5.fillPercent = 0.1;
            this.myStatLabel5.text = "10";
         }
      }
      
      private static function PercentToFraction(nPercent:Number) : Number
      {
         return nPercent / 100;
      }
      
      public function init(orientation:int) : void
      {
         var bar:SliderBar = null;
         var label:TextField = null;
         var labelStyle:TextStyle = new TextStyle();
         labelStyle.font = GlobalGuide.FONT_FACE_NUMBERS;
         labelStyle.fontSize = GlobalGuide.FONT_SIZE_MEDIUM;
         if(orientation == LEFT_SIDE)
         {
            labelStyle.alignment = TextStyle.HALIGN_RIGHT;
         }
         var len:int = int(this.mSliderBars.length);
         for(var i:int = 0; i < len; i++)
         {
            bar = this.mSliderBars[i];
            label = this.mLabels[i];
            bar.width = BAR_WIDTH;
            bar.height = BAR_HEIGHT;
            label.textStyle = labelStyle;
         }
      }
      
      public function setData(itemData:ProductObj) : void
      {
         this.onResetValues();
         this.mLabelValues = new Vector.<Number>();
         var stats:WeaponStatsObj = new WeaponStatsObj(itemData);
         for(var i:uint = 0; i < stats.basicStats.length; i++)
         {
            this.setStatName(i,stats.basicStats[i].name);
            this.setStatValue(i,stats.basicStats[i].base);
         }
      }
      
      public function onResetValues() : void
      {
         var forEachFunc:Function = function(statInfo:SliderBar, index:uint, vec:Vector.<SliderBar>):void
         {
            statInfo.fillPercent = 0;
         };
         var forEachLabelFunc:Function = function(label:TextField, index:uint, vec:Vector.<TextField>):void
         {
            label.text = "0";
         };
         this.mSliderBars.forEach(forEachFunc);
         this.mLabels.forEach(forEachLabelFunc);
      }
      
      public function setStatName(uIndex:uint, sName:String) : void
      {
         var statInfo:MovieClip = this.mSliderBars[uIndex];
         if(Boolean(statInfo.myTextTF))
         {
            statInfo.myTextTF.text = sName;
         }
      }
      
      public function setStatValue(uIndex:uint, nStatValue:Number) : void
      {
         var sliderBar:SliderBar = this.mSliderBars[uIndex];
         sliderBar.fillPercent = PercentToFraction(nStatValue);
         var label:TextField = this.mLabels[uIndex];
         this.mLabelValues[uIndex] = nStatValue;
         label.text = "0";
         sliderBar.prepareForShow();
      }
      
      public function getStatValue(uIndex:uint) : Number
      {
         return this.mSliderBars[uIndex].fillPercent;
      }
      
      public function setStatCompareValue(uIndex:uint, highest:Boolean) : void
      {
         var sliderBar:SliderBar = this.mSliderBars[uIndex];
         var stat:TextField = this.mLabels[uIndex];
         if(true == highest)
         {
            sliderBar.resetFillColor();
            stat.fontColor = GlobalGuide.CODO_BLUE_LIGHT;
         }
         else
         {
            sliderBar.fillColor = GlobalGuide.WHITE;
            stat.fontColor = GlobalGuide.WHITE;
         }
      }
      
      public function startAnimation() : void
      {
         this.mLabelValueCounter = new Object();
         this.mLabelValueCounter.stat0 = 0;
         this.mLabelValueCounter.stat1 = 0;
         this.mLabelValueCounter.stat2 = 0;
         this.mLabelValueCounter.stat3 = 0;
         this.mLabelValueCounter.stat4 = 0;
         this.mLabelValueCounter.stat5 = 0;
         TweenLite.to(this.mLabelValueCounter,COUNT_DURATION,{
            "stat0":this.mLabelValues[0],
            "onUpdate":this.onCounterUpdate,
            "onUpdateParams":[0],
            "delay":0
         });
         TweenLite.to(this.mLabelValueCounter,COUNT_DURATION,{
            "stat1":this.mLabelValues[1],
            "onUpdate":this.onCounterUpdate,
            "onUpdateParams":[1],
            "delay":0.1
         });
         TweenLite.to(this.mLabelValueCounter,COUNT_DURATION,{
            "stat2":this.mLabelValues[2],
            "onUpdate":this.onCounterUpdate,
            "onUpdateParams":[2],
            "delay":0.2
         });
         TweenLite.to(this.mLabelValueCounter,COUNT_DURATION,{
            "stat3":this.mLabelValues[3],
            "onUpdate":this.onCounterUpdate,
            "onUpdateParams":[3],
            "delay":0.3
         });
         TweenLite.to(this.mLabelValueCounter,COUNT_DURATION,{
            "stat4":this.mLabelValues[4],
            "onUpdate":this.onCounterUpdate,
            "onUpdateParams":[4],
            "delay":0.4
         });
         TweenLite.to(this.mLabelValueCounter,COUNT_DURATION,{
            "stat5":this.mLabelValues[5],
            "onUpdate":this.onCounterUpdate,
            "onUpdateParams":[5],
            "delay":0.5
         });
         this.myStat0.show(0);
         this.myStat1.show(0.1);
         this.myStat2.show(0.2);
         this.myStat3.show(0.3);
         this.myStat4.show(0.4);
         this.myStat5.show(0.5);
      }
      
      private function onCounterUpdate(... args) : void
      {
         var idx:Number = Number(args[0]);
         this.mLabels[idx].text = Math.floor(this.mLabelValueCounter["stat" + idx]).toString();
      }
   }
}

