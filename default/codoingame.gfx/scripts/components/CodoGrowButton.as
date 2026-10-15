package components
{
   import codo.constants.ComponentCSS;
   import codo.utils.GraphicUtil;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   
   public class CodoGrowButton extends CodoButton
   {
      
      protected static const KEYFRAME_TO_NORMAL:String = "normal";
      
      protected static const KEYFRAME_TO_NORMAL_END:String = "normal_end";
      
      protected static const KEYFRAME_TO_FOCUSIN:String = "focusin";
      
      protected static const KEYFRAME_TO_DISABLE:String = "disable";
      
      protected static const KEYFRAME_TO_SELECTED:String = "selected";
      
      private static const ICON_TEXT_ALIGN:String = TextFormatAlign.LEFT;
      
      private static const NO_ICON_TEXT_ALIGN:String = TextFormatAlign.CENTER;
      
      [Inspectable(name="GoToNormalEnd",defaultValue="true",enumeration="true,false")]
      public var gotoNormalEndFirstTime:String = "true";
      
      public var myLabelContainer:Sprite;
      
      public var myBgSelect:MovieClip;
      
      public var myBgExt_0:MovieClip;
      
      public var myBgExt_1:MovieClip;
      
      private var iconTextFormat:TextFormat = new TextFormat();
      
      private var normalTextFormat:TextFormat = new TextFormat();
      
      private var _haveNormalEndFrame:Boolean = false;
      
      private var _iconContainer:Sprite;
      
      private var _icon:Sprite;
      
      protected var _selected:Boolean = false;
      
      private var _isAnimationBtn:Boolean = false;
      
      protected var _customTweenSpd:Number = 0.25;
      
      [Inspectable(name="Style",type="String",defaultValue="STYLE_NONE",enumeration="STYLE_NONE,STYLE_1_CODO_GROW_BUTTON,STYLE_2_CODO_GROW_BUTTON,STYLE_3_CODO_GROW_BUTTON,STYLE_4_CODO_GROW_BUTTON,STYLE_5_CODO_GROW_BUTTON,STYLE_6_CODO_GROW_BUTTON,STYLE_7_CODO_GROW_BUTTON,STYLE_8_CODO_GROW_BUTTON,STYLE_9_CODO_GROW_BUTTON,STYLE_10_CODO_GROW_BUTTON,STYLE_1_CODO_GROW_TAB,STYLE_2_CODO_GROW_TAB,STYLE_3_CODO_GROW_TAB,STYLE_1_CODO_GROW_TAB_CYBORGS,STYLE_3_CODO_GROW_TAB_CYBORGS,STYLE_4_CODO_GROW_TAB_CYBORGS,STYLE_1_CODO_HEADER,STYLE_2_CODO_HEADER,STYLE_NORMAL_CODO_FLIP_BUTTON,STYLE_FLIPED_CODO_FLIP_BUTTON,STYLE_PARTY_EMPTY_BUTTON")]
      public var _styleID:String = "STYLE_NONE";
      
      protected var _currentStyleDat:Object = {};
      
      public function CodoGrowButton()
      {
         super();
      }
      
      override protected function onInit() : void
      {
         this._isAnimationBtn = totalFrames > 1;
         for(var i:uint = 0; i < currentLabels.length; i++)
         {
            if(currentLabels[i].name == KEYFRAME_TO_NORMAL_END)
            {
               this._haveNormalEndFrame = true;
               break;
            }
         }
         if(this._isAnimationBtn == false)
         {
            if(this.myBgSelect != null)
            {
               this.myBgSelect.visible = this._selected;
               this.myBgSelect.mouseEnabled = false;
            }
         }
         if(this.myLabelContainer != null && myLabel == null)
         {
            myLabel = this.myLabelContainer["myLabel"];
         }
         if(this.myBgExt_1 != null)
         {
            this.myBgExt_1.gotoAndPlay(2);
         }
         this.iconTextFormat.align = ICON_TEXT_ALIGN;
         this.normalTextFormat.align = NO_ICON_TEXT_ALIGN;
         addEventListener(Event.ENTER_FRAME,this.onEnterFrameHandle);
         super.onInit();
      }
      
      protected function onEnterFrameHandle(cEvt:Event) : void
      {
         removeEventListener(Event.ENTER_FRAME,this.onEnterFrameHandle);
         if(this._isAnimationBtn == false)
         {
            this.style = this._styleID;
         }
      }
      
      public function set style(cStyleID:String) : void
      {
         this._styleID = cStyleID;
         this._currentStyleDat = ComponentCSS[this._styleID];
         if(this.myBgSelect != null)
         {
            GraphicUtil.tintIt(this.myBgSelect,0,this._currentStyleDat.selectedBgColor);
         }
         if(enable == true)
         {
            this.setToNormal(false);
         }
         else
         {
            this.setToDisable();
         }
      }
      
      public function get styleID() : String
      {
         return this._styleID;
      }
      
      public function set textFont(cFont:String) : void
      {
         var tempTF:TextFormat = myLabel.getTextFormat();
         tempTF.font = cFont;
         myLabel.setTextFormat(tempTF);
         myLabel.defaultTextFormat = tempTF;
      }
      
      public function set icon(icon:Sprite) : void
      {
         if(this._iconContainer == null)
         {
            this._iconContainer = new Sprite();
         }
         addChild(this._iconContainer);
         if(Boolean(this._iconContainer.numChildren))
         {
            myLabel.width += icon.width;
            this._iconContainer.removeChild(this._icon);
            myLabel.setTextFormat(this.normalTextFormat);
         }
         if(Boolean(icon))
         {
            this._icon = icon;
            myLabel.width -= icon.width;
            myLabel.setTextFormat(this.iconTextFormat);
            this._iconContainer.addChild(icon);
            this._iconContainer.addChild(myLabel);
            icon.x = icon.y = myLabel.x = myLabel.y = 0;
            icon.y = (this._iconContainer.height - icon.height) / 2;
            myLabel.y = (this._iconContainer.height - myLabel.height) / 2;
            myLabel.x = icon.width;
         }
         this.refreshIcon();
      }
      
      override public function set label(cTxt:String) : void
      {
         super.label = cTxt;
         this.refreshIcon();
      }
      
      private function refreshIcon() : void
      {
         if(this._iconContainer != null && this._icon != null)
         {
            this._iconContainer.x = myBgNormal.width / 2 - (myLabel.textWidth + this._icon.width) / 2;
            this._iconContainer.y = myBgNormal.height / 2 - this._iconContainer.height / 2;
         }
      }
      
      public function set tweenSpeed(cTweenSpd:Number) : void
      {
         this._customTweenSpd = cTweenSpd;
      }
      
      public function set selected(cSwi:Boolean) : void
      {
         this._selected = cSwi;
         if(this._isAnimationBtn == true)
         {
            if(enable == true)
            {
               if(this._selected == true)
               {
                  this.changeKeyframeAnimation(KEYFRAME_TO_SELECTED);
               }
               else
               {
                  this.changeKeyframeAnimation(KEYFRAME_TO_NORMAL);
               }
            }
         }
         else
         {
            if(enable == true)
            {
               if(this._selected == true)
               {
                  this.setToRollOver(false);
               }
               else
               {
                  this.setToNormal();
               }
            }
            if(this.myBgSelect != null)
            {
               this.myBgSelect.visible = this._selected;
            }
         }
      }
      
      public function get selected() : Boolean
      {
         return this._selected;
      }
      
      override protected function setToNormal(cTween:Boolean = true) : void
      {
         if(this._isAnimationBtn == true)
         {
            if(this._selected == true)
            {
               this.changeKeyframeAnimation(KEYFRAME_TO_SELECTED);
            }
            else if(this.gotoNormalEndFirstTime == "true" && this._haveNormalEndFrame == true && cTween == false)
            {
               this.changeKeyframeAnimation(KEYFRAME_TO_NORMAL_END,false);
            }
            else
            {
               this.changeKeyframeAnimation(KEYFRAME_TO_NORMAL);
            }
         }
         else
         {
            if(this.myBgSelect != null)
            {
               this.myBgSelect.visible = this._selected;
            }
            if(this._styleID == "STYLE_NONE")
            {
               return;
            }
            if(this._selected == false)
            {
               GraphicUtil.tintIt(myBgNormal,this._customTweenSpd,this._currentStyleDat.normalBgColor,false,null,cTween);
               myBgFocus.gotoAndStop(1);
               GraphicUtil.tintIt(myBgFocus,this._customTweenSpd,this._currentStyleDat.focusBgColor,true,null,cTween);
               if(myBgDisable != null)
               {
                  myBgDisable.visible = false;
               }
               GraphicUtil.tintIt(this.myBgExt_0,this._customTweenSpd,this._currentStyleDat.normalExtBg0Color,false,null,cTween);
               GraphicUtil.tintIt(this.myBgExt_1,this._customTweenSpd,this._currentStyleDat.normalExtBg1Color,false,null,cTween);
               GraphicUtil.tintIt(myLabel,this._customTweenSpd,this._currentStyleDat.normalTFColor,false,null,cTween);
               if(this._icon != null)
               {
                  GraphicUtil.tintIt(this._icon,this._customTweenSpd,this._currentStyleDat.normalTFColor,false,null,cTween);
               }
            }
            else
            {
               if(this.myBgSelect == null)
               {
                  GraphicUtil.tintIt(myBgFocus,this._customTweenSpd,this._currentStyleDat.focusBgColor,false,null,cTween);
               }
               else
               {
                  GraphicUtil.tintIt(myBgFocus,0,this._currentStyleDat.focusBgColor,true,null,cTween);
               }
               GraphicUtil.tintIt(this.myBgExt_0,this._customTweenSpd,this._currentStyleDat.selectedExtBg0Color,false,null,cTween);
               GraphicUtil.tintIt(this.myBgExt_1,this._customTweenSpd,this._currentStyleDat.selectedExtBg1Color,false,null,cTween);
               GraphicUtil.tintIt(myLabel,this._customTweenSpd,this._currentStyleDat.selectedTFColor,false,null,cTween);
               if(this._icon != null)
               {
                  GraphicUtil.tintIt(this._icon,this._customTweenSpd,this._currentStyleDat.selectedTFColor,false,null,cTween);
               }
            }
         }
      }
      
      override protected function setToRollOver(cTween:Boolean = true) : void
      {
         if(this._isAnimationBtn == true)
         {
            if(this._selected == false)
            {
               this.changeKeyframeAnimation(KEYFRAME_TO_FOCUSIN);
            }
         }
         else
         {
            if(this.myBgSelect != null)
            {
               this.myBgSelect.visible = this._selected;
            }
            if(this.myBgExt_1 != null)
            {
               this.myBgExt_1.gotoAndPlay(2);
            }
            GraphicUtil.tintIt(myBgNormal,this._customTweenSpd,this._currentStyleDat.normalBgColor,true,null,cTween);
            myBgFocus.gotoAndPlay(1);
            GraphicUtil.tintIt(myBgFocus,this._customTweenSpd,this._currentStyleDat.focusBgColor,false,null,cTween);
            if(myBgDisable != null)
            {
               myBgDisable.visible = false;
            }
            if(this._selected == true)
            {
               if(this.myBgSelect == null)
               {
                  GraphicUtil.tintIt(myBgFocus,this._customTweenSpd,this._currentStyleDat.focusBgColor,false,null,cTween);
               }
               else
               {
                  GraphicUtil.tintIt(myBgFocus,0,this._currentStyleDat.focusBgColor,true,null,cTween);
               }
               GraphicUtil.tintIt(this.myBgExt_0,this._customTweenSpd,this._currentStyleDat.selectedExtBg0Color,false,null,cTween);
               GraphicUtil.tintIt(this.myBgExt_1,this._customTweenSpd,this._currentStyleDat.selectedExtBg1Color,false,null,cTween);
               GraphicUtil.tintIt(myLabel,this._customTweenSpd,this._currentStyleDat.selectedTFColor,false,null,cTween);
               if(this._icon != null)
               {
                  GraphicUtil.tintIt(this._icon,this._customTweenSpd,this._currentStyleDat.selectedTFColor,false,null,cTween);
               }
            }
            else
            {
               GraphicUtil.tintIt(this.myBgExt_0,this._customTweenSpd,this._currentStyleDat.focusExtBg0Color,false,null,cTween);
               GraphicUtil.tintIt(this.myBgExt_1,this._customTweenSpd,this._currentStyleDat.focusExtBg1Color,false,null,cTween);
               GraphicUtil.tintIt(myLabel,this._customTweenSpd,this._currentStyleDat.focusTFColor,false,null,cTween);
               if(this._icon != null)
               {
                  GraphicUtil.tintIt(this._icon,this._customTweenSpd,this._currentStyleDat.focusTFColor,false,null,cTween);
               }
            }
         }
      }
      
      override protected function setToDisable() : void
      {
         if(this._isAnimationBtn == true)
         {
            this.changeKeyframeAnimation(KEYFRAME_TO_DISABLE);
         }
         else
         {
            if(myBgDisable != null)
            {
               myBgDisable.visible = true;
               GraphicUtil.tintIt(myBgNormal,0,this._currentStyleDat.normalBgColor,true,null,false);
               GraphicUtil.tintIt(myBgFocus,0,this._currentStyleDat.focusBgColor,true,null,false);
               GraphicUtil.tintIt(myBgDisable,0,this._currentStyleDat.disabledBgColor,false,null,false);
            }
            else
            {
               GraphicUtil.tintIt(myBgNormal,0,this._currentStyleDat.normalBgColor,false,null,false);
               GraphicUtil.tintIt(myBgFocus,0,this._currentStyleDat.focusBgColor,false,null,false);
            }
            GraphicUtil.tintIt(this.myBgExt_0,this._customTweenSpd,this._currentStyleDat.disabledExtBg0Color,false,null,false);
            GraphicUtil.tintIt(this.myBgExt_1,this._customTweenSpd,this._currentStyleDat.disabledExtBg1Color,false,null,false);
            GraphicUtil.tintIt(myLabel,this._customTweenSpd,this._currentStyleDat.disabledTFColor,false,null,false);
            if(this._icon != null)
            {
               GraphicUtil.tintIt(this._icon,this._customTweenSpd,this._currentStyleDat.disabledTFColor,false,null,false);
            }
         }
      }
      
      private function changeKeyframeAnimation(cFlag:String, cPlay:Boolean = true) : void
      {
         if(cPlay == true)
         {
            gotoAndPlay(cFlag);
         }
         else
         {
            gotoAndStop(cFlag);
         }
         if(myLabel != null)
         {
            myLabel.text = _label;
         }
      }
      
      override protected function resetScaleToRealSize() : void
      {
         var targetScaleX:Number = NaN;
         var targetScaleY:Number = NaN;
         if(scaleX != 1 || scaleY != 1)
         {
            targetScaleX = scaleX;
            targetScaleY = scaleY;
            scaleX = 1;
            scaleY = 1;
            if(myHitArea != null)
            {
               myHitArea.width = _orgHitAreaWidth * targetScaleX;
               myHitArea.height = _orgHitAreaHeight * targetScaleY;
               _orgHitAreaWidth = myHitArea.width;
               _orgHitAreaHeight = myHitArea.height;
            }
            if(myLabel != null)
            {
               myLabel.width *= targetScaleX;
            }
            if(myBgNormal != null)
            {
               myBgNormal.width *= targetScaleX;
               myBgNormal.height *= targetScaleY;
            }
            if(myBgFocus != null)
            {
               myBgFocus.width *= targetScaleX;
               myBgFocus.height *= targetScaleY;
            }
            if(myBgDisable != null)
            {
               myBgDisable.width *= targetScaleX;
               myBgDisable.height *= targetScaleY;
            }
            if(this.myBgSelect != null)
            {
               this.myBgSelect.width *= targetScaleX;
               this.myBgSelect.height *= targetScaleY;
            }
            if(this.myBgExt_0 != null)
            {
               this.myBgExt_0.width *= targetScaleX;
               this.myBgExt_0.height *= targetScaleY;
            }
            if(this.myBgExt_1 != null)
            {
               this.myBgExt_1.width *= targetScaleX;
               this.myBgExt_1.height *= targetScaleY;
            }
         }
      }
   }
}

