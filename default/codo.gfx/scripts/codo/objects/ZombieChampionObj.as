package codo.objects
{
   public class ZombieChampionObj
   {
      
      public static const CLASS_SWORDSMAN:uint = 1;
      
      public static const CLASS_DEFENDER:uint = 2;
      
      public static const CLASS_MARKSMAN:uint = 3;
      
      public static const CLASS_BOMBER:uint = 4;
      
      public static const ORDERED_CLASSES:Array = [CLASS_SWORDSMAN,CLASS_DEFENDER,CLASS_MARKSMAN,CLASS_BOMBER];
      
      public var id:uint;
      
      public var name:String;
      
      public var bustImageURL:String;
      
      public var description:String;
      
      public var vitals:String;
      
      public var weaponImage:String;
      
      public var weaponName:String;
      
      public var skills:Vector.<ZombieChampionSkillObj>;
      
      public var index:int;
      
      public var useLargeImage:Boolean;
      
      public function ZombieChampionObj()
      {
         super();
      }
   }
}

