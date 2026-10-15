package codo.utils
{
   public class MathUtil
   {
      
      public function MathUtil()
      {
         super();
      }
      
      public static function radianToAngle(cRad:Number) : Number
      {
         return cRad * (180 / Math.PI);
      }
      
      public static function angleToRadian(cAng:Number) : Number
      {
         return cAng * (Math.PI / 180);
      }
      
      public static function roundDecimal(num:Number, precision:int) : Number
      {
         var decimal:Number = Math.pow(10,precision);
         return Math.round(decimal * num) / decimal;
      }
      
      public static function percentValue(value:Number) : String
      {
         return Math.round(value * 100) + "%";
      }
      
      public static function clamp(value:Number, minValue:Number, maxValue:Number) : Number
      {
         if(value < minValue)
         {
            return minValue;
         }
         if(value > maxValue)
         {
            return maxValue;
         }
         return value;
      }
   }
}

