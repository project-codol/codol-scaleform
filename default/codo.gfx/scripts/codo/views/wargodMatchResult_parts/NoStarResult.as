package codo.views.wargodMatchResult_parts
{
   import codo.objects.WarGodMatchObj;
   import codo.objects.WarGodMatchResultObj;
   import codo.objects.WarGodPlayerObj;
   import codo.style.GlobalGuide;
   import codo.utils.WarGodUtility;
   import flash.geom.ColorTransform;
   
   public class NoStarResult extends Result
   {
      
      public function NoStarResult()
      {
         super();
      }
      
      override public function setResult(data:WarGodMatchResultObj) : void
      {
         var newColor:ColorTransform = null;
         newColor = new ColorTransform();
         if(data.result == WarGodMatchObj.RESULT_WIN)
         {
            myText.gotoAndStop(WIN_GLOW_FRAME);
            myUpperOutline.gotoAndStop(WIN_GLOW_FRAME);
            myLowerOutline.gotoAndStop(WIN_GLOW_FRAME);
            newColor.color = GlobalGuide.GREEN;
            if(data.beforePhase == WarGodPlayerObj.PHASE_PLACEMENT)
            {
               mSoundEffect = "ui_placement_win";
            }
            else
            {
               mSoundEffect = "ui_star_match_won_prompt";
            }
         }
         else if(data.result == WarGodMatchObj.RESULT_DRAW)
         {
            myText.gotoAndStop(DRAW_GLOW_FRAME);
            myUpperOutline.gotoAndStop(DRAW_GLOW_FRAME);
            myLowerOutline.gotoAndStop(DRAW_GLOW_FRAME);
            newColor.color = GlobalGuide.CODO_BLUE_HIGHLIGHT;
         }
         else
         {
            myText.gotoAndStop(LOSE_GLOW_FRAME);
            myUpperOutline.gotoAndStop(LOSE_GLOW_FRAME);
            myLowerOutline.gotoAndStop(LOSE_GLOW_FRAME);
            newColor.color = GlobalGuide.CODO_RED;
            if(data.beforePhase == WarGodPlayerObj.PHASE_PLACEMENT)
            {
               mSoundEffect = "ui_placement_lose";
            }
            else
            {
               mSoundEffect = "ui_star_match_lose_prompt";
            }
         }
         myText.myColorText.myTF.text = WarGodUtility.getLocalizedMatchResult(data.result);
         myBGColor.transform.colorTransform = newColor;
      }
   }
}

