package components.ingameaar_part
{
   import codo.localization.Dict;
   import codo.localization.DictInGame;
   import flash.display.Sprite;
   import flash.text.TextField;
   
   public class AARPanelGamePoints extends AARPanelBase
   {
      
      public var myPlayerCountLabel:TextField;
      
      public var myPlayerCountTF:TextField;
      
      public var myPlayTimeLabel:TextField;
      
      public var myPlayTimeTF:TextField;
      
      public var myGamePointsTF:TextField;
      
      public var myGamePointsUnit:TextField;
      
      public var myListBox:Sprite;
      
      public function AARPanelGamePoints()
      {
         super();
         if(this.myPlayTimeTF != null)
         {
            this.myPlayTimeLabel.visible = this.myPlayTimeTF.visible = false;
         }
         SetHeader(DictInGame.AAR_GAMEPOINTS);
         if(this.myPlayerCountLabel != null)
         {
            this.myPlayerCountLabel.text = DictInGame.CYBORG_PLAYER_COUNT;
         }
         if(this.myPlayTimeLabel != null)
         {
            this.myPlayTimeLabel.text = DictInGame.CYBORG_PLAY_TIME;
         }
         if(this.myGamePointsUnit != null)
         {
            this.myGamePointsUnit.text = Dict.GP;
         }
      }
      
      public function SetPointsData(cScalesLineDat:String, cTotalPointsLineDat:String) : void
      {
         var scalesTokens:Array = null;
         var totalPointsTokens:Array = null;
         var totalGamePoints:int = 0;
         var gamePointScale:Number = 1;
         if(cScalesLineDat != null && cScalesLineDat.length > 0)
         {
            scalesTokens = cScalesLineDat.split("|");
            gamePointScale = parseFloat(scalesTokens[3]);
            if(isNaN(gamePointScale) || gamePointScale == 0)
            {
               gamePointScale = 1;
            }
         }
         if(cTotalPointsLineDat != null && cTotalPointsLineDat.length > 0)
         {
            totalPointsTokens = cTotalPointsLineDat.split("|");
            totalGamePoints = parseInt(totalPointsTokens[3]);
            if(isNaN(totalGamePoints))
            {
               totalGamePoints = 0;
            }
         }
         var scaledTotalGP:int = Math.round(totalGamePoints * gamePointScale);
         this.myGamePointsTF.text = scaledTotalGP.toString();
      }
   }
}

