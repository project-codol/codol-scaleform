package components.ingameaar_part
{
   import codo.constants.DataInGameID;
   import codo.localization.Dict;
   import codo.localization.DictInGame;
   import codo.objects.ScoreboardObj;
   import flash.text.TextField;
   import shaui.component.core.UIComponent;
   
   public class ScoreboardTeamScoresBar extends UIComponent
   {
      
      public var myVictoryDefeatTF:TextField;
      
      public var myScarScoreTF:TextField;
      
      public var myScarNameTF:TextField;
      
      public var myTF141ScoreTF:TextField;
      
      public var myTF141NameTF:TextField;
      
      private var _colorVictory:uint;
      
      private var _colorTie:uint;
      
      private var _colorDefeat:uint;
      
      public function ScoreboardTeamScoresBar()
      {
         super();
         this._colorVictory = this.myVictoryDefeatTF.textColor;
         this._colorTie = 16765440;
         this._colorDefeat = 12724256;
         this.myTF141NameTF.text = Dict.FORCE_TF;
         this.myScarNameTF.text = Dict.FORCE_SC;
      }
      
      public function SetData(data:ScoreboardObj, matchResult:int) : void
      {
         var resultText:String = null;
         var color:uint = 0;
         this.myTF141ScoreTF.text = data.alliesScore.toString();
         this.myScarScoreTF.text = data.axisScore.toString();
         if(matchResult == DataInGameID.MATCH_RESULT_VICTORY)
         {
            resultText = DictInGame.ResultVictory;
            color = this._colorVictory;
         }
         else if(matchResult == DataInGameID.MATCH_RESULT_DEFEAT)
         {
            resultText = DictInGame.ResultDefeat;
            color = this._colorDefeat;
         }
         else
         {
            resultText = DictInGame.ResultTie;
            color = this._colorTie;
         }
         this.myVictoryDefeatTF.text = resultText;
         this.myVictoryDefeatTF.textColor = color;
      }
   }
}

