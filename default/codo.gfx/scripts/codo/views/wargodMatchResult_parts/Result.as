package codo.views.wargodMatchResult_parts
{
   import codo.objects.WarGodMatchObj;
   import codo.objects.WarGodMatchResultObj;
   import codo.objects.WarGodPlayerObj;
   import codo.style.GlobalGuide;
   import codo.utils.SoundUtil;
   import codo.utils.WarGodUtility;
   import flash.display.MovieClip;
   import flash.geom.ColorTransform;
   
   public class Result extends WarGodAnimateElement
   {
      
      protected static const START_FRAME:int = 1;
      
      protected static const END_FRAME:int = 25;
      
      protected static const WIN_GLOW_FRAME:int = 1;
      
      protected static const LOSE_GLOW_FRAME:int = 2;
      
      protected static const DRAW_GLOW_FRAME:int = 3;
      
      public var myText:MovieClip;
      
      public var myStarsCount:MovieClip;
      
      public var myStar:MovieClip;
      
      public var myPointerArrow0:MovieClip;
      
      public var myPointerArrow1:MovieClip;
      
      public var myUpperOutline:MovieClip;
      
      public var myLowerOutline:MovieClip;
      
      public var myBGColor:MovieClip;
      
      public function Result()
      {
         super();
      }
      
      override public function startAni() : void
      {
         super.startAni();
         gotoAndPlay(START_FRAME);
         if(Boolean(this.myStar))
         {
            this.myStar.gotoAndPlay(START_FRAME);
         }
         SoundUtil.getInstance().playSound("ui_wgmr_dropdown_menu_appear");
      }
      
      override public function stopAni() : void
      {
         super.stopAni();
         gotoAndStop(END_FRAME);
      }
      
      public function setResult(data:WarGodMatchResultObj) : void
      {
         var newColor:ColorTransform = new ColorTransform();
         if(data.result == WarGodMatchObj.RESULT_WIN)
         {
            this.myText.gotoAndStop(WIN_GLOW_FRAME);
            this.myStarsCount.gotoAndStop(WIN_GLOW_FRAME);
            this.myPointerArrow0.gotoAndStop(WIN_GLOW_FRAME);
            this.myPointerArrow1.gotoAndStop(WIN_GLOW_FRAME);
            this.myUpperOutline.gotoAndStop(WIN_GLOW_FRAME);
            this.myLowerOutline.gotoAndStop(WIN_GLOW_FRAME);
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
            this.myText.gotoAndStop(DRAW_GLOW_FRAME);
            this.myStarsCount.gotoAndStop(DRAW_GLOW_FRAME);
            this.myPointerArrow0.gotoAndStop(DRAW_GLOW_FRAME);
            this.myPointerArrow1.gotoAndStop(DRAW_GLOW_FRAME);
            this.myUpperOutline.gotoAndStop(DRAW_GLOW_FRAME);
            this.myLowerOutline.gotoAndStop(DRAW_GLOW_FRAME);
            newColor.color = GlobalGuide.CODO_BLUE_HIGHLIGHT;
         }
         else
         {
            this.myText.gotoAndStop(LOSE_GLOW_FRAME);
            this.myStarsCount.gotoAndStop(LOSE_GLOW_FRAME);
            this.myPointerArrow0.gotoAndStop(LOSE_GLOW_FRAME);
            this.myPointerArrow1.gotoAndStop(LOSE_GLOW_FRAME);
            this.myUpperOutline.gotoAndStop(LOSE_GLOW_FRAME);
            this.myLowerOutline.gotoAndStop(LOSE_GLOW_FRAME);
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
         this.myText.myColorText.myTF.text = WarGodUtility.getLocalizedMatchResult(data.result);
         this.myBGColor.transform.colorTransform = newColor;
         var starChangeForDisplay:int = data.numStarChangeDueToResult + data.numStarChangeDueToPromotion;
         var prefix:String = starChangeForDisplay < 0 ? "-" : "+";
         this.myStarsCount.myColorText.myTF.text = prefix + String(Math.abs(starChangeForDisplay));
         var padding:Number = 6;
         this.myStarsCount.myColorText.x = -(this.myStar.width * 0.5);
         this.myStar.x = this.myStarsCount.x + this.myStarsCount.width * 0.5 + this.myStarsCount.myColorText.myTF.textWidth * 0.5 + padding + this.myStarsCount.myColorText.x;
      }
   }
}

