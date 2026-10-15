package codo.objects
{
   public dynamic class ScoreboardObj extends CustomObject
   {
      
      public var axisScore:int;
      
      public var alliesScore:int;
      
      public var axisPlayers:Array;
      
      public var alliesPlayers:Array;
      
      public var gametype:String;
      
      public var myTeam:int;
      
      public function ScoreboardObj(cObj:Object = null)
      {
         super(cObj);
         this.ForwardGametype(this.axisPlayers);
         this.ForwardGametype(this.alliesPlayers);
      }
      
      private function ForwardGametype(players:Array) : void
      {
         var i:int = 0;
         if(players != null)
         {
            for(i = 0; i < players.length; i++)
            {
               players[i].gametype = this.gametype;
            }
         }
      }
   }
}

