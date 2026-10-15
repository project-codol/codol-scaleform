package components.list_part
{
   import codo.constants.TweenParam;
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   
   public class ComboboxItemRenderer extends ListItemRendererBase8
   {
      
      private static const TF_COLOR_NORMAL:Array = [5599093,9583135];
      
      private static const TF_COLOR_FOCUS:Array = [16777215,15984074];
      
      public var myBgNormal:MovieClip;
      
      public var myBgFocus:MovieClip;
      
      public function ComboboxItemRenderer()
      {
         super();
      }
      
      override protected function onInit() : void
      {
         super.onInit();
         this.onStyleChangeForMatchType();
      }
      
      override public function get height() : Number
      {
         return Math.round(this.myHitArea.height);
      }
      
      override protected function setToNormal(cTween:Boolean = true) : void
      {
         TweenLite.killTweensOf(this.myBgFocus);
         if(cTween == true)
         {
            TweenLite.to(this.myBgFocus,TweenParam.SPD_FADE,{"autoAlpha":0});
         }
         else
         {
            this.myBgFocus.alpha = 0;
         }
         this.myLabelTF.textColor = TF_COLOR_NORMAL[this.currentMatchType];
      }
      
      override protected function setToRollOver(cTween:Boolean = true) : void
      {
         TweenLite.killTweensOf(this.myBgFocus);
         if(cTween == true)
         {
            TweenLite.to(this.myBgFocus,TweenParam.SPD_FADE,{"autoAlpha":1});
         }
         else
         {
            this.myBgFocus.alpha = 1;
         }
         this.myLabelTF.textColor = TF_COLOR_FOCUS[this.currentMatchType];
      }
      
      override public function onStyleChangeForMatchType() : void
      {
         if(this._isFocusIn == true)
         {
            this.myLabelTF.textColor = TF_COLOR_NORMAL[this.currentMatchType];
         }
         else
         {
            this.myLabelTF.textColor = TF_COLOR_FOCUS[this.currentMatchType];
         }
         z;
         this.myBgNormal.gotoAndStop(this.currentMatchType + 1);
         this.myBgFocus.gotoAndStop(this.currentMatchType + 1);
      }
   }
}

