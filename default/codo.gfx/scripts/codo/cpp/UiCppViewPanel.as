package codo.cpp
{
   import codo.component.ViewPanelBase;
   
   public dynamic class UiCppViewPanel extends UiCppView
   {
      
      public static var CPP_TYPE:uint;
      
      private var _panel:ViewPanelBase;
      
      public function UiCppViewPanel(panel:ViewPanelBase)
      {
         super();
         this._panel = panel;
      }
      
      public function CPP_ShowViewPanel() : void
      {
         this._panel.showPanel();
      }
      
      public function CPP_HideViewPanel() : void
      {
         this._panel.hidePanel();
      }
      
      override public function GetUiCppType() : uint
      {
         return CPP_TYPE;
      }
   }
}

