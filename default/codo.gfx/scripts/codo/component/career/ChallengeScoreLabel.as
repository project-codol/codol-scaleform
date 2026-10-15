package codo.component.career
{
   import codo.style.GlobalGuide;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class ChallengeScoreLabel extends MovieClip
   {
      
      private static const COMPLETED_COLOR:uint = 6513507;
      
      private static const INCOMPLETE_COLOR:uint = 16777215;
      
      public var myScore:TextField;
      
      public var myBG:MovieClip;
      
      public function ChallengeScoreLabel()
      {
         super();
      }
      
      public function setText(text:String) : void
      {
         this.myScore.text = text;
      }
      
      public function setCompleted(beCompleted:Boolean) : void
      {
         this.myScore.textColor = beCompleted ? COMPLETED_COLOR : INCOMPLETE_COLOR;
         if(beCompleted)
         {
            this.myBG.gotoAndStop("active");
            this.myScore.textColor = GlobalGuide.WHITE;
         }
         else
         {
            this.myBG.gotoAndStop("inactive");
            this.myScore.textColor = GlobalGuide.CODO_GRAY_LIGHT;
         }
      }
   }
}

