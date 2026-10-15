package codo.objects
{
   public dynamic class TutorialVideoObj extends CustomObject
   {
      
      public var name:String;
      
      public var width:uint;
      
      public var height:uint;
      
      public var length:uint;
      
      public var picURL:String;
      
      public var isReady:Boolean = false;
      
      public function TutorialVideoObj(cObj:Object = null)
      {
         super(cObj);
      }
   }
}

