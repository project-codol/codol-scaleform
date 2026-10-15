package codo.controllers
{
   import codo.base.BaseController;
   import codo.common.CFunctionContainer;
   import codo.constants.BCEvent;
   import codo.constants.DataID;
   import codo.constants.MsgBtnCount;
   import codo.constants.PublisherFileType;
   import codo.constants.SystemMsgPriority;
   import codo.event.ParaEvent;
   import codo.localization.DictSystem;
   import codo.utils.Logger;
   
   public class PublisherStorageController extends BaseController
   {
      
      private var leaveFileType:uint;
      
      public function PublisherStorageController()
      {
         super();
      }
      
      override protected function onInitialized() : void
      {
         this.listen(BCEvent.EVT_PUBLISHERSTORAGE_UPDATEAVAILABLE,this.listen_publisherStorageUpdateAvailable);
         this.bind(DataID.PUBLISHER_FILES_UPDATE,this.bind_publisherFilesUpdate);
      }
      
      private function allowPublisherFileUpdateInCurrentState(fileType:uint) : Boolean
      {
         var roomInfo:Object = null;
         switch(fileType)
         {
            case PublisherFileType.REWARDLIST:
            case PublisherFileType.PLAYLISTS:
               roomInfo = CFunctionContainer.GetRoomInfo();
               if(Boolean(this.getDP(DataID.IS_IN_ROOM)) && roomInfo.playListID == -1)
               {
                  return true;
               }
               return false;
               break;
            default:
               return true;
         }
      }
      
      private function bind_leaveRoom(cRes:Object) : void
      {
         Logger.print("PublisherStorageController::bind_leaveRoom " + this.leaveFileType);
         this.unbind(DataID.LEAVE_ROOM,this.bind_leaveRoom);
         this.request(DataID.PUBLISHER_FILES_UPDATE,this.leaveFileType);
      }
      
      private function listen_publisherStorageUpdateAvailable(cEvt:ParaEvent) : void
      {
         var fileType:uint = uint(cEvt.myPara.fileType);
         if(this.allowPublisherFileUpdateInCurrentState(fileType))
         {
            this.request(DataID.PUBLISHER_FILES_UPDATE,fileType);
         }
         else if(Boolean(this.getDP(DataID.IS_IN_ROOM)))
         {
            this.leaveFileType = cEvt.myPara.fileType;
            this.bind(DataID.LEAVE_ROOM,this.bind_leaveRoom);
            this.request(DataID.LEAVE_ROOM,{
               "auto":false,
               "cancelRanked":false,
               "party":false
            });
         }
         else
         {
            this.request(DataID.PUBLISHER_FILES_UPDATE,fileType);
         }
      }
      
      private function bind_publisherFilesUpdate(cRes:Object) : void
      {
         var fileType:uint = uint(cRes.data);
         Logger.print("bind_publisherFilesUpdate " + fileType);
         switch(fileType)
         {
            case PublisherFileType.PLAYLISTS:
               Logger.print("bind_publisherFilesUpdate() - PLAYLIST ");
               this.showMsg(DictSystem.DOWNLOADED_NEW_PLAYLISTS_FILE,MsgBtnCount.ONE,SystemMsgPriority.NORMAL);
               break;
            case PublisherFileType.REWARDLIST:
               Logger.print("bind_publisherFilesUpdate() - REWARDS ");
               this.showMsg(DictSystem.DOWNLOADED_NEW_REWARDS_FILE,MsgBtnCount.ONE,SystemMsgPriority.NORMAL);
               break;
            default:
               Logger.print("bind_publisherFilesUpdate() - PUBLISHER FILE ");
         }
      }
   }
}

