package codo.manager
{
   import codo.base.BaseController;
   import flash.utils.Dictionary;
   
   public class ControllerManager
   {
      
      private static var _instance:ControllerManager;
      
      public var controllers:Dictionary = new Dictionary();
      
      public function ControllerManager()
      {
         super();
      }
      
      public static function getInstance() : ControllerManager
      {
         if(_instance == null)
         {
            _instance = new ControllerManager();
         }
         return _instance;
      }
      
      public function preInit(classes:Dictionary) : void
      {
         this.init(classes);
      }
      
      public function init(classes:Dictionary) : void
      {
         var id:String = null;
         if(classes != null)
         {
            for(id in classes)
            {
               this.createController(id,classes[id]);
            }
         }
      }
      
      public function update(deltaTime:Number) : void
      {
         var controller:BaseController = null;
         for each(controller in this.controllers)
         {
            if(controller != null)
            {
               controller.update(deltaTime);
            }
         }
      }
      
      public function getController(id:String) : BaseController
      {
         var controller:BaseController = this.controllers[id];
         if(controller == null)
         {
         }
         return controller;
      }
      
      private function createController(id:String, cls:Class) : void
      {
         if(this.controllers[id] == null)
         {
            this.controllers[id] = new cls();
            this.controllers[id].init();
         }
      }
   }
}

