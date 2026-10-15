package codo.objects
{
   public class SpyGameMessageObj extends CustomObject
   {
      
      public var type:int = 0;
      
      public var message:String;
      
      public var victim:String;
      
      public var victimRole:int = 0;
      
      public var victimNickname:String;
      
      public var inspector:String;
      
      public var inspectorNickname:String;
      
      public var murder:String;
      
      public var murderNickname:String;
      
      public var murderRole:int;
      
      public var nickname:String;
      
      public var name:String;
      
      public var role:int;
      
      public function SpyGameMessageObj(cObj:Object = null)
      {
         super(cObj);
      }
   }
}

