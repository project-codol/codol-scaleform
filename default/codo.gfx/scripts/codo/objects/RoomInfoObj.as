package codo.objects
{
   public dynamic class RoomInfoObj
   {
      
      public var force0:Array = [];
      
      public var force1:Array = [];
      
      public var force2:Array = [];
      
      public var maps:Array = [];
      
      public var selectedMapIndex:int = 0;
      
      public var showMapAlbum:Boolean = false;
      
      public var showChangeMapBtn:Boolean = false;
      
      public var enableChangeMapBtn:Boolean = false;
      
      public var showAdvancedOptions:Boolean = true;
      
      public var forceMaxPlayer:int = 0;
      
      public var forceMaxSpectator:int = 0;
      
      public var isHost:Boolean = false;
      
      public var isReady:Boolean = false;
      
      public var isInForce0:Boolean = true;
      
      public var isInForce1:Boolean = true;
      
      public var isInForce2:Boolean = true;
      
      public var showForce0:Boolean = true;
      
      public var showForce1:Boolean = true;
      
      public var showChangeForceBtn:Boolean = true;
      
      public var enableChangeForce0:Boolean = true;
      
      public var enableChangeForce1:Boolean = true;
      
      public var enableChangeForce2:Boolean = true;
      
      public var showPilot:Boolean = true;
      
      public var selectedPilotIndex:int = 0;
      
      public var pilots:Array = [];
      
      public var showMode:Boolean = true;
      
      public var selectedModeIndex:int = 0;
      
      public var modes:Array = [];
      
      public var votes:RoomVoteObj = null;
      
      public function RoomInfoObj()
      {
         super();
      }
   }
}

