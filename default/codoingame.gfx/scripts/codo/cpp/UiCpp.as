package codo.cpp
{
   import codo.common.CFunctionCommonContainer;
   import codo.utils.ScaleformUtil;
   
   public dynamic class UiCpp
   {
      
      public static var CPP_TYPE:uint;
      
      public function UiCpp()
      {
         var uiCppType:uint = 0;
         super();
         if(ScaleformUtil.isScaleform)
         {
            uiCppType = this.GetUiCppType();
            CFunctionCommonContainer.InitUiCpp(this,uiCppType);
         }
      }
      
      public function GetUiCppType() : uint
      {
         return CPP_TYPE;
      }
   }
}

