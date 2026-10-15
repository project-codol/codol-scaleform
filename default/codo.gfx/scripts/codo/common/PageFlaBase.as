package codo.common
{
   import flash.display.MovieClip;
   
   public dynamic class PageFlaBase extends MovieClip
   {
      
      public var myOptionsPanel:fsgOptionsView;
      
      public function PageFlaBase()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      internal function frame1() : *
      {
         stop();
      }
   }
}

