package codo.views.fsgHudTop3PlayerView_parts
{
   import codo.localization.Dict;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class FsgHudTop3PlayersViewKillsAndDeaths extends MovieClip
   {
      
      public var myKills:TextField;
      
      public var myKillsStatic:TextField;
      
      public var myDeaths:TextField;
      
      public var myDeathsStatic:TextField;
      
      private var mKills:int;
      
      private var mDeaths:int;
      
      public function FsgHudTop3PlayersViewKillsAndDeaths()
      {
         super();
         this.myKillsStatic.text = Dict.KILL;
         this.myDeathsStatic.text = Dict.DEATH;
         this.mKills = this.mDeaths = 0;
         this.updateLayout();
      }
      
      public function set kills(kills:int) : void
      {
         this.mKills = kills;
         this.updateLayout();
      }
      
      public function set deaths(deaths:int) : void
      {
         this.mDeaths = deaths;
         this.updateLayout();
      }
      
      private function updateLayout() : void
      {
         this.myKills.text = this.mKills.toString();
         this.myDeaths.text = this.mDeaths.toString();
         this.myKills.x = 0;
         this.myKillsStatic.x = this.myKills.textWidth + 4;
         this.myDeaths.x = this.myKillsStatic.x + this.myKillsStatic.textWidth + 4;
         this.myDeathsStatic.x = this.myDeaths.x + this.myDeaths.textWidth + 4;
      }
   }
}

