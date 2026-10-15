package codo.objects
{
   public dynamic class RemainDateObj
   {
      
      private var _day:uint = 0;
      
      private var _hour:uint = 0;
      
      private var _minute:uint = 0;
      
      private var _second:uint = 0;
      
      public function RemainDateObj(cDay:uint, cHour:uint, cMinute:uint, cSecond:uint)
      {
         super();
         this._day = cDay;
         this._hour = cHour;
         this._minute = cMinute;
         this._second = cSecond;
      }
      
      public function get day() : uint
      {
         return this._day;
      }
      
      public function set day(value:uint) : void
      {
         this._day = value;
      }
      
      public function get hour() : uint
      {
         return this._hour;
      }
      
      public function set hour(value:uint) : void
      {
         this._hour = value;
      }
      
      public function get minute() : uint
      {
         return this._minute;
      }
      
      public function set minute(value:uint) : void
      {
         this._minute = value;
      }
      
      public function get second() : uint
      {
         return this._second;
      }
      
      public function set second(value:uint) : void
      {
         this._second = value;
      }
   }
}

