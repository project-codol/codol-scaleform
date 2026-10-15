package components
{
   import com.greensock.TweenLite;
   import components.interfaces.IUIComponent;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.text.TextField;
   
   public class CompareBar extends Sprite implements IUIComponent
   {
      
      protected static const TWEEN_SPD:Number = 0.4;
      
      public var myCurrentTF:TextField;
      
      public var myMask:Sprite;
      
      public var myCurrentBar:Sprite;
      
      public var myDifferentBar:MovieClip;
      
      public var myBg:Sprite;
      
      protected var _current:Number = 0;
      
      protected var _compare:Number = 0;
      
      protected var _compareAble:Boolean = false;
      
      public function CompareBar()
      {
         super();
         this.init();
         this.initListener();
      }
      
      protected function init() : void
      {
         if(this.myDifferentBar != null)
         {
            this.myDifferentBar.stop();
            this.myDifferentBar.visible = false;
         }
         if(this.myMask != null)
         {
            this.myCurrentBar.mask = this.myMask;
         }
      }
      
      protected function initListener() : void
      {
      }
      
      [Inspectable(type="Number",defaultValue="0")]
      public function set current(cRate:Number) : void
      {
         this._current = cRate;
         if(this.myCurrentTF != null)
         {
            this.myCurrentTF.text = String(Math.round(cRate * 100));
         }
         this.refresh();
      }
      
      public function get current() : Number
      {
         return this._current;
      }
      
      [Inspectable(type="Number",defaultValue="0")]
      public function set compare(cRate:Number) : void
      {
         if(!(cRate < 0 || cRate > 1))
         {
            if(isNaN(cRate))
            {
               cRate = 0;
            }
         }
         this._compare = cRate;
         this.refresh();
      }
      
      public function get compare() : Number
      {
         return this._compare;
      }
      
      [Inspectable(type="Boolean",defaultValue="false")]
      public function set compareAble(cSwi:Boolean) : void
      {
         this._compareAble = cSwi;
         this.refresh();
      }
      
      public function get different() : Number
      {
         return this._compare - this._current;
      }
      
      override public function get width() : Number
      {
         return this.myBg.width;
      }
      
      override public function get height() : Number
      {
         return this.myBg.height;
      }
      
      protected function refresh() : void
      {
         var diffRate:Number = NaN;
         if(this.myDifferentBar != null)
         {
            this.myDifferentBar.visible = this._compareAble;
         }
         if(this._compareAble == false)
         {
            if(this.myMask != null)
            {
               TweenLite.killTweensOf(this.myMask);
               TweenLite.to(this.myMask,TWEEN_SPD,{"scaleX":this._current});
            }
            else
            {
               TweenLite.killTweensOf(this.myCurrentBar);
               TweenLite.to(this.myCurrentBar,TWEEN_SPD,{"scaleX":this._current});
            }
         }
         else
         {
            diffRate = this._compare - this._current;
            if(this.myDifferentBar != null)
            {
               this.myDifferentBar.visible = diffRate != 0;
            }
            if(this.myMask != null)
            {
               TweenLite.killTweensOf(this.myMask);
               TweenLite.to(this.myMask,TWEEN_SPD,{
                  "scaleX":this._current,
                  "onUpdate":this.onCurrentBarTweenHandle
               });
            }
            else
            {
               TweenLite.killTweensOf(this.myCurrentBar);
               TweenLite.to(this.myCurrentBar,TWEEN_SPD,{
                  "scaleX":this._current,
                  "onUpdate":this.onCurrentBarTweenHandle
               });
            }
            if(this.myDifferentBar != null)
            {
               if(diffRate < 0)
               {
                  TweenLite.killTweensOf(this.myDifferentBar);
                  TweenLite.to(this.myDifferentBar,TWEEN_SPD,{"frame":Math.round((1 + diffRate) * 100)});
               }
               else if(diffRate == 0)
               {
                  TweenLite.killTweensOf(this.myDifferentBar);
                  TweenLite.to(this.myDifferentBar,TWEEN_SPD,{"frame":100});
               }
               else
               {
                  TweenLite.killTweensOf(this.myDifferentBar);
                  TweenLite.to(this.myDifferentBar,TWEEN_SPD,{"frame":100});
                  this.myDifferentBar.gotoAndStop(100 + Math.round(diffRate * 100));
               }
            }
         }
      }
      
      protected function onCurrentBarTweenHandle() : void
      {
         if(this.myDifferentBar != null)
         {
            if(this.myMask != null)
            {
               this.myDifferentBar.x = this.myMask.x + this.myMask.width;
            }
            else
            {
               this.myDifferentBar.x = this.myCurrentBar.x + this.myCurrentBar.width;
            }
         }
      }
      
      public function destroy() : void
      {
      }
   }
}

