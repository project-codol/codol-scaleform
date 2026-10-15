package codo.views.wargod_parts
{
   import codo.component.TextField;
   import codo.localization.DictWarGod;
   import codo.style.WarGodGuide;
   import codo.utils.GraphicUtil;
   import flash.display.MovieClip;
   import flash.geom.Point;
   
   public class HeroicValueMeter extends MovieClip
   {
      
      private static const OUTER_SECTOR_COLOR:uint = 7431225;
      
      private static const INNER_SECTOR_COLOR:uint = 13614181;
      
      private static const OUTER_RADIUS:Number = 104.5;
      
      private static const INNER_RADIUS:Number = 96.5;
      
      private static const OUTER_RADIUS_2:Number = 96.5;
      
      private static const INNER_RADIUS_2:Number = 91.5;
      
      private static const INACTIVE_FRAME:int = 1;
      
      private static const ACTIVE_FRAME:int = 2;
      
      public var myLabel:TextField;
      
      public var myValue:TextField;
      
      public var myFg:MovieClip;
      
      public var myBg:MovieClip;
      
      public var myDivider:MovieClip;
      
      private var mCenter:Point;
      
      private var mSafeAngle:Number;
      
      public function HeroicValueMeter()
      {
         super();
         this.myLabel.textStyle = WarGodGuide.styleMeterLabel;
         this.myLabel.width = 91;
         this.myLabel.height = 29;
         this.myValue.textStyle = WarGodGuide.styleMeterValue;
         this.myValue.width = 172;
         this.myValue.height = 50;
         this.myLabel.text = DictWarGod.TOTAL_VALUE;
         this.myValue.text = "0/0";
         this.mCenter = new Point(104.5,104.5);
         this.enabled = true;
      }
      
      public function setData(currentValue:Number, fullValue:Number, hvProtectionValue:Number) : void
      {
         this.mSafeAngle = Math.floor(360 * (hvProtectionValue / fullValue)) - 90;
         var percent:Number = currentValue / fullValue;
         var angle:int = Math.floor(percent * 360);
         this.drawSector(enabled ? angle : 0,-90);
         var fixedValue:String = String(currentValue);
         if(currentValue != 0)
         {
            fixedValue = currentValue.toFixed(0);
         }
         this.myValue.text = fixedValue + "/" + String(fullValue);
      }
      
      override public function set enabled(value:Boolean) : void
      {
         super.enabled = value;
         if(value)
         {
            this.myBg.gotoAndStop(ACTIVE_FRAME);
            this.myLabel.visible = true;
            this.myDivider.visible = true;
            this.myValue.visible = true;
            this.myFg.visible = true;
         }
         else
         {
            this.myBg.gotoAndStop(INACTIVE_FRAME);
            this.myLabel.visible = false;
            this.myDivider.visible = false;
            this.myValue.visible = false;
            this.myFg.visible = false;
         }
      }
      
      private function drawSector(angle:Number, startAngle:Number) : void
      {
         this.myFg.graphics.clear();
         GraphicUtil.drawSector(this.myFg,this.mCenter,OUTER_RADIUS,INNER_RADIUS,angle,startAngle,OUTER_SECTOR_COLOR,alpha);
         GraphicUtil.drawSector(this.myFg,this.mCenter,OUTER_RADIUS_2,INNER_RADIUS_2,angle,startAngle,INNER_SECTOR_COLOR,alpha);
         GraphicUtil.drawSector(this.myFg,this.mCenter,OUTER_RADIUS,INNER_RADIUS_2,4,this.mSafeAngle,4375547,alpha);
      }
   }
}

