package components.fsgpersistent_part
{
   import com.greensock.TweenMax;
   import com.greensock.easing.Linear;
   import flash.display.MovieClip;
   
   public class FsgWebReloadButton extends FsgButtonItem
   {
      
      public var mcArrow:MovieClip;
      
      private var mRotationTween:TweenMax;
      
      public function FsgWebReloadButton()
      {
         super();
      }
      
      public function StartAnimation() : void
      {
         if(this.mRotationTween == null)
         {
            this.mRotationTween = TweenMax.to(this.mcArrow,0.5,{
               "rotation":360,
               "repeat":-1,
               "ease":Linear.easeNone
            });
         }
      }
      
      public function StopAnimation() : void
      {
         if(this.mRotationTween != null)
         {
            this.mRotationTween.kill();
            this.mRotationTween = null;
            this.mcArrow.rotation = 0;
         }
      }
   }
}

