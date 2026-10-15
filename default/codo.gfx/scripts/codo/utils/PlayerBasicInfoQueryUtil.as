package codo.utils
{
   import codo.constants.BCEvent;
   import codo.manager.EventManager;
   import codo.objects.PlayerBasicInfoObj;
   
   public class PlayerBasicInfoQueryUtil
   {
      
      private var mQueryIds:Object;
      
      private var mPlayerBasicInfoHandler:Function;
      
      private var mCompleteHandler:Function;
      
      public function PlayerBasicInfoQueryUtil()
      {
         super();
         this.mQueryIds = new Object();
      }
      
      public function registerPlayerBasicInfoHandler(handler:Function) : void
      {
         this.mPlayerBasicInfoHandler = handler;
      }
      
      public function registerCompleteHandler(handler:Function) : void
      {
         this.mCompleteHandler = handler;
      }
      
      public function queryPlayerBasicInfo(userIdsArray:Array) : void
      {
         var id:String = null;
         EventManager.getInstance().broadcast(BCEvent.REGISTER_PLAYER_BASIC_INFO_CALLBACK,this);
         for each(id in userIdsArray)
         {
            this.mQueryIds[id] = id;
         }
         EventManager.getInstance().broadcast(BCEvent.EVT_QUERY_PLAYER_BASIC_INFO,userIdsArray);
      }
      
      public function onIncomingPlayerBasicInfoArray(playerBasicInfoArray:Array) : void
      {
         var info:PlayerBasicInfoObj = null;
         for(var i:uint = 0; i < playerBasicInfoArray.length; i++)
         {
            info = playerBasicInfoArray[i] as PlayerBasicInfoObj;
            if(this.mQueryIds.hasOwnProperty(info.entityID))
            {
               if(this.mPlayerBasicInfoHandler != null)
               {
                  this.mPlayerBasicInfoHandler(info);
               }
               delete this.mQueryIds[info.entityID];
            }
         }
      }
      
      public function onBatchQueryEnd() : void
      {
         var key:String = null;
         var leftOverUserIds:Array = [];
         for(key in this.mQueryIds)
         {
            leftOverUserIds.push(key);
         }
         if(leftOverUserIds.length > 0)
         {
            EventManager.getInstance().broadcast(BCEvent.EVT_QUERY_PLAYER_BASIC_INFO,leftOverUserIds);
         }
         else
         {
            if(this.mCompleteHandler != null)
            {
               this.mCompleteHandler();
            }
            EventManager.getInstance().broadcast(BCEvent.UNREGISTER_PLAYER_BASIC_INFO_CALLBACK,this);
         }
      }
   }
}

