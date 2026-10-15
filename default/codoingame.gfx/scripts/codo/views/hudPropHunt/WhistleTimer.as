package codo.views.hudPropHunt
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class WhistleTimer extends MovieClip
   {
      
      public var myLabel:TextField;
      
      public var myFinalLabel:TextField;
      
      public var myTime:TextField;
      
      public function WhistleTimer()
      {
         super();
         this.myLabel.text = "@PH_WHISTILE_IN";
         this.myFinalLabel.text = "@PH_FINAL_WHISTLE";
      }
   }
}

