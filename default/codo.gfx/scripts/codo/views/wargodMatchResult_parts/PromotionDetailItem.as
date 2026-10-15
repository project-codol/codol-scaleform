package codo.views.wargodMatchResult_parts
{
   import codo.common.CFunctionCommonContainer;
   import codo.constants.DataID;
   import codo.localization.DictWarGod;
   import codo.manager.DataManager;
   import codo.objects.UnlockItemObj;
   import codo.objects.WarGodMatchObj;
   import codo.objects.WarGodMatchResultObj;
   import flash.display.MovieClip;
   import fsg.util.FsgImageHolder;
   
   public class PromotionDetailItem extends MovieClip
   {
      
      public var myMinusScore:MovieClip;
      
      public var myAddScore:MovieClip;
      
      public var myDescription:MovieClip;
      
      public var myChallenge:MovieClip;
      
      public function PromotionDetailItem()
      {
         super();
      }
      
      public function setData(isJuniorWarGod:Boolean, type:int, score:int, roundAwards:Vector.<UnlockItemObj> = null) : void
      {
         var i:int = 0;
         var warGodMathResultData:WarGodMatchResultObj = null;
         this.myAddScore.visible = score > 0;
         this.myMinusScore.visible = score < 0;
         this.myAddScore.myTF.text = this.addScorePrefix(score);
         this.myMinusScore.myTF.text = this.addScorePrefix(score);
         if(isJuniorWarGod)
         {
            if(type == WarGodMatchResultObj.PROMOTION_SCORE_DETAIL_WINLOSE)
            {
               this.myChallenge.visible = false;
               this.myDescription.visible = true;
               this.myDescription.myTF.text = score > 0 ? DictWarGod.PROMOTION_SCORE_REASON_WIN : DictWarGod.PROMOTION_SCORE_REASON_LOSE;
            }
            else if(type == WarGodMatchResultObj.PROMOTION_SCORE_DETAIL_PERFORMANCE)
            {
               this.myChallenge.visible = false;
               this.myDescription.visible = true;
               this.myDescription.myTF.text = DictWarGod.PROMOTION_SCORE_REASON_PERFORMANCE;
            }
            else if(type == WarGodMatchResultObj.PROMOTION_SCORE_DETAIL_MEDAL)
            {
               this.myChallenge.visible = true;
               this.myDescription.visible = false;
               if(Boolean(roundAwards))
               {
                  i = 0;
                  while(i < roundAwards.length && i < this.myChallenge.numChildren)
                  {
                     (this.myChallenge["myItem" + String(i)] as FsgImageHolder).setImage(roundAwards[i].imageURL);
                     i++;
                  }
               }
            }
            else if(type == WarGodMatchResultObj.PROMOTION_SCORE_DETAIL_PUNISH)
            {
               this.myChallenge.visible = false;
               this.myDescription.visible = true;
               this.myDescription.myTF.text = DictWarGod.PROMOTION_SCORE_REASON_PUNISH;
            }
         }
         else if(type == WarGodMatchResultObj.SENIOR_WARGOD_PROMOTION_SCORE_DETAIL_WINLOSE)
         {
            warGodMathResultData = DataManager.getInstance().getDP(DataID.LOBBY_SUMMARY_WARGOD);
            this.myChallenge.visible = false;
            this.myDescription.visible = true;
            switch(warGodMathResultData.result)
            {
               case WarGodMatchObj.RESULT_LOSE:
                  this.myDescription.myTF.text = DictWarGod.PROMOTION_SCORE_REASON_LOSE;
                  break;
               case WarGodMatchObj.RESULT_WIN:
                  this.myDescription.myTF.text = DictWarGod.PROMOTION_SCORE_REASON_WIN;
                  break;
               case WarGodMatchObj.RESULT_DRAW:
                  this.myDescription.myTF.text = DictWarGod.PROMOTION_SCORE_REASON_DRAW;
                  break;
               case WarGodMatchObj.RESULT_LEAVE:
                  this.myDescription.myTF.text = DictWarGod.PROMOTION_SCORE_REASON_LEAVE;
            }
         }
         else if(type == WarGodMatchResultObj.SENIOR_WARGOD_PROMOTION_SCORE_DETAIL_PUNISH)
         {
            this.myChallenge.visible = false;
            this.myDescription.visible = true;
            this.myDescription.myTF.text = DictWarGod.PROMOTION_SCORE_REASON_PUNISH;
         }
         else if(CFunctionCommonContainer.Dvar_GetString("ui_gametype") == "sd")
         {
            if(type == WarGodMatchResultObj.SENIOR_WARGOD_PROMOTION_SCORE_DETAIL_SD_OPERATE_BOMB)
            {
               this.myChallenge.visible = false;
               this.myDescription.visible = true;
               this.myDescription.myTF.text = DictWarGod.PROMOTION_SCORE_REASON_OPERATE_BOMB;
            }
            else if(type == WarGodMatchResultObj.SENIOR_WARGOD_PROMOTION_SCORE_DETAIL_SD_KILL_ENEMY)
            {
               this.myChallenge.visible = false;
               this.myDescription.visible = true;
               this.myDescription.myTF.text = DictWarGod.PROMOTION_SCORE_REASON_KILL_ENEMY;
            }
            else if(type == WarGodMatchResultObj.SENIOR_WARGOD_PROMOTION_SCORE_DETAIL_SD_KILL_LOTS_OF_ENEMY)
            {
               this.myChallenge.visible = false;
               this.myDescription.visible = true;
               this.myDescription.myTF.text = DictWarGod.PROMOTION_SCORE_REASON_KILL_LOTS_OF_ENEMY;
            }
         }
         else if(CFunctionCommonContainer.Dvar_GetString("ui_gametype") == "dom")
         {
            if(type == WarGodMatchResultObj.SENIOR_WARGOD_PROMOTION_SCORE_DETAIL_DOM_DEFEND_POINT)
            {
               this.myChallenge.visible = false;
               this.myDescription.visible = true;
               this.myDescription.myTF.text = DictWarGod.PROMOTION_SCORE_REASON_DEFEND_POINT;
            }
            else if(type == WarGodMatchResultObj.SENIOR_WARGOD_PROMOTION_SCORE_DETAIL_DOM_CAPTURE_POINT)
            {
               this.myChallenge.visible = false;
               this.myDescription.visible = true;
               this.myDescription.myTF.text = DictWarGod.PROMOTION_SCORE_REASON_CAPTURE_POINT;
            }
            else if(type == WarGodMatchResultObj.SENIOR_WARGOD_PROMOTION_SCORE_DETAIL_DOM_KILL_ENEMY)
            {
               this.myChallenge.visible = false;
               this.myDescription.visible = true;
               this.myDescription.myTF.text = DictWarGod.PROMOTION_SCORE_REASON_KILL_ENEMY;
            }
            else if(type == WarGodMatchResultObj.SENIOR_WARGOD_PROMOTION_SCORE_DETAIL_DOM_KILL_LOTS_OF_ENEMY)
            {
               this.myChallenge.visible = false;
               this.myDescription.visible = true;
               this.myDescription.myTF.text = DictWarGod.PROMOTION_SCORE_REASON_KILL_LOTS_OF_ENEMY;
            }
         }
      }
      
      public function startAnimation() : void
      {
         gotoAndPlay(1);
      }
      
      private function addScorePrefix(score:int) : String
      {
         var prefix:String = score > 0 ? "+" : "";
         return prefix + String(score);
      }
   }
}

