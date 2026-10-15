package codo.objects
{
   public class HostageChampionObj extends CustomObject
   {
      
      public var id:int;
      
      public var name:String;
      
      public var desc:String;
      
      public var image:String;
      
      public var icon:String;
      
      public var primary:Vector.<ProductObj>;
      
      public var secondary:Vector.<ProductObj>;
      
      public var lethal:ProductObj;
      
      public var tactical:ProductObj;
      
      public var killstreak:ProductObj;
      
      public var perks:Vector.<ProductObj>;
      
      public function HostageChampionObj(cObj:Object = null)
      {
         super(cObj);
      }
   }
}

