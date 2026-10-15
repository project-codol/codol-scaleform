package ime
{
   import codo.event.ParaEvent;
   import flash.display.Sprite;
   import scaleform.gfx.IMEEx;
   
   public class StatusWindowCH extends Sprite
   {
      
      public var InputMode_mc:CStatusWindowCh;
      
      public var Shape_mc:CStatusWindowCh;
      
      public var Symbol_mc:CStatusWindowCh;
      
      private var toggleSymbol:Boolean = false;
      
      private var toggleShape:Boolean = false;
      
      private var toggleInputMode:Boolean = false;
      
      public function StatusWindowCH()
      {
         super();
         this.onInitListener();
      }
      
      private function onInitListener() : void
      {
         this.InputMode_mc.addEventListener(CStatusWindowCh.EVT_CLICK,this.onStatusBtnClickHandle);
         this.Shape_mc.addEventListener(CStatusWindowCh.EVT_CLICK,this.onStatusBtnClickHandle);
         this.Symbol_mc.addEventListener(CStatusWindowCh.EVT_CLICK,this.onStatusBtnClickHandle);
      }
      
      private function onStatusBtnClickHandle(cEvt:ParaEvent) : void
      {
         switch(cEvt.myPara.target)
         {
            case this.Shape_mc:
               IMEEx.SendLangBarMessage(this,"StatusWindow_OnShape",this.toggleShape == true ? "true" : "false");
               break;
            case this.InputMode_mc:
               IMEEx.SendLangBarMessage(this,"StatusWindow_OnInputMode",this.toggleInputMode == true ? "true" : "false");
               break;
            case this.Symbol_mc:
               IMEEx.SendLangBarMessage(this,"StatusWindow_OnSymbol",this.toggleSymbol == true ? "true" : "false");
         }
      }
      
      public function show() : void
      {
         this.InputMode_mc.visible = true;
         this.Shape_mc.visible = true;
         this.Symbol_mc.visible = true;
      }
      
      public function hide() : void
      {
         this.InputMode_mc.visible = false;
         this.Shape_mc.visible = false;
         this.Symbol_mc.visible = false;
      }
      
      public function SetSymbolMode(mode:String) : void
      {
         var tempToggle:Boolean = false;
         if(mode == "full")
         {
            tempToggle = false;
         }
         else if(mode == "half")
         {
            tempToggle = true;
         }
         if(this.Symbol_mc != null)
         {
            this.Symbol_mc.SetSymbolMode(tempToggle);
         }
      }
      
      public function SetShapeMode(mode:String) : void
      {
         var tempToggle:Boolean = false;
         if(mode == "full")
         {
            tempToggle = false;
         }
         else if(mode == "half")
         {
            tempToggle = true;
         }
         if(this.Shape_mc != null)
         {
            this.Shape_mc.SetShapeMode(tempToggle);
         }
      }
      
      public function SetInputMode(mode:String) : void
      {
         var tempToggle:Boolean = false;
         if(mode == "Native")
         {
            tempToggle = false;
         }
         else if(mode == "Alphanumeric")
         {
            tempToggle = true;
         }
         this.toggleInputMode = tempToggle;
         if(this.InputMode_mc != null)
         {
            this.InputMode_mc.SetInputMode(this.toggleInputMode);
         }
      }
      
      public function SetBackgroundColor(color1:Number, color2:Number) : void
      {
         if(this.InputMode_mc != null)
         {
            this.InputMode_mc.SetBackgroundColor(color1,color2);
         }
         if(this.Shape_mc != null)
         {
            this.Shape_mc.SetBackgroundColor(color1,color2);
         }
         if(this.Symbol_mc != null)
         {
            this.Symbol_mc.SetBackgroundColor(color1,color2);
         }
      }
      
      public function SetTextColor(color1:Number, color2:Number) : void
      {
         if(this.InputMode_mc != null)
         {
            this.InputMode_mc.SetTextColor(color1,color2);
         }
         if(this.Shape_mc != null)
         {
            this.Shape_mc.SetTextColor(color1,color2);
         }
         if(this.Symbol_mc != null)
         {
            this.Symbol_mc.SetTextColor(color1,color2);
         }
      }
      
      public function DisplayStatusWindow(BGColor:Number, BGColorOnover:Number, TextColor:Number, TextColorSelected:Number) : void
      {
      }
   }
}

