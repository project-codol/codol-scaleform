package codo.constants
{
   public class CodoVersion
   {
      
      public static const DEFAULT:String = "default";
      
      public static const GAPP:String = "gapp";
      
      public static const ALPHA_1:String = "alpha1";
      
      public static const CE2:String = "ce2";
      
      public static const CE3:String = "ce3";
      
      public static const ALPHA_2:String = "alpha2";
      
      public static const ALPHA_3:String = "alpha3";
      
      public static const GR4:String = "gr4";
      
      public static const CB1:String = "cb1";
      
      public static const CB2:String = "cb2";
      
      public static const CB3:String = "cb3";
      
      public static const CB3CE1:String = "cb3ce1";
      
      private static var _currentVersion:String = DEFAULT;
      
      private static var _currentVersionColumn:int = 0;
      
      public function CodoVersion()
      {
         super();
      }
      
      public static function set currentVersion(cVer:String) : void
      {
         if(cVer.length > 0)
         {
            _currentVersion = cVer;
         }
      }
      
      public static function get currentVersion() : String
      {
         return _currentVersion;
      }
      
      public static function set currentVersionColumn(column:int) : void
      {
         _currentVersionColumn = column;
      }
      
      public static function get currentVersionColumn() : int
      {
         return _currentVersionColumn;
      }
   }
}

