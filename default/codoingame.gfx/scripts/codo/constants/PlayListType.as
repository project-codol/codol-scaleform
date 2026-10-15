package codo.constants
{
   public class PlayListType
   {
      
      public static const NONE:uint = 0;
      
      public static const RANKED:uint = 1;
      
      public static const COMBAT:uint = 2;
      
      public static const TUTORIAL:uint = 3;
      
      public static const SURVIVAL:uint = 4;
      
      public static const CYBORG:uint = 5;
      
      public static const ZARENA:uint = 6;
      
      public static const ZOMBIESURVIVAL:uint = 7;
      
      public static const ZCHAMP:uint = 8;
      
      public static const ZHUNTER:uint = 9;
      
      public static const TD:uint = 10;
      
      public static const PVE_TYPES:Vector.<uint> = new <uint>[SURVIVAL,CYBORG,ZARENA,ZOMBIESURVIVAL,ZCHAMP,ZHUNTER,TD];
      
      public static const SPY_PLAYLIST_ID:uint = 142;
      
      public function PlayListType()
      {
         super();
      }
      
      public static function isPveType(type:uint) : Boolean
      {
         for(var i:int = 0; i < PVE_TYPES.length; i++)
         {
            if(type == PVE_TYPES[i])
            {
               return true;
            }
         }
         return false;
      }
   }
}

