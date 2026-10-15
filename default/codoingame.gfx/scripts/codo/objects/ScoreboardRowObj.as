package codo.objects
{
   public dynamic class ScoreboardRowObj extends CustomObject
   {
      
      public var clantag:String;
      
      public var player:String;
      
      public var rank:int;
      
      public var level:int;
      
      public var wargod:int;
      
      public var score:int;
      
      public var kills:int;
      
      public var killStreak:int;
      
      public var deaths:int;
      
      public var assists:int;
      
      public var revives:int;
      
      public var headshots:int;
      
      public var prestige:int;
      
      public var objective1:int;
      
      public var objective2:int;
      
      public var ping:int;
      
      public var isSelf:Boolean;
      
      public var isDead:Boolean;
      
      public var isDeathInvisible:Boolean;
      
      public var qq_membership:int;
      
      public var netcafe:int;
      
      public var xpgained:int;
      
      public var gpgained:int;
      
      public var dwUserId:String;
      
      public var statusIcon:String;
      
      public var gametype:String;
      
      public function ScoreboardRowObj(cObj:Object = null)
      {
         super(cObj);
      }
   }
}

