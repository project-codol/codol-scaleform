package codo.objects
{
   public class SpyUserObj extends UserObj
   {
      
      public var kills:int = 0;
      
      public var damage:int = 0;
      
      public var confirmCorpse:int = 0;
      
      public var nickname:String;
      
      public var role:int = 0;
      
      public var score:int = 0;
      
      public var kills2:int = 0;
      
      public function SpyUserObj(cObj:Object = null)
      {
         super(cObj);
      }
   }
}

