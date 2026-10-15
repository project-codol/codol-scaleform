package codo.constants
{
   import codo.localization.DictRoom;
   
   public class GlobalBottomBtnStatus
   {
      
      public static const STATUS_IDLE_DEFAULT:uint = 0;
      
      public static const STATUS_IDLE_MP_LANDING:uint = 1;
      
      public static const STATUS_IDLE_MP_PLAYLIST_CHOOSE:uint = 2;
      
      public static const STATUS_IDLE_MP_ROOM_JOIN:uint = 3;
      
      public static const STATUS_IDLE_MP_ROOM_CREATOR:uint = 4;
      
      public static const STATUS_IDLE_MP_TRAINING:uint = 5;
      
      public static const STATUS_IDLE_COOP_STAGE_CHOOSE:uint = 6;
      
      public static const STATUS_IDLE_COOP_ROOM_JOIN:uint = 7;
      
      public static const STATUS_IDLE_CYBORG_LANDING:uint = 8;
      
      public static const STATUS_IDLE_CYBORG_ROOM_JOIN:uint = 9;
      
      public static const STATUS_NOTIDLE_NOT_INROOM:uint = 12;
      
      public static const STATUS_NOTIDLE_RANKED_INPROGRESS:uint = 13;
      
      public static const STATUS_NOTIDLE_RANKED_INROOM:uint = 14;
      
      public static const STATUS_NOTIDLE_RANKED_INROOM_CANT_LEAVE:uint = 15;
      
      public static const STATUS_NOTIDLE_NOT_INROOM_CANT_LEAVE:uint = 16;
      
      public static const STATUS_DISABLED:uint = 17;
      
      public static const LOCALIZATION:Array = [[null,null,null],[null,null,null],[null,null,null],[null,null,null],[null,null,null],[null,null,null],[null,null,null],[null,null,null],[null,null,null],[null,null,null],[null,{
         "label":DictRoom.SET_READY,
         "enable":true
      },{
         "label":DictRoom.LEAVE_ROOM,
         "enable":true
      }],[null,{
         "label":DictRoom.CANCEL_READY,
         "enable":true
      },{
         "label":DictRoom.LEAVE_ROOM,
         "enable":true
      }],[null,{
         "label":DictRoom.BACK_TO_ROOM,
         "enable":true
      },{
         "label":DictRoom.LEAVE_ROOM,
         "enable":true
      }],[null,null,null],[null,{
         "label":DictRoom.RANKED_MATCH_READY_TO_START,
         "enable":false
      },{
         "label":DictRoom.LEAVE_ROOM,
         "enable":true
      }],[null,{
         "label":DictRoom.RANKED_MATCH_READY_TO_START,
         "enable":false
      },{
         "label":DictRoom.LEAVE_ROOM,
         "enable":false
      }],[{
         "label":DictRoom.BACK_TO_ROOM,
         "enable":true
      },null,{
         "label":DictRoom.LEAVE_ROOM,
         "enable":false
      }],[null,null,null]];
      
      public function GlobalBottomBtnStatus()
      {
         super();
      }
   }
}

