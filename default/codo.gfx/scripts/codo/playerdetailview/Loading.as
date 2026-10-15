package codo.playerdetailview
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol5168")]
   public dynamic class Loading extends MovieClip
   {
      
      public var dotAnim:MovieClip;
      
      public function Loading()
      {
         super();
         addFrameScript(45,this.frame46);
      }
      
      internal function frame46() : *
      {
         gotoAndPlay(1);
      }
   }
}

