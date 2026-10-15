package codo.objects
{
   public class VideoCuePointObject
   {
      
      public var timeMark:uint;
      
      public var callback:Function;
      
      public var name:String;
      
      public function VideoCuePointObject(timeMark:uint, callback:Function, name:String = null)
      {
         super();
         this.timeMark = timeMark;
         this.callback = callback;
         this.name = name;
      }
   }
}

