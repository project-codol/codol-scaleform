package codo.controllers
{
   import codo.base.BaseController;
   import codo.manager.EventManager;
   import codo.utils.Logger;
   import com.adobe.serialization.json.JSON;
   
   public class FSGAutoTestController extends BaseController
   {
      
      public function FSGAutoTestController()
      {
         super();
      }
      
      public function SendEvent(eventName:String) : void
      {
         EventManager.getInstance().broadcast(eventName);
      }
      
      public function UpdateState() : void
      {
      }
      
      public function SendEventData(eventName:String, data:String) : void
      {
         var dataObject:Object = com.adobe.serialization.json.JSON.decode(data);
         EventManager.getInstance().broadcast(eventName,dataObject);
      }
      
      public function Echo(message:String) : void
      {
         Logger.print("Echo response " + message);
      }
   }
}

