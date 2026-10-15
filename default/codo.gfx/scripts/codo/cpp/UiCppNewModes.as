package codo.cpp
{
   import codo.common.CFunctionCommonContainer;
   
   public dynamic class UiCppNewModes extends UiCpp
   {
      
      private static var _instance:UiCppNewModes;
      
      public static var CPP_TYPE:uint;
      
      public function UiCppNewModes()
      {
         super();
         CFunctionCommonContainer.Assert(_instance == null,new Error("Multiple UiCppNewModes instances"));
         _instance = this;
      }
      
      public static function get instance() : UiCppNewModes
      {
         return _instance;
      }
      
      override public function GetUiCppType() : uint
      {
         return CPP_TYPE;
      }
   }
}

