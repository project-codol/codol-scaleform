package codo.manager
{
   import codo.base.ServiceBase;
   import codo.constants.ServiceID;
   import flash.utils.Dictionary;
   
   public class ServiceManager
   {
      
      private static var _instance:ServiceManager;
      
      private var _services:Dictionary = new Dictionary();
      
      public function ServiceManager()
      {
         super();
      }
      
      public static function getInstance() : ServiceManager
      {
         if(ServiceManager._instance == null)
         {
            ServiceManager._instance = new ServiceManager();
         }
         return ServiceManager._instance;
      }
      
      public function addService(cService:ServiceBase) : void
      {
         if(cService != null && cService.id != ServiceID.NONE && this._services[cService.id] == null)
         {
            this._services[cService.id] = cService;
         }
      }
      
      public function removeService(cID:uint) : void
      {
         if(!this._services.hasOwnProperty(cID.toString()))
         {
            return;
         }
         this._services[cID] = null;
         delete this._services[cID];
      }
      
      public function postActivate() : void
      {
         var service:Object = null;
         for each(service in this._services)
         {
            if(service is ServiceBase)
            {
               service.postActivate();
            }
         }
      }
      
      public function update(deltaTime:Number) : void
      {
         var service:Object = null;
         for each(service in this._services)
         {
            if(service is ServiceBase)
            {
               service.update(deltaTime);
            }
         }
      }
   }
}

