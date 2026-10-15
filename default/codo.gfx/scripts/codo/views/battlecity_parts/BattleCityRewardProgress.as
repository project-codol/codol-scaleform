package codo.views.battlecity_parts
{
   import codo.constants.GameInfo;
   import codo.localization.DictBattleCity;
   import codo.style.GlobalGuide;
   import codo.utils.LocalizeUtil;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class BattleCityRewardProgress extends MovieClip
   {
      
      public var myFillBar:MovieClip;
      
      public var myMaskBar:MovieClip;
      
      public var myProgressValue:TextField;
      
      public var myBoxNumber:TextField;
      
      public var myLeftProgress:TextField;
      
      public function BattleCityRewardProgress()
      {
         super();
      }
      
      public function setProgress(currentValue:int, fullValue:int) : void
      {
         var championPointsToGo:String = null;
         if(Boolean(this.myProgressValue))
         {
            this.myProgressValue.text = String(currentValue) + "/" + String(fullValue);
         }
         var zeroProgressX:Number = this.myMaskBar.x - this.myFillBar.width;
         var fullProgressX:Number = this.myMaskBar.x;
         var progress:Number = currentValue / fullValue;
         var progressX:Number = zeroProgressX + (fullProgressX - zeroProgressX) * progress;
         this.myFillBar.x = progressX;
         if(Boolean(this.myLeftProgress))
         {
            championPointsToGo = String(fullValue - currentValue);
            LocalizeUtil.paramCustomizeFormat(this.myLeftProgress,DictBattleCity.BATTLECITY_REWARD_PROGRESS_REMAIN,[championPointsToGo],this.leftFomatter);
         }
      }
      
      public function setBoxNumber(number:int) : void
      {
         LocalizeUtil.paramCustomizeFormat(this.myBoxNumber,DictBattleCity.BATTLECITY_NUM_BOX_GOTTEN,[String(number)],this.leftFomatter);
      }
      
      private function leftFomatter(tfm:TextFormat, paraIndex:int) : void
      {
         tfm.font = GameInfo.GAME_FONT_AENCY_FB;
         tfm.color = GlobalGuide.GREEN;
      }
   }
}

