package codo.objects
{
   public dynamic class SystemMsgObj extends CustomObject
   {
      
      public static const TRIGGER_TYPE_AS:int = 0;
      
      public static const TRIGGER_TYPE_CPP:int = 1;
      
      public var title:String = null;
      
      public var message:String = "";
      
      public var id:int = 0;
      
      public var priority:int = 0;
      
      public var btnCount:int = 0;
      
      public var btn0Label:String = "";
      
      public var btn1Label:String = "";
      
      public var btn2Label:String = "";
      
      public var btn0Handle:Function = null;
      
      public var btn1Handle:Function = null;
      
      public var btn2Handle:Function = null;
      
      public var btnDelay:Number = 0;
      
      public var triggerType:int = 0;
      
      public var rewardData:MessageRewardData;
      
      public var activityData:Object;
      
      public var wargodSeasonRewardObj:WarGodSeasonEndRewardObj;
      
      public var rewardPopupData:RewardObjComplete;
      
      public var recommendationData:RecommendationObject;
      
      public var alwaysShowSpinner:Boolean = false;
      
      public var imageURL:String = "";
      
      public function SystemMsgObj(cObj:Object = null)
      {
         super(cObj);
      }
      
      public static function getObj(cMsg:String, cBtnCount:int = 0, cPriority:int = 0, cHandle0:Function = null, cLabel0:String = "", cHandle1:Function = null, cLabel1:String = "", cHandle2:Function = null, cLabel2:String = "", triggerType:int = 0, cDelay:Number = 0, cTitle:String = null) : SystemMsgObj
      {
         var obj:SystemMsgObj = new SystemMsgObj();
         obj.title = cTitle;
         obj.message = cMsg;
         obj.btnCount = cBtnCount;
         obj.priority = cPriority;
         obj.btn0Handle = cHandle0;
         obj.btn1Handle = cHandle1;
         obj.btn2Handle = cHandle2;
         obj.btn0Label = cLabel0;
         obj.btn1Label = cLabel1;
         obj.btn2Label = cLabel2;
         obj.triggerType = triggerType;
         obj.btnDelay = cDelay;
         return obj;
      }
      
      public static function equal(cMsgObj1:SystemMsgObj, cMsgObj2:SystemMsgObj) : Boolean
      {
         if(cMsgObj1 == null && cMsgObj2 == null)
         {
            return true;
         }
         if(cMsgObj1 == null || cMsgObj2 == null)
         {
            return false;
         }
         return cMsgObj1.title == cMsgObj2.title && cMsgObj1.message == cMsgObj2.message && cMsgObj1.btnCount == cMsgObj2.btnCount && cMsgObj1.priority == cMsgObj2.priority && cMsgObj1.btn0Handle == cMsgObj2.btn0Handle && cMsgObj1.btn0Label == cMsgObj2.btn0Label && cMsgObj1.btn1Handle == cMsgObj2.btn1Handle && cMsgObj1.btn1Label == cMsgObj2.btn1Label && cMsgObj1.btn2Handle == cMsgObj2.btn2Handle && cMsgObj1.btn2Label == cMsgObj2.btn2Label;
      }
   }
}

