package codo.views.wargod_parts
{
   import codo.base.BaseSubElement;
   import codo.constants.BCEvent;
   import codo.constants.DataID;
   import codo.event.ParaEvent;
   import codo.objects.WarGodMatchObj;
   import codo.objects.WarGodPlayerObj;
   
   public class WarGodMatchHistoryPanel extends BaseSubElement
   {
      
      public var myMatch0:MatchLogMetro;
      
      public var myMatch1:MatchLogMetro;
      
      public var myMatch2:MatchLogMetro;
      
      public var myMatch3:MatchLogMetro;
      
      public var myMatch4:MatchLogMetro;
      
      public var myMatch5:MatchLogMetro;
      
      public var myMatch6:MatchLogMetro;
      
      public var myMatch7:MatchLogMetro;
      
      public var myMatch8:MatchLogMetro;
      
      public var myMatch9:MatchLogMetro;
      
      public var myMatches:Array;
      
      public function WarGodMatchHistoryPanel()
      {
         super();
         this.initStage();
      }
      
      private function initStage() : void
      {
         this.myMatches = [this.myMatch0,this.myMatch1,this.myMatch2,this.myMatch3,this.myMatch4,this.myMatch5,this.myMatch6,this.myMatch7,this.myMatch8,this.myMatch9];
         for(var i:int = 0; i < this.myMatches.length; i++)
         {
            this.myMatches[i].index = i;
         }
      }
      
      override public function active() : void
      {
         super.active();
         var playerObj:WarGodPlayerObj = getDP(DataID.PLAYER_WARGOD_DATA);
         if(Boolean(playerObj))
         {
            this.onGetPlayerWarGodData(playerObj);
         }
         listen(BCEvent.EVT_WARGOD_OPENING_STATE_CHANGED,this.onWarGodOpeningStateChanged);
      }
      
      override public function deactive() : void
      {
         super.deactive();
         unlisten(BCEvent.EVT_WARGOD_OPENING_STATE_CHANGED,this.onWarGodOpeningStateChanged);
      }
      
      private function onWarGodOpeningStateChanged(cEvt:ParaEvent) : void
      {
         var playerObj:WarGodPlayerObj = getDP(DataID.PLAYER_WARGOD_DATA);
         if(Boolean(playerObj))
         {
            this.onGetPlayerWarGodData(playerObj);
         }
      }
      
      private function onGetPlayerWarGodData(playerObj:WarGodPlayerObj) : void
      {
         var matchObj:WarGodMatchObj = null;
         var matchHistory:Array = playerObj.matchHistroy;
         var numMatchHistroy:int = playerObj.numMatchHistroy;
         for(var i:int = 0; i < numMatchHistroy; i++)
         {
            matchObj = playerObj.matchHistroy[i];
            if(i < numMatchHistroy - 1)
            {
               matchObj.ladderScoreAfterMatch = matchHistory[i + 1].ladderScoreBeforeMatch;
            }
            else
            {
               matchObj.ladderScoreAfterMatch = playerObj.score;
            }
            this.myMatches[playerObj.numMatchHistroy - i - 1].setData(matchObj);
         }
         for(var cardIndex:int = i; cardIndex < this.myMatches.length; cardIndex++)
         {
            this.myMatches[cardIndex].setData(null);
         }
      }
   }
}

