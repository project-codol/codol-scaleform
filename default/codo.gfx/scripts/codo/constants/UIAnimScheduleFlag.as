package codo.constants
{
   public class UIAnimScheduleFlag
   {
      
      public static const NO_BLEND_IN:uint = 1 << 0;
      
      public static const NO_BLEND_OUT:uint = 1 << 1;
      
      public static const NO_BLENDING:uint = NO_BLEND_IN | NO_BLEND_OUT;
      
      public static const PLAY_AFTER_CURRENT:uint = 1 << 2;
      
      public static const WAIT_FOR_IDLE:uint = 1 << 3;
      
      public static const ONLY_BLEND_IN_FROM_IDLE:uint = 1 << 4;
      
      public static const LOOP:uint = 1 << 5;
      
      public function UIAnimScheduleFlag()
      {
         super();
      }
   }
}

