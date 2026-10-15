package codo.component
{
   import flash.display.MovieClip;
   
   public class LoadingSpinner extends MovieClip
   {
      
      public var myAnimation:MovieClip;
      
      public function LoadingSpinner()
      {
         super();
      }
      
      override public function set visible(value:Boolean) : void
      {
         super.visible = value;
         if(value)
         {
            this.myAnimation.gotoAndPlay(1);
         }
         else
         {
            this.myAnimation.gotoAndStop(1);
         }
      }
   }
}

