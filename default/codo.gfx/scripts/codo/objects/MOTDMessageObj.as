package codo.objects
{
   import codo.constants.WebImgData;
   import codo.localization.DictMOTD;
   import codo.utils.StringUtil;
   
   public class MOTDMessageObj extends CustomObject
   {
      
      public static const MOTD_FORMAT_TEXT:int = 0;
      
      public static const MOTD_FORMAT_TEXT_IMAGE:int = 1;
      
      public static const MOTD_FORMAT_URL:int = 2;
      
      public static const MOTD_SENDER_TENCENT:int = 0;
      
      private static const MOTD_SENDER_CODOTEAM:int = 1;
      
      private static const MOTD_SENDER_ACTIVISION:int = 2;
      
      private static const MOTD_SENDER_OTHER:int = 3;
      
      private static const MOTD_MOST_LATEST_TIME:int = 2147483647;
      
      private static const MOTD_MOST_OLDEST_TIME:int = 0;
      
      public var id:int;
      
      public var timestamp:int;
      
      public var category:int;
      
      public var caption:String;
      
      public var message:String;
      
      public var beViewed:Boolean;
      
      public var sender:int;
      
      public var format:int;
      
      public var otherSender:String;
      
      public var imagePath:String;
      
      public var isFeaturedHomeAd:Boolean = false;
      
      public function MOTDMessageObj(cObj:Object = null)
      {
         super(cObj);
      }
      
      public function get formattedTime() : String
      {
         if(this.timestamp == MOTD_MOST_LATEST_TIME || this.timestamp == MOTD_MOST_OLDEST_TIME)
         {
            return "";
         }
         var time:Date = new Date();
         time.setTime(this.timestamp * 1000);
         return StringUtil.addZero(time.fullYear,4) + "-" + StringUtil.addZero(time.getMonth() + 1,2) + "-" + StringUtil.addZero(time.getDate(),2);
      }
      
      public function get webData() : Object
      {
         if(this.format != MOTD_FORMAT_URL)
         {
            return null;
         }
         var baseWebData:Object = WebImgData.WELCOME;
         baseWebData.x = 673;
         baseWebData.y = 202;
         return baseWebData;
      }
      
      public function get imageURL() : String
      {
         if(StringUtil.isEmpty(this.imagePath))
         {
            return null;
         }
         return this.imagePath;
      }
      
      public function get msgSender() : String
      {
         switch(this.sender)
         {
            case MOTD_SENDER_TENCENT:
               return DictMOTD.NOTIFICATION_SENDER_TENCENT_GAMES;
            case MOTD_SENDER_CODOTEAM:
               return DictMOTD.NOTIFICATION_SENDER_CODO_TEAM;
            case MOTD_SENDER_ACTIVISION:
               return DictMOTD.NOTIFICATION_SENDER_ACTIVISION;
            case MOTD_SENDER_OTHER:
               return this.otherSender;
            default:
               return "";
         }
      }
   }
}

