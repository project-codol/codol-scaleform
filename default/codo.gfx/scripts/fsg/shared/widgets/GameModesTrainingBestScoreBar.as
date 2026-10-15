package fsg.shared.widgets
{
   import codo.localization.Dict;
   import codo.utils.LocalizeUtil;
   import components.fsggamemodes_part.*;
   import flash.display.Sprite;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   
   public class GameModesTrainingBestScoreBar extends Sprite
   {
      
      public var myBestScoreTF:TextField;
      
      public var myStar0:GameModesTrainingBestScoreStar;
      
      public var myStar1:GameModesTrainingBestScoreStar;
      
      public var myStar2:GameModesTrainingBestScoreStar;
      
      public var myStar3:GameModesTrainingBestScoreStar;
      
      public var myStar4:GameModesTrainingBestScoreStar;
      
      private var mStars:Vector.<GameModesTrainingBestScoreStar>;
      
      public function GameModesTrainingBestScoreBar()
      {
         super();
         this.myBestScoreTF.autoSize = TextFieldAutoSize.LEFT;
         this.myBestScoreTF.text = LocalizeUtil.localize(Dict.TRAINING_BEST_SCORE).toUpperCase();
         this.mStars = new <GameModesTrainingBestScoreStar>[this.myStar0,this.myStar1,this.myStar2,this.myStar3,this.myStar4];
      }
      
      public function hideBestScoreTF() : void
      {
         this.myBestScoreTF.visible = false;
      }
      
      public function formatDisplay(tf:TextFormat = null, starSize:int = -1, starYPos:uint = 0) : void
      {
         var i:uint = 0;
         var prevStar:GameModesTrainingBestScoreStar = null;
         var star:GameModesTrainingBestScoreStar = null;
         i = 0;
         var len:uint = this.mStars.length;
         var offset:uint = this.myBestScoreTF.x + this.myBestScoreTF.textWidth + 5;
         if(tf != null)
         {
            this.myBestScoreTF.setTextFormat(tf);
         }
         while(i < len)
         {
            star = this.mStars[i];
            if(starSize != -1)
            {
               star.height = star.width = starSize;
            }
            star.y = starYPos;
            if(i > 0)
            {
               prevStar = this.mStars[i - 1];
               star.x = prevStar.x + (prevStar.width + 2);
            }
            else
            {
               star.x = this.myBestScoreTF.visible ? offset : 10;
            }
            i++;
         }
      }
      
      public function set starsComplete(numComplete:uint) : void
      {
         var len:uint = numComplete;
         var i:uint = 0;
         for(this.resetStars(); i < len; )
         {
            this.mStars[i].setComplete(i);
            i++;
         }
      }
      
      private function resetStars() : void
      {
         var star:GameModesTrainingBestScoreStar = null;
         for each(star in this.mStars)
         {
            star.reset();
         }
      }
   }
}

