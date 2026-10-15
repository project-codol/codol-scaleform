package components
{
   import codo.utils.TextUtil;
   import com.greensock.TweenLite;
   import com.greensock.plugins.*;
   import fl.motion.Color;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   
   public class CodoGrowButtonNoTint extends CodoButton
   {
      
      protected static const KEYFRAME_TO_NORMAL:String = "normal";
      
      protected static const KEYFRAME_TO_NORMAL_END:String = "normal_end";
      
      protected static const KEYFRAME_TO_FOCUSIN:String = "focusin";
      
      protected static const KEYFRAME_TO_DISABLE:String = "disable";
      
      protected static const KEYFRAME_TO_SELECTED:String = "selected";
      
      private static const ICON_TEXT_ALIGN:String = TextFormatAlign.LEFT;
      
      private static const NO_ICON_TEXT_ALIGN:String = TextFormatAlign.CENTER;
      
      TweenPlugin.activate([TintPlugin]);
      
      public var myLabelContainer:Sprite;
      
      public var myBgSelect:MovieClip;
      
      public var myBg:Sprite;
      
      private var TFNormalColor:uint = 0;
      
      private var TFFocusColor:uint = 16777215;
      
      private var TFDisableColor:uint = 16711935;
      
      private var iconTextFormat:TextFormat = new TextFormat();
      
      private var normalTextFormat:TextFormat = new TextFormat();
      
      private var _haveNormalEndFrame:Boolean = false;
      
      private var _iconContainer:Sprite;
      
      private var _icon:Sprite;
      
      private var _iconSrc:String;
      
      private var _iconOffsetY:int = 0;
      
      protected var _selected:Boolean = false;
      
      private var _isAnimationBtn:Boolean = false;
      
      protected var _customTweenSpd:Number = 0.25;
      
      public function CodoGrowButtonNoTint()
      {
         super();
      }
      
      [Inspectable(name="focusColor",defaultValue="#ffffff",type="color")]
      public function set textFocusColour(cUint:String) : void
      {
         this.TFFocusColor = uint("0x" + cUint.substr(1));
      }
      
      [Inspectable(name="disableColor",defaultValue="#ff00ff",type="color")]
      public function set texDisableColour(cUint:String) : void
      {
         this.TFDisableColor = uint("0x" + cUint.substr(1));
      }
      
      override protected function onInit() : void
      {
         if(myLabel != null)
         {
            this.TFNormalColor = myLabel.textColor;
         }
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
         else if(this.myLabelContainer == null && myLabel != null)
         {
            this.myLabelContainer = new Sprite();
            addChild(this.myLabelContainer);
            this.myLabelContainer.addChild(myLabel);
            this.myLabelContainer.filters = myLabel.filters;
            myLabel.filters = null;
         }
         this.iconTextFormat.align = ICON_TEXT_ALIGN;
         this.normalTextFormat.align = NO_ICON_TEXT_ALIGN;
         super.onInit();
      }
      
      public function set textFont(cFont:String) : void
      {
         var tempTF:TextFormat = myLabel.getTextFormat();
         tempTF.font = cFont;
         myLabel.setTextFormat(tempTF);
         myLabel.defaultTextFormat = tempTF;
      }
      
      public function set textIcon(cSrcID:String) : void
      {
         this._iconSrc = cSrcID;
      }
      
      public function set textIconOffsetY(cOffsetY:int) : void
      {
         this._iconOffsetY = cOffsetY;
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
            TweenLite.to(this._icon,0,{"tint":this.TFNormalColor});
         }
         this.refreshIcon();
      }
      
      override public function set label(cTxt:String) : void
      {
         if(this._iconSrc == null)
         {
            super.label = cTxt;
            this.refreshIcon();
         }
         else
         {
            _label = cTxt;
            if(myLabel != null)
            {
               TextUtil.setIconText(myLabel,_label,this._iconSrc,this.TFNormalColor.toString(16),this._iconOffsetY);
            }
         }
      }
      
      private function refreshIcon() : void
      {
         if(this._iconContainer != null && this._icon != null)
         {
            this._iconContainer.x = myBgNormal.width / 2 - (myLabel.textWidth + this._icon.width) / 2;
            this._iconContainer.y = myBgNormal.height / 2 - this._iconContainer.height / 2;
         }
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
      
      override protected function setToNormal(cTween:Boolean = true) : void
      {
         this.cleanTween();
         var tempColor:Color = new Color();
         if(this._isAnimationBtn == true)
         {
            if(this._selected == true)
            {
               this.changeKeyframeAnimation(KEYFRAME_TO_SELECTED);
            }
            else if(this._haveNormalEndFrame == true && cTween == false)
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
            if(this._selected == false)
            {
               TweenLite.to(myBgNormal,0,{"alpha":1});
               TweenLite.to(myBgFocus,this._customTweenSpd,{"alpha":0});
               myBgFocus.gotoAndStop(1);
               if(myBgDisable != null)
               {
                  myBgDisable.visible = false;
               }
               if(myLabel != null)
               {
                  if(this._iconSrc == null)
                  {
                     myLabel.textColor = this.TFNormalColor;
                  }
                  else
                  {
                     tempColor.setTint(this.TFNormalColor,1);
                     this.myLabelContainer.transform.colorTransform = tempColor;
                  }
               }
               if(this._icon != null)
               {
                  TweenLite.to(this._icon,this._customTweenSpd,{"tint":this.TFNormalColor});
               }
            }
            else
            {
               if(this.myBgSelect == null)
               {
                  TweenLite.to(myBgFocus,this._customTweenSpd,{"alpha":1});
               }
               else
               {
                  TweenLite.to(myBgFocus,0,{"alpha":0});
               }
               if(myLabel != null)
               {
                  if(this._iconSrc == null)
                  {
                     myLabel.textColor = this.TFFocusColor;
                  }
                  else
                  {
                     tempColor.setTint(this.TFFocusColor,1);
                     this.myLabelContainer.transform.colorTransform = tempColor;
                  }
               }
               if(this._icon != null)
               {
                  TweenLite.to(this._icon,this._customTweenSpd,{"tint":this.TFFocusColor});
               }
            }
         }
      }
      
      override protected function setToRollOver(cTween:Boolean = true) : void
      {
         this.cleanTween();
         var tempColor:Color = new Color();
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
            TweenLite.to(myBgNormal,this._customTweenSpd,{"alpha":0});
            myBgFocus.gotoAndPlay(1);
            TweenLite.to(myBgFocus,this._customTweenSpd,{"alpha":1});
            if(myBgDisable != null)
            {
               myBgDisable.visible = false;
            }
            if(this._selected == true)
            {
               if(this.myBgSelect == null)
               {
                  TweenLite.to(myBgFocus,this._customTweenSpd,{"alpha":1});
               }
               else
               {
                  TweenLite.to(myBgFocus,this._customTweenSpd,{"alpha":0});
               }
               if(myLabel != null)
               {
                  if(this._iconSrc == null)
                  {
                     myLabel.textColor = this.TFFocusColor;
                  }
                  else
                  {
                     tempColor.setTint(this.TFFocusColor,1);
                     this.myLabelContainer.transform.colorTransform = tempColor;
                  }
               }
               if(this._icon != null)
               {
                  TweenLite.to(this._icon,0,{"tint":this.TFFocusColor});
               }
            }
            else
            {
               if(myLabel != null)
               {
                  if(this._iconSrc == null)
                  {
                     myLabel.textColor = this.TFFocusColor;
                  }
                  else
                  {
                     tempColor.setTint(this.TFFocusColor,1);
                     this.myLabelContainer.transform.colorTransform = tempColor;
                  }
               }
               if(this._icon != null)
               {
                  TweenLite.to(this._icon,this._customTweenSpd,{"tint":this.TFFocusColor});
               }
            }
         }
      }
      
      override protected function setToDisable() : void
      {
         var tempColor:Color = new Color();
         if(this._isAnimationBtn == true)
         {
            this.changeKeyframeAnimation(KEYFRAME_TO_DISABLE);
         }
         else
         {
            if(myBgDisable != null)
            {
               myBgDisable.visible = true;
               myBgNormal.alpha = myBgNormal.focus = 0;
               if(this.myBgSelect != null)
               {
                  this.myBgSelect.visible = false;
               }
            }
            else
            {
               myBgNormal.alpha = 0.3;
               myBgFocus.alpha = 0;
               if(this.myBgSelect != null)
               {
                  this.myBgSelect.alpha = 0;
               }
            }
            if(this.TFDisableColor != 16711935)
            {
               if(myLabel != null)
               {
                  if(this._iconSrc == null)
                  {
                     myLabel.textColor = this.TFDisableColor;
                  }
                  else
                  {
                     tempColor.setTint(this.TFDisableColor,1);
                     this.myLabelContainer.transform.colorTransform = tempColor;
                  }
               }
               if(this._icon != null)
               {
                  TweenLite.to(this._icon,this._customTweenSpd,{"tint":this.TFDisableColor});
               }
            }
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
            if(this.myBg != null)
            {
               this.myBg.width *= targetScaleX;
               this.myBg.height *= targetScaleY;
            }
         }
      }
      
      private function cleanTween() : void
      {
         TweenLite.killTweensOf(myBgNormal);
         TweenLite.killTweensOf(myBgFocus);
         if(this._icon != null)
         {
            TweenLite.killTweensOf(this._icon);
         }
         if(myBgDisable != null)
         {
            TweenLite.killTweensOf(myBgDisable);
         }
         if(this.myBgSelect != null)
         {
            TweenLite.killTweensOf(this.myBgSelect);
         }
      }
   }
}

