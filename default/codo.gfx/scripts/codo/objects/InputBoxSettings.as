package codo.objects
{
   public class InputBoxSettings extends CustomObject
   {
      
      public var hintText:String = "";
      
      public var regExp:RegExp;
      
      public var width:Number = 220;
      
      public var height:Number = 21;
      
      public var padding:Number = 5;
      
      public var fontSize:Number = 12;
      
      public var inputFontColor:uint = 16777215;
      
      public var showClearButton:Boolean = true;
      
      public var showHint:Boolean = true;
      
      public var textValidator:Function = null;
      
      public var keyEnterHandler:Function = null;
      
      public var showSearchIcon:Boolean = true;
      
      public var limitTextLen:int = 400;
      
      public var limitTextLine:int = 999;
      
      public var highlightAsDefault:Boolean = false;
      
      public var needMemoryObfuscate:Boolean = false;
      
      public var hasBg:Boolean = true;
      
      public function InputBoxSettings()
      {
         super();
      }
   }
}

