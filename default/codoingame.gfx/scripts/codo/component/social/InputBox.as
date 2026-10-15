package codo.component.social
{
   import codo.objects.InputBoxSettings;
   import codo.utils.StringUtil;
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.ui.Keyboard;
   import fsg.shared.BehaviourClickable;
   import scaleform.gfx.TextFieldEx;
   
   public class InputBox extends MovieClip
   {
      
      public var myBg:MovieClip;
      
      public var mySearchIcon:MovieClip;
      
      public var myClearButton:MovieClip;
      
      public var myInputText:TextField;
      
      public var myHintText:TextField;
      
      private var mClearBtnClickBehaviour:BehaviourClickable;
      
      private var mSetting:InputBoxSettings;
      
      private var mAnimationParameter:Array;
      
      private var mCache:String = "";
      
      private var mObfuscatedCache:Vector.<int> = new Vector.<int>();
      
      public function InputBox()
      {
         super();
         this.mClearBtnClickBehaviour = new BehaviourClickable(this.myClearButton);
         this.mClearBtnClickBehaviour.addClickCallback(this.onClearBtnClicked);
         this.mClearBtnClickBehaviour.addMouseOverCallback(this.onClearBtnOver);
         this.mClearBtnClickBehaviour.addMouseOutCallback(this.onClearBtnOut);
         this.myInputText.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDownHandle);
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
         this.myClearButton.width = this.myClearButton.height = this.mSetting.height * 0.5;
         this.myClearButton.x = this.mSetting.width - this.mSetting.height * 0.25 - this.myClearButton.width;
         this.myClearButton.y = (this.mSetting.height - this.myClearButton.height) * 0.5;
         this.mySearchIcon.width = this.mySearchIcon.height = this.mSetting.height * 0.5;
         this.mySearchIcon.x = this.mSetting.padding;
         this.mySearchIcon.y = (this.mSetting.height - this.mySearchIcon.height) * 0.5;
         this.mySearchIcon.visible = this.mSetting.showSearchIcon;
         var textArr:Array = [this.myInputText,this.myHintText];
         for(var i:int = 0; i < textArr.length; i++)
         {
            curTF = textArr[i];
            TextFieldEx.setVerticalAlign(curTF,TextFieldEx.VALIGN_CENTER);
            if(this.mSetting.showSearchIcon)
            {
               curTF.width = this.myClearButton.x - this.mSetting.padding - (this.mySearchIcon.x + this.mySearchIcon.width + this.mSetting.padding);
               curTF.x = this.mSetting.padding + this.mySearchIcon.x + this.mySearchIcon.width;
            }
            else
            {
               curTF.width = this.myClearButton.x - this.mSetting.padding - this.mSetting.padding;
               curTF.x = this.mSetting.padding;
            }
            curTF.height = this.mSetting.height;
            curTF.y = 0;
            tf = curTF.getTextFormat();
            tf.size = this.mSetting.fontSize;
            curTF.defaultTextFormat = tf;
            curTF.setTextFormat(tf);
         }
         this.myInputText.textColor = this.mSetting.inputFontColor;
         this.myHintText.text = this.mSetting.hintText;
         this.myHintText.width = this.myHintText.textWidth + 10;
         this.gatherHintAnimationParameter();
         if(this.mSetting.showHint)
         {
            this.mySearchIcon.x = this.mAnimationParameter[2];
            this.myHintText.x = this.mAnimationParameter[3];
         }
         else
         {
            this.mySearchIcon.x = this.mAnimationParameter[0];
            this.myHintText.x = this.mAnimationParameter[1];
         }
         if(this.mSetting.highlightAsDefault)
         {
            this.myBg.gotoAndStop(2);
         }
         else
         {
            this.myBg.gotoAndStop(1);
         }
         this.visibleHintAndClearBtn();
      }
      
      private function gatherHintAnimationParameter() : void
      {
         this.mAnimationParameter = [this.mySearchIcon.x,this.myHintText.x];
         var totalWidth:Number = this.myHintText.x + this.myHintText.textWidth - this.mySearchIcon.x;
         var beginX:Number = (this.mSetting.width - totalWidth) * 0.5;
         this.mAnimationParameter.push(beginX);
         var offset:Number = this.myHintText.x - this.mySearchIcon.x;
         this.mAnimationParameter.push(beginX + offset);
      }
      
      private function onInputTextChanged(e:Event) : void
      {
         var isPass:Boolean = true;
         var str:String = this.myInputText.text;
         if(StringUtil.getRealLength(str) > this.mSetting.limitTextLen)
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
            this.setCache(str);
         }
         else
         {
            this.myInputText.text = this.getCache();
         }
         this.visibleHintAndClearBtn();
      }
      
      private function onKeyDownHandle(e:KeyboardEvent) : void
      {
         if(e.keyCode == Keyboard.NUMPAD_ENTER || e.keyCode == Keyboard.ENTER)
         {
            if(null != this.mSetting.keyEnterHandler)
            {
               e.stopPropagation();
               this.mSetting.keyEnterHandler();
            }
         }
      }
      
      private function visibleHintAndClearBtn() : void
      {
         if(this.mSetting.showClearButton)
         {
            this.myClearButton.visible = this.myInputText.text.length > 0;
            this.myInputText.width = this.myClearButton.x - this.myInputText.x;
         }
         else
         {
            this.myClearButton.visible = false;
            this.myInputText.width = this.myClearButton.x + this.myClearButton.width - this.myInputText.x;
         }
         if(this.mSetting.showHint)
         {
            this.myHintText.visible = this.myInputText.text.length <= 0;
         }
         else
         {
            this.myHintText.visible = false;
         }
      }
      
      private function onClearBtnClicked() : void
      {
         this.text = "";
         if(Boolean(this.stage))
         {
            stage.focus = this.myInputText;
         }
      }
      
      private function onClearBtnOver() : void
      {
         this.myClearButton.gotoAndStop(2);
      }
      
      private function onClearBtnOut() : void
      {
         this.myClearButton.gotoAndStop(1);
      }
      
      private function onInputTextFocusIn(e:FocusEvent) : void
      {
         this.myBg.gotoAndStop(2);
         if(this.myInputText.length <= 0 && this.mSetting.showHint)
         {
            TweenLite.to(this.mySearchIcon,0.2,{"x":this.mAnimationParameter[0]});
            TweenLite.to(this.myHintText,0.2,{
               "x":this.mAnimationParameter[1],
               "alpha":0
            });
         }
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
         if(this.myInputText.length <= 0 && this.mSetting.showHint)
         {
            TweenLite.to(this.mySearchIcon,0.2,{"x":this.mAnimationParameter[2]});
            TweenLite.to(this.myHintText,0.2,{
               "x":this.mAnimationParameter[3],
               "alpha":1
            });
         }
      }
      
      public function warningUser() : void
      {
         this.myBg.gotoAndStop(3);
      }
      
      public function set text(value:String) : void
      {
         this.setCache(value);
         this.myInputText.text = value;
         this.visibleHintAndClearBtn();
      }
      
      public function get text() : String
      {
         return this.getCache();
      }
      
      public function catchFocus() : void
      {
         stage.focus = this.myInputText;
      }
      
      public function releaseFocus() : void
      {
         stage.focus = null;
      }
      
      private function setCache(srcStr:String) : void
      {
         if(this.mSetting.needMemoryObfuscate)
         {
            this.mObfuscatedCache = StringUtil.obfuscateStringToVector(srcStr);
         }
         else
         {
            this.mCache = srcStr;
         }
      }
      
      private function getCache() : String
      {
         if(this.mSetting.needMemoryObfuscate)
         {
            return StringUtil.unobfuscateVectorToString(this.mObfuscatedCache);
         }
         return this.mCache;
      }
   }
}

