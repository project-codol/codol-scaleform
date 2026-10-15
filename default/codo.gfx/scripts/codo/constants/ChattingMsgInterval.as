package codo.constants
{
   import codo.common.CFunctionCommonContainer;
   
   public class ChattingMsgInterval
   {
      
      public static const PRIVATE:Number = 1000;
      
      public static const CLAN:Number = 1000;
      
      public static const GLOBAL:Number = 3000;
      
      public static const ROOM:Number = 3000;
      
      public static const PARTY:Number = 3000;
      
      public function ChattingMsgInterval()
      {
         super();
      }
      
      public static function getInterval(channel:uint) : Number
      {
         switch(channel)
         {
            case ChattingChannelType.GLOBAL:
               CFunctionCommonContainer.Dvar_GetInt("dw_globalChatCoolDown");
               break;
            case ChattingChannelType.CLAN:
               break;
            case ChattingChannelType.ROOM:
               return ROOM;
            case ChattingChannelType.PRIVATE:
               return PRIVATE;
            case ChattingChannelType.PARTY:
               return PARTY;
            default:
               return GLOBAL;
         }
         return CLAN;
      }
   }
}

