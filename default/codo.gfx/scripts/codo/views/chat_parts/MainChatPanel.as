package codo.views.chat_parts
{
   import codo.objects.ScrollGridSettings;
   import codo.objects.ScrollListSettings;
   import codo.utils.MathUtil;
   import flash.display.MovieClip;
   
   public class MainChatPanel extends MovieClip
   {
      
      public static const MAX_EXPANDED_CHAT_CAN_HOLD:int = 100;
      
      public static const MAX_ITEM_IN_PAGE:int = 14;
      
      public var myBigSpeaker:BigSpeaker;
      
      public var myHistory:MainChatHistoryScrollGrid;
      
      public function MainChatPanel()
      {
         var scrollGridSetting:ScrollGridSettings = null;
         super();
         scrollGridSetting = new ScrollGridSettings();
         scrollGridSetting.orientation = ScrollListSettings.SCROLL_VERTICAL;
         scrollGridSetting.useNavArrows = false;
         scrollGridSetting.itemPadding = 0;
         scrollGridSetting.itemLinkage = "codo.chat.chatlistitem";
         scrollGridSetting.autoSize = false;
         this.myHistory.initGrid(scrollGridSetting,MAX_ITEM_IN_PAGE,false,1);
         this.myHistory.addItemsByVector(new Vector.<Object>());
      }
      
      public function setHistory(histroy:Vector.<Object>, switchedNewChannel:Boolean) : void
      {
         var newPosition:Number = NaN;
         var keptItemLength:Number = NaN;
         var keptPosition:Number = NaN;
         var keptScrollItem:Number = NaN;
         var newItemLength:Number = NaN;
         if(switchedNewChannel)
         {
            newPosition = 1;
            this.myHistory.addItemsByVector(histroy);
         }
         else
         {
            keptItemLength = this.myHistory.listData.length;
            keptPosition = this.myHistory.getCurrentPosition();
            if(keptItemLength <= MAX_ITEM_IN_PAGE)
            {
               keptPosition = 1;
            }
            keptScrollItem = (keptItemLength - MAX_ITEM_IN_PAGE) * keptPosition;
            MathUtil.clamp(keptScrollItem,0,Number.MAX_VALUE);
            this.myHistory.addItemsByVector(histroy);
            newItemLength = this.myHistory.listData.length;
            if(Math.abs(keptPosition - 1) < 0.01)
            {
               newPosition = 1;
            }
            else
            {
               newPosition = keptScrollItem / (newItemLength - MAX_ITEM_IN_PAGE);
               MathUtil.clamp(newPosition,0,1);
            }
         }
         this.myHistory.gotoSpecificPosition(newPosition);
      }
   }
}

