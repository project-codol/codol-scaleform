package scaleform.gfx
{
   import flash.display.Sprite;
   import flash.events.EventDispatcher;
   
   public final class IMEEx extends EventDispatcher
   {
      
      public function IMEEx()
      {
         super();
      }
      
      public static function getIMECandidateListStyle() : IMECandidateListStyle
      {
         return null;
      }
      
      public static function setIMECandidateListStyle(style:IMECandidateListStyle) : void
      {
      }
      
      public static function SendLangBarMessage(mc:Sprite, command:String, message:String) : void
      {
      }
      
      public static function GetOSVersion() : String
      {
         return null;
      }
      
      public static function GetCompositionString() : String
      {
         return null;
      }
   }
}

