package codo.views.wargodMatchResult_parts
{
   import flash.display.MovieClip;
   
   public class Title extends WarGodAnimateElement
   {
      
      private static const START_FRAME:int = 1;
      
      private static const END_FRAME:int = 40;
      
      public var myText:MovieClip;
      
      public function Title()
      {
         super();
      }
      
      override public function startAni() : void
      {
         super.startAni();
         gotoAndPlay(START_FRAME);
      }
      
      override public function stopAni() : void
      {
         super.stopAni();
         gotoAndStop(END_FRAME);
      }
      
      public function setText(phaseName:String) : void
      {
         this.myText.myTF.text = phaseName;
      }
   }
}

