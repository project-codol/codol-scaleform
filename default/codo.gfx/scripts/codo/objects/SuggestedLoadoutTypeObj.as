package codo.objects
{
   public class SuggestedLoadoutTypeObj
   {
      
      public var id:uint;
      
      public var label:String;
      
      public var desc:String;
      
      public var checked:Boolean;
      
      public var index:int;
      
      public function SuggestedLoadoutTypeObj(_id:uint, _label:String, _desc:String)
      {
         super();
         this.id = _id;
         this.label = _label;
         this.desc = _desc;
      }
   }
}

