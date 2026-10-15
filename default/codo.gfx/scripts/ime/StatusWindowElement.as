package ime
{
   import flash.display.Sprite;
   import flash.utils.getDefinitionByName;
   import scaleform.gfx.IMEEventEx;
   import scaleform.gfx.IMEEx;
   
   public class StatusWindowElement extends Sprite
   {
      
      public var ActiveLanguage:String;
      
      public var InitLanguage:String;
      
      public var InputMode:String;
      
      public var SymbolMode:String;
      
      public var ShapeMode:String;
      
      public var VisibleState:Boolean = true;
      
      public var myStatusWindowCH:StatusWindowCH;
      
      public var IsStatusWindow:Boolean = true;
      
      public function StatusWindowElement()
      {
         super();
         this.addEventListener(IMEEventEx.SET_CURRENT_LANGUAGE,this.onSwitchLanguage);
         this.addEventListener(IMEEventEx.REMOVE_STATUS_WINDOW,this.onRemoveStatusWindow);
         this.addEventListener(IMEEventEx.DISPLAY_STATUS_WINDOW,this.onDisplayStatusWindow);
         this.addEventListener(IMEEventEx.SET_CONVERSION_STATUS,this.onSetConversionStatus);
         this.LoadStatusWindow("Chinese (Simplified)");
      }
      
      public function onRemoveStatusWindow(ev:IMEEventEx) : void
      {
         this.RemoveStatusWindow();
      }
      
      public function onDisplayStatusWindow(ev:IMEEventEx) : void
      {
         if(this.ActiveLanguage == "Chinese (Simplified)")
         {
            this.myStatusWindowCH.SetInputMode(this.InputMode);
            this.myStatusWindowCH.SetSymbolMode(this.SymbolMode);
            this.myStatusWindowCH.SetShapeMode(this.ShapeMode);
            this.myStatusWindowCH.show();
         }
      }
      
      public function onSetConversionStatus(ev:IMEEventEx) : void
      {
         var conversionStatus:String = ev.message;
         if(conversionStatus == null)
         {
            return;
         }
         var conversionModeValues:Array = conversionStatus.split(",");
         var numArgs:int = conversionModeValues.length - 1;
         if(numArgs == 1)
         {
            this.SetInputMode(conversionModeValues[0]);
         }
         if(numArgs == 2)
         {
            this.SetInputMode(conversionModeValues[0]);
            this.SetShapeMode(conversionModeValues[1]);
         }
         if(numArgs == 3)
         {
            this.SetInputMode(conversionModeValues[0]);
            this.SetShapeMode(conversionModeValues[1]);
            this.SetSymbolMode(conversionModeValues[2]);
         }
      }
      
      public function onSwitchLanguage(ev:IMEEventEx) : void
      {
         this.SetActiveController(ev.message);
      }
      
      public function SetBackgroundColor(color1:Number, color2:Number) : void
      {
      }
      
      public function SetTextColor(color1:Number, color2:Number) : void
      {
         if(this.myStatusWindowCH != null)
         {
            this.myStatusWindowCH.SetTextColor(color1,color2);
         }
      }
      
      public function LoadStatusWindow(initLanguage:String) : void
      {
         this.InitLanguage = initLanguage;
         var tempCls:Class = getDefinitionByName("statusWindowCH") as Class;
         this.myStatusWindowCH = new tempCls();
         this.addChild(this.myStatusWindowCH);
         this.myStatusWindowCH.hide();
         this.InitializeStatusWindow();
      }
      
      public function InitializeStatusWindow() : void
      {
         IMEEx.SendLangBarMessage(this,"StatusWindow_OnInit","");
      }
      
      public function RepositionStatusWindow(cX:Number, cY:Number) : void
      {
         this.x = cX;
         this.y = cY;
      }
      
      public function SetActiveController(language:String) : void
      {
         this.RemoveStatusWindow();
         this.ActiveLanguage = language;
         if(language == "Chinese (Simplified)")
         {
            this.myStatusWindowCH = this.myStatusWindowCH;
         }
         if(this.myStatusWindowCH != null)
         {
            if(this.VisibleState)
            {
               this.myStatusWindowCH.visible = true;
            }
            else
            {
               this.myStatusWindowCH.visible = false;
            }
         }
      }
      
      public function ShowStatusWindow(display:Boolean) : void
      {
         if(display)
         {
            this.myStatusWindowCH.visible = true;
            this.VisibleState = true;
         }
         else
         {
            this.myStatusWindowCH.visible = false;
            this.VisibleState = false;
         }
      }
      
      public function RemoveStatusWindow() : void
      {
         if(this.myStatusWindowCH != null)
         {
            this.myStatusWindowCH.hide();
         }
      }
      
      public function SetInputMode(mode:String) : void
      {
         this.InputMode = mode;
         if(this.myStatusWindowCH != null)
         {
            this.myStatusWindowCH.SetInputMode(mode);
         }
      }
      
      public function SetSymbolMode(mode:String) : void
      {
         this.SymbolMode = mode;
         if(this.myStatusWindowCH != null)
         {
            this.myStatusWindowCH.SetSymbolMode(mode);
         }
      }
      
      public function SetShapeMode(mode:String) : void
      {
         this.ShapeMode = mode;
         if(this.myStatusWindowCH != null)
         {
            this.myStatusWindowCH.SetShapeMode(mode);
         }
      }
   }
}

