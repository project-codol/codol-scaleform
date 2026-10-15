package codo.objects
{
   public class ZombieArenaSpecializationObj
   {
      
      public static const SPECIALIZATION_NONE:int = -1;
      
      public static const SPECIALIZATION_TANK:int = 0;
      
      public static const SPECIALIZATION_SUPPORT:int = 1;
      
      public static const SPECIALIZATION_SNIPER:int = 2;
      
      public static const SPECIALIZATION_RAMPAGER:int = 3;
      
      public static const SPECIALIZATION_GAMBLER:int = 4;
      
      public var label:String;
      
      public var description:String;
      
      public var imageURL:String;
      
      public var specializationType:uint;
      
      public function ZombieArenaSpecializationObj(newspecializationType:int, newLabel:String, newDescription:String = null, newImageURL:String = null)
      {
         super();
         this.specializationType = newspecializationType;
         this.label = newLabel;
         this.description = newDescription;
         this.imageURL = newImageURL;
      }
   }
}

