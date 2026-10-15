package
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol2450")]
   public dynamic class fsgToolWindowItem extends MovieClip
   {
      
      public var myHitArea:MovieClip;
      
      public var myText:MovieClip;
      
      public function fsgToolWindowItem()
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

