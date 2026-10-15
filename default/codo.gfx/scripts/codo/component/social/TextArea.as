package codo.component.social
{
   import codo.objects.InputBoxSettings;
   import codo.utils.StringUtil;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class TextArea extends MovieClip
   {
      
      public var myBg:MovieClip;
      
      public var myInputText:TextField;
      
      public var myHintText:TextField;
      
      private var mTextCache:String;
      
      private var mSetting:InputBoxSettings;
      
      public function TextArea()
      {
         super();
         this.myInputText.addEventListener(Event.CHANGE,this.onInputTextChanged);
         this.addEventListener(FocusEvent.FOCUS_IN,this.onInputTextFocusIn);
         this.addEventListener(FocusEvent.FOCUS_OUT,this.onInputTextFocusOut);
      }
      
      public function set settings(newSettings:InputBoxSettings) : void
      {
         this.mSetting = newSettings;
         this.draw();
      }
      
      private function draw() : void
      {
         var curTF:TextField = null;
         var tf:TextFormat = null;
         this.myBg.visible = this.mSetting.hasBg;
         this.myBg.width = this.mSetting.width;
         this.myBg.height = this.mSetting.height;
         var textArr:Array = [this.myInputText,this.myHintText];
         for(var i:int = 0; i < textArr.length; i++)
         {
            curTF = textArr[i];
            curTF.x = this.mSetting.padding;
            curTF.y = this.mSetting.padding;
            curTF.width = this.mSetting.width - this.mSetting.padding * 2;
            curTF.height = this.mSetting.height - this.mSetting.padding * 2;
            tf = curTF.getTextFormat();
            tf.size = this.mSetting.fontSize;
            curTF.defaultTextFormat = tf;
            curTF.setTextFormat(tf);
         }
         this.myInputText.textColor = this.mSetting.inputFontColor;
         this.myHintText.text = this.mSetting.hintText;
         if(this.mSetting.highlightAsDefault)
         {
            this.myBg.gotoAndStop(2);
         }
         else
         {
            this.myBg.gotoAndStop(1);
         }
         this.visibleHint();
      }
      
      private function visibleHint() : void
      {
         if(this.mSetting.showHint)
         {
            this.myHintText.visible = this.myInputText.text.length <= 0;
         }
         else
         {
            this.myHintText.visible = false;
         }
      }
      
      private function onInputTextChanged(e:Event) : void
      {
         var isPass:Boolean = true;
         var str:String = this.myInputText.text;
         if(this.myInputText.numLines > this.mSetting.limitTextLine)
         {
            isPass = false;
         }
         else if(StringUtil.getRealLength(str) > this.mSetting.limitTextLen)
         {
            isPass = false;
         }
         else if(str.length > 0 && this.mSetting.regExp != null)
         {
            isPass = this.mSetting.regExp.test(str);
         }
         else if(this.mSetting.textValidator != null)
         {
            isPass = this.mSetting.textValidator(str);
         }
         if(isPass)
         {
            this.mTextCache = str;
         }
         else
         {
            this.myInputText.text = this.mTextCache;
         }
         this.visibleHint();
      }
      
      private function onInputTextFocusIn(e:FocusEvent) : void
      {
         this.myBg.gotoAndStop(2);
      }
      
      private function onInputTextFocusOut(e:FocusEvent) : void
      {
         if(this.mSetting.highlightAsDefault)
         {
            this.myBg.gotoAndStop(2);
         }
         else
         {
            this.myBg.gotoAndStop(1);
         }
      }
      
      public function warningUser() : void
      {
         this.myBg.gotoAndStop(3);
      }
      
      public function set text(value:String) : void
      {
         this.mTextCache = value;
         this.myInputText.text = value;
         this.visibleHint();
      }
      
      public function get text() : String
      {
         return this.myInputText.text;
      }
      
      public function catchFocus() : void
      {
         stage.focus = this.myInputText;
      }
   }
}

