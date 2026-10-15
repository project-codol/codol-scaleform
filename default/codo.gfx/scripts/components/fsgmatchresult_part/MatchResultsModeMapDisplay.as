package components.fsgmatchresult_part
{
   import codo.base.BaseSubElement;
   import codo.localization.DictClan;
   import codo.localization.DictMatchResults;
   import codo.objects.AARMapModeDisplayObj;
   import codo.utils.LocalizeUtil;
   import codo.utils.ScaleformUtil;
   import codo.utils.TimeUtil;
   import flash.display.Sprite;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import fsg.util.FsgImageHolder;
   
   public class MatchResultsModeMapDisplay extends BaseSubElement
   {
      
      public var myAwardMedal:Sprite;
      
      public var myMatchModeTF:TextField;
      
      public var myMatchMapTF:TextField;
      
      public var myMatchMapModeBkg:Sprite;
      
      public var myMapImage:FsgImageHolder;
      
      public var myMatchScore:MatchResultsModeMapDisplayStat;
      
      public var myMatchRound:MatchResultsModeMapDisplayStat;
      
      public var myMatchTime:MatchResultsModeMapDisplayStat;
      
      public function MatchResultsModeMapDisplay()
      {
         super();
         this.myAwardMedal.visible = false;
         this.myMatchModeTF.autoSize = this.myMatchMapTF.autoSize = TextFieldAutoSize.LEFT;
         deactive();
         if(this.inDebugMode)
         {
            this.setDisplayInfo(this.testMatchStatusData);
         }
      }
      
      public function setDisplayInfo(matchData:AARMapModeDisplayObj) : void
      {
         var LOCALIZE:Function = LocalizeUtil.localize;
         this.myMatchMapTF.text = LOCALIZE(matchData.mapName);
         this.myMatchModeTF.text = LOCALIZE(matchData.modeName);
         this.myMatchMapModeBkg.width = Math.max(this.myMatchMapTF.textWidth,this.myMatchModeTF.textWidth) + 24;
         this.myMapImage.setImage(matchData.mapImageURL);
         this.myAwardMedal.visible = matchData.isVictory;
         this.myMatchScore.setStatData(this.inDebugMode ? "总得分" : DictMatchResults.YOUR_SCORE,matchData.playerScore);
         this.myMatchRound.setStatData(this.inDebugMode ? "回合" : DictMatchResults.LABEL_ROUND,matchData.roundsPlayed);
         this.myMatchTime.setStatData(this.inDebugMode ? "时间" : DictClan.LIST_TITLE_TIMESTAMP,TimeUtil.sec2Str(matchData.timePlayed));
         this.myMatchTime.x = this.myMapImage.x + this.myMapImage.width - this.myMatchTime.width;
         var padding:int = (Math.ceil(this.myMapImage.width - (this.myMatchScore.width + this.myMatchTime.width)) - this.myMatchRound.width) * 0.5;
         this.myMatchRound.x = this.myMatchScore.x + this.myMatchScore.width + padding;
         this.myMatchRound.visible = matchData.roundsPlayed > 0;
         active();
      }
      
      private function get inDebugMode() : Boolean
      {
         return !ScaleformUtil.isScaleform;
      }
      
      private function get testMatchStatusData() : AARMapModeDisplayObj
      {
         return new AARMapModeDisplayObj("SHIPMENT","TEAM DEATHMATCH",3433,98522,"scaleform_ash/other/sfproto_mp_shipment");
      }
   }
}

