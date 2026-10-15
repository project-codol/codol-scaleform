package codo.views.supplyDrop_parts
{
   import codo.base.BaseSubElement;
   import codo.component.TextField;
   import codo.style.SupplyDropGuide;
   import codo.utils.ScaleformUtil;
   import flash.display.Sprite;
   
   public class SupplyDropBasePanel extends BaseSubElement
   {
      
      public var myHeaderTF:TextField;
      
      public var myBkg:Sprite;
      
      public function SupplyDropBasePanel()
      {
         super();
         this.myHeaderTF.textStyle = SupplyDropGuide.styleSupplyDropHeader;
      }
      
      protected function setPanelHeader(headerTxt:String) : void
      {
         this.myHeaderTF.text = headerTxt;
      }
      
      protected function get inDebugMode() : Boolean
      {
         return !ScaleformUtil.isScaleform;
      }
   }
}

