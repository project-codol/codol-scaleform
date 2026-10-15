package codo.objects
{
   public class ActivityData
   {
      
      public static const TYPE_ITEM:int = 1;
      
      public static const TYPE_XP:int = 2;
      
      public static const TYPE_GP:int = 3;
      
      public static const TYPE_TCMSG:int = 4;
      
      public var type:int;
      
      public var xp:int;
      
      public var gp:int;
      
      public var item:Object;
      
      public function ActivityData(type:int, xp:int, gp:int, item:Object)
      {
         super();
         this.type = type;
         this.xp = xp;
         this.gp = gp;
         this.item = item;
      }
   }
}

