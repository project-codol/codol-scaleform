package components
{
   import codo.utils.StringUtil;
   import flash.text.TextField;
   import shaui.component.core.UIComponent;
   
   public class Clock extends UIComponent
   {
      
      public var mySec_0:TextField;
      
      public var mySec_1:TextField;
      
      public var myMin_0:TextField;
      
      public var myMin_1:TextField;
      
      public var myHour_0:TextField;
      
      public var myHour_1:TextField;
      
      private var _enableHour:Boolean = true;
      
      private var _enableMin:Boolean = true;
      
      private var _currentTime:Number = 0;
      
      public function Clock()
      {
         super();
      }
      
      public function set enableHour(cSwi:Boolean) : void
      {
         this._enableHour = cSwi;
      }
      
      public function set enableMin(cSwi:Boolean) : void
      {
         this._enableMin = cSwi;
      }
      
      public function get time() : Number
      {
         return this._currentTime;
      }
      
      public function set time(cSec:Number) : void
      {
         this._currentTime = cSec;
         var s:String = StringUtil.addZero(Math.floor(cSec % 60));
         var m:String = StringUtil.addZero(Math.floor(cSec % 3600 / 60));
         var h:String = StringUtil.addZero(Math.floor(cSec / 3600));
         this.mySec_0.text = s.substr(1,1);
         this.mySec_1.text = s.substr(0,1);
         if(this._enableMin == true)
         {
            this.myMin_0.text = m.substr(1,1);
            this.myMin_1.text = m.substr(0,1);
         }
         if(this._enableHour == true)
         {
            this.myHour_0.text = h.substr(1,1);
            this.myHour_1.text = h.substr(0,1);
         }
      }
      
      public function set timeStr(cTime:String) : void
      {
         this.mySec_0.text = cTime.substr(7,1);
         this.mySec_1.text = cTime.substr(6,1);
         if(this._enableMin == true)
         {
            this.myMin_0.text = cTime.substr(4,1);
            this.myMin_1.text = cTime.substr(3,1);
         }
         if(this._enableHour == true)
         {
            this.myHour_0.text = cTime.substr(1,1);
            this.myHour_1.text = cTime.substr(0,1);
         }
      }
   }
}

