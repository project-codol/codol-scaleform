package codo.utils
{
   import codo.constants.DataID;
   import codo.constants.PageID;
   import codo.constants.UITutorialFlags;
   import codo.manager.DataManager;
   import codo.objects.uitour.UITourToolTipObj;
   
   public class TLogUtil
   {
      
      public static var TLog:Function;
      
      private static const TAG_COMPONENT_EVENT:int = 0;
      
      private static const TAG_PAGE_ID:int = 1;
      
      private static const TAG_KEYBOARD:int = 2;
      
      private static const TAG_ONBOARDING:int = 3;
      
      public static const ONBOARD_VIEW_ITEM:int = 11;
      
      public static const ONBOARD_UI_GUIDE:int = 15;
      
      public static const ONBOARD_OPEN_SUPPLY_DROP:int = 17;
      
      public function TLogUtil()
      {
         super();
      }
      
      public static function TLog_componentEvt(pageId:int, buttonId:int, extraData:* = null) : void
      {
         var args:Array = null;
         if(TLog != null)
         {
            args = [pageId,buttonId];
            if(extraData != null)
            {
               args.push(extraData.toString());
            }
            TLog(TAG_COMPONENT_EVENT,args);
         }
      }
      
      public static function TLog_currentPageID(cPageID:String) : void
      {
         var tlogPageId:int = 0;
         if(TLog != null)
         {
            tlogPageId = PageID.GetTLogPageID(cPageID);
            TLog(TAG_PAGE_ID,[tlogPageId]);
         }
      }
      
      public static function TLog_keyboard(cKeyboard:int) : void
      {
         if(TLog != null)
         {
            TLog(TAG_KEYBOARD,[cKeyboard]);
         }
      }
      
      public static function TLog_UserInput(buttonId:int, extraData:* = null) : void
      {
         var currentPageId:String = DataManager.getInstance().getDP(DataID.CURRENT_MAIN_PAGE_ID);
         var tlogPageId:int = PageID.GetTLogPageID(currentPageId);
         TLog_componentEvt(tlogPageId,buttonId,extraData);
      }
      
      public static function TLog_Onboarding(flag:int, value:uint = 0, value2:uint = 0, valueStr:String = "", duration:int = 0) : void
      {
         if(TLog != null)
         {
            TLog(TAG_ONBOARDING,[flag,value,value2,valueStr,duration]);
         }
      }
      
      public static function TLog_Onboarding_Guide(tip:UITourToolTipObj, doOpenTour:Boolean) : void
      {
         var param:uint = doOpenTour ? 1 : 0;
         if(!tip.acknowledged)
         {
            param = 2;
         }
         var val2:uint = tip.flagID != UITutorialFlags.NULL ? tip.flagID : 0;
         var valStr:String = tip.onboardNotif;
         if(tip.linkedTip != null)
         {
            valStr += "_lobby";
         }
         TLogUtil.TLog_Onboarding(TLogUtil.ONBOARD_UI_GUIDE,param,val2,valStr);
      }
   }
}

