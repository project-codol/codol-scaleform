package codo.objects
{
   import codo.base.BasePageLayer;
   
   public dynamic class CodoPageLayerObj extends CustomObject
   {
      
      public var name:String;
      
      public var currentPageObj:CodoPageObj;
      
      public var depth:uint;
      
      public var instance:BasePageLayer = new BasePageLayer();
      
      public var queue:Boolean = false;
      
      public function CodoPageLayerObj(cObj:Object = null)
      {
         super(cObj);
         if(this.name == null)
         {
         }
      }
   }
}

