package codo.cpp
{
   public dynamic class UiCppView extends UiCpp
   {
      
      public static var CPP_TYPE:uint;
      
      public function UiCppView()
      {
         super();
      }
      
      override public function GetUiCppType() : uint
      {
         return CPP_TYPE;
      }
      
      public function OnInit() : void
      {
         this["AS_OnInit"]();
      }
      
      public function ShowView() : void
      {
         this["AS_ShowView"]();
      }
      
      public function HideView() : void
      {
         this["AS_HideView"]();
      }
   }
}

