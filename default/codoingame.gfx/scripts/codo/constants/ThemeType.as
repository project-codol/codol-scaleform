package codo.constants
{
   import codo.style.GlobalGuide;
   
   public class ThemeType
   {
      
      public static const CODO:uint = 0;
      
      public static const ESPORTS:uint = 1;
      
      public static const SDP:uint = 2;
      
      public static const DYSTOPIC:uint = 3;
      
      public static const ESPORTS_COLOR:uint = 16768674;
      
      public static const SDP_COLOR:uint = 855309;
      
      public static const DYSTOPIC_COLOR:uint = 15777635;
      
      public static const THEME_COLORS:Array = [GlobalGuide.CODO_BLUE_HIGHLIGHT,ESPORTS_COLOR,SDP_COLOR,DYSTOPIC_COLOR];
      
      public function ThemeType()
      {
         super();
      }
   }
}

