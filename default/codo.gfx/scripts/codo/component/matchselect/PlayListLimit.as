package codo.component.matchselect
{
   import codo.component.TextField;
   import codo.localization.DictRoom;
   import codo.style.MatchSelectGuide;
   import flash.display.MovieClip;
   
   public class PlayListLimit extends MovieClip
   {
      
      public var myPlayersLabel:TextField;
      
      public var myLevelLabel:TextField;
      
      public var myMapsLabel:TextField;
      
      public var myPlayersText:TextField;
      
      public var myLevelText:TextField;
      
      public var myMapsText:TextField;
      
      public function PlayListLimit()
      {
         super();
         this.myPlayersLabel.textStyle = MatchSelectGuide.styleLimitLabel;
         this.myPlayersLabel.width = 91;
         this.myPlayersLabel.height = 25;
         this.myPlayersLabel.x = 0;
         this.myPlayersLabel.y = 3;
         this.myPlayersLabel.text = DictRoom.LIST_LABEL_PLAYER_MIN_MAX;
         this.myLevelLabel.textStyle = MatchSelectGuide.styleLimitLabel;
         this.myLevelLabel.width = 91;
         this.myLevelLabel.height = 25;
         this.myLevelLabel.x = 97;
         this.myLevelLabel.y = 3;
         this.myLevelLabel.text = DictRoom.PLAYLIST_OPEN_AT;
         this.myMapsLabel.textStyle = MatchSelectGuide.styleLimitLabel;
         this.myMapsLabel.width = 91;
         this.myMapsLabel.height = 25;
         this.myMapsLabel.x = 194;
         this.myMapsLabel.y = 3;
         this.myMapsLabel.text = DictRoom.GAMEMODES_NUM_MAPS;
         this.myPlayersText.textStyle = MatchSelectGuide.styleLimitText;
         this.myPlayersText.width = 91;
         this.myPlayersText.height = 37;
         this.myPlayersText.x = 0;
         this.myPlayersText.y = 37;
         this.myLevelText.textStyle = MatchSelectGuide.styleLimitText;
         this.myLevelText.width = 91;
         this.myLevelText.height = 37;
         this.myLevelText.x = 97;
         this.myLevelText.y = 37;
         this.myMapsText.textStyle = MatchSelectGuide.styleLimitText;
         this.myMapsText.width = 91;
         this.myMapsText.height = 37;
         this.myMapsText.x = 194;
         this.myMapsText.y = 37;
      }
      
      public function setPlayersLimit(value:String) : void
      {
         this.myPlayersText.text = value;
      }
      
      public function setLevelLimit(value:String) : void
      {
         this.myLevelText.text = value;
      }
      
      public function setMapsLimit(value:String) : void
      {
         this.myMapsText.text = value;
      }
   }
}

