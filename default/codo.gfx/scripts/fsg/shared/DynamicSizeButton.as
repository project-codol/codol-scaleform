package fsg.shared
{
   import fl.motion.Color;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class DynamicSizeButton extends BarDialogButton
   {
      
      private static const BUTTON_BORDER_THICKNESS:int = 2;
      
      public var myFrame:MovieClip;
      
      public var myBackground:MovieClip;
      
      public var myBackgroundBlinking:MovieClip;
      
      public var myReflection:MovieClip;
      
      private var mWidth:Number;
      
      private var mHeight:Number;
      
      private var _forceSelect:Boolean;
      
      protected var _tooltip:BehaviourTooltip;
      
      public function DynamicSizeButton()
      {
         super();
         m_clickable.addMouseOverCallback(this.onMouseOver);
         m_clickable.addMouseOutCallback(this.onMouseOut);
         var c:Color = new Color();
         c.setTint(4172277,0.2);
         this.myBackground.transform.colorTransform = c;
         this.myReflection.alpha = 0.08;
         var tf:TextField = myButtonText.myTextTF;
         tf.textColor = 16777215;
      }
      
      public function setSize(w:Number, h:Number) : void
      {
         this.mHeight = h;
         this.mWidth = w;
         myHitArea.width = w;
         myHitArea.height = h;
         this.myFrame.width = w - BUTTON_BORDER_THICKNESS;
         this.myFrame.height = h - BUTTON_BORDER_THICKNESS;
         this.myReflection.width = this.myFrame.width - BUTTON_BORDER_THICKNESS;
         this.myReflection.height = h * 0.5 - BUTTON_BORDER_THICKNESS;
         this.myBackgroundBlinking.width = w;
         this.myBackgroundBlinking.height = h;
         this.myBackground.width = w;
         this.myBackground.height = h;
         myButtonText.x = myHitArea.x;
         myButtonText.y = myHitArea.y;
         myButtonText.myTextTF.width = myHitArea.width;
         myButtonText.myTextTF.height = myHitArea.height;
      }
      
      public function registerOnMouseOverCallback(callback:Function) : void
      {
         m_clickable.addMouseOverCallback(callback);
      }
      
      public function unregisterOnMouseOverCallback(callback:Function) : void
      {
         m_clickable.removeMouseOverCallback(callback);
      }
      
      public function registerOnMouseOutCallback(callback:Function) : void
      {
         m_clickable.addMouseOutCallback(callback);
      }
      
      public function unregisterOnMouseOutCallback(callback:Function) : void
      {
         m_clickable.removeMouseOutCallback(callback);
      }
      
      public function setEnableMouseHighlight(enable:Boolean) : void
      {
         m_clickable.setEnableMouseHighlight(enable);
      }
      
      public function onMouseOver() : void
      {
         var c:Color = null;
         var tf:TextField = null;
         if(isEnabled())
         {
            c = new Color();
            c.setTint(15592941,1);
            this.myBackground.transform.colorTransform = c;
            this.myReflection.alpha = 0.5;
            tf = myButtonText.myTextTF;
            tf.textColor = 0;
         }
      }
      
      public function onMouseOut() : void
      {
         var c:Color = null;
         var tf:TextField = null;
         if(this._forceSelect)
         {
            return;
         }
         if(isEnabled())
         {
            c = new Color();
            c.setTint(4172277,0.2);
            this.myBackground.transform.colorTransform = c;
            this.myReflection.alpha = 0.08;
            tf = myButtonText.myTextTF;
            tf.textColor = 16777215;
         }
      }
      
      override public function get height() : Number
      {
         return this.mHeight;
      }
      
      override public function get width() : Number
      {
         return this.mWidth;
      }
      
      override public function forceSelect() : void
      {
         this._forceSelect = true;
         this.onMouseOver();
      }
      
      override public function resetSelection() : void
      {
         this._forceSelect = false;
         this.onMouseOut();
      }
      
      public function setToolTip(str:String) : void
      {
         if(this._tooltip == null)
         {
            this._tooltip = new BehaviourTooltip(m_clickable,str,myHitArea as MovieClip,{
               "x":300,
               "y":0
            });
         }
         else
         {
            this._tooltip.tipText = str;
         }
      }
      
      override public function setEnabled(cEnable:Boolean) : void
      {
         super.setEnabled(cEnable);
         if(!cEnable)
         {
            this.alpha = 0.5;
         }
         else
         {
            this.alpha = 1;
         }
      }
   }
}

