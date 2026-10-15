package codo.objects
{
   public dynamic class RoomOptionObj extends CustomObject
   {
      
      public static const DIFFICULTY_ENDLESS:String = "Endless";
      
      public var mode:String = "";
      
      public var modeTimeLimit:Number = 0;
      
      public var modeScoreLimit:int = 0;
      
      public var modeRoundLimit:int = 0;
      
      public var modeWinLimit:int = 0;
      
      public var modeRoundSwitch:int = 0;
      
      public var modeNumLives:int = 0;
      
      public var modePlayerRespawnDelay:Number = 0;
      
      public var modeWaveRespawnDelay:Number = 0;
      
      public var modeBombTimer:Number = 0;
      
      public var modePlantTime:Number = 0;
      
      public var modeDefuseTime:Number = 0;
      
      public var playerMaxHealth:int = 0;
      
      public var playerHealthRegenTime:int = 0;
      
      public var playerHealthRegenRate:Number = 0;
      
      public var teamFFType:int = 0;
      
      public var gameSpectateType:int = 0;
      
      public var gameAllowKillCam:Boolean = false;
      
      public var gameEnableHardcore:Boolean = false;
      
      public var gameForceUAV:Boolean = false;
      
      public var gameOnlyHeadshots:Boolean = false;
      
      public var gameEnableBuddyMode:Boolean = false;
      
      public var restrictWpnsAtStart:Boolean;
      
      public var combatHighHostileActionEnd:int = 0;
      
      public var botsAddAll:Boolean;
      
      public var clashMode:int = 0;
      
      public var clashFOV:int = 0;
      
      public var difficulty:int = 0;
      
      public var isEndless:Boolean = false;
      
      public var gameForbidSpawnBulletWeapon:Boolean = false;
      
      public var gameForbidSpawnGrenade:Boolean = false;
      
      public function RoomOptionObj(cObj:Object = null)
      {
         super(cObj);
      }
   }
}

