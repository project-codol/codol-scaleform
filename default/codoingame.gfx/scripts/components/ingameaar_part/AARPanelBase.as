package components.ingameaar_part
{
   import components.list_part.ListHeader;
   import flash.text.TextFieldAutoSize;
   import shaui.component.core.UIComponent;
   
   public class AARPanelBase extends UIComponent
   {
      
      public var myHeader:ListHeader;
      
      public function AARPanelBase()
      {
         super();
         if(Boolean(this.myHeader.deco_line))
         {
            this.myHeader.deco_line.width = this.myHeader.x;
         }
         this.myHeader.bar_deco.width = this.IsCyborgsAsset() ? 129 : 121;
         this.myHeader.txt_header.autoSize = TextFieldAutoSize.RIGHT;
      }
      
      protected function SetHeader(txt:String) : void
      {
         this.myHeader.txt_header.text = txt;
      }
      
      protected function IsCyborgsAsset() : Boolean
      {
         return this.toString().indexOf("Cyborg") >= 0;
      }
   }
}

