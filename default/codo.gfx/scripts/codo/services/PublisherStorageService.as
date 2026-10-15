package codo.services
{
   import codo.base.ServiceBase;
   import codo.constants.AsyncTaskGroup;
   import codo.constants.DataID;
   import codo.constants.ServiceID;
   import codo.localization.DictSystem;
   import codo.utils.Logger;
   
   public class PublisherStorageService extends ServiceBase
   {
      
      private static var _instance:PublisherStorageService;
      
      public function PublisherStorageService()
      {
         super(ServiceID.PUBLISHER_STORAGE);
      }
      
      public static function getInstance() : PublisherStorageService
      {
         if(PublisherStorageService._instance == null)
         {
            PublisherStorageService._instance = new PublisherStorageService();
         }
         return PublisherStorageService._instance;
      }
      
      override public function init() : void
      {
         this.register(DataID.PUBLISHER_FILES_UPDATE,this.register_publisherFilesUpdate);
      }
      
      public function register_publisherFilesUpdate(eFileType:uint) : void
      {
         Logger.print("register_publisherFilesUpdate");
         if(this.createTask(DataID.PUBLISHER_FILES_UPDATE,AsyncTaskGroup.NONE,{"fileType":eFileType}))
         {
            Logger.print("register_publisherFilesUpdate - showMsg");
            this.showMsg(DictSystem.DOWNLOADING_PUBLISHER_FILE);
         }
      }
   }
}

