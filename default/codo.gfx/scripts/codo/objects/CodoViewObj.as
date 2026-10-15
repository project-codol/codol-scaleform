package codo.objects
{
   import codo.base.BaseView;
   
   public dynamic class CodoViewObj extends CustomObject
   {
      
      public var src:Class;
      
      public var instance:BaseView;
      
      public var historyAble:Boolean;
      
      public function CodoViewObj(cObj:Object = null)
      {
         super(cObj);
      }
   }
}

