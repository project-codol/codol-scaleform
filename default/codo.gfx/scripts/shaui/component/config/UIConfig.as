package shaui.component.config
{
   import scaleform.gfx.Extensions;
   
   public class UIConfig
   {
      
      public function UIConfig()
      {
         super();
      }
      
      public static function get isScaleform() : Boolean
      {
         return Extensions.isScaleform;
      }
   }
}

