package codo_base_shared_fla
{
   import codo.shared.Popup;
   import flash.display.MovieClip;
   
   public dynamic class MainTimeline extends MovieClip
   {
      
      public var test:Popup;
      
      public function MainTimeline()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      internal function frame1() : *
      {
         this.test.setStyleNoFrame();
         this.test.height = 362;
      }
   }
}

