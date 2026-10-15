package codo.views.fsgHudTop3PlayerView_parts
{
   import codo.localization.DictMatchResults;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class FsgHudTop3PlayersViewRobberyDetail extends MovieClip
   {
      
      public var myKillsLabel:TextField;
      
      public var myGoldsLabel:TextField;
      
      public var myKillsValue:TextField;
      
      public var myGoldsValue:TextField;
      
      public function FsgHudTop3PlayersViewRobberyDetail()
      {
         super();
         this.myKillsLabel.text = DictMatchResults.MATCH_ELIMINATE_ENEMIES;
         this.myGoldsLabel.text = DictMatchResults.MATCH_ROBBERY_OBTAIN_GOLDS;
      }
   }
}

