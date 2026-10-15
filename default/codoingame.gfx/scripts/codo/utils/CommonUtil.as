package codo.utils
{
   import codo.common.CFunctionCommonContainer;
   import flash.system.fscommand;
   
   public class CommonUtil
   {
      
      public function CommonUtil()
      {
         super();
      }
      
      public static function quit() : void
      {
         if(ScaleformUtil.isScaleform)
         {
            CFunctionCommonContainer.execnow("quit");
         }
         else
         {
            fscommand("quit");
         }
      }
   }
}

