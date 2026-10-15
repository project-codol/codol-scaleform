package codo.base
{
   import codo.common.CFunctionCommonContainer;
   import codo.constants.BCEvent;
   import codo.constants.DataID;
   import codo.constants.MsgBtnCount;
   import codo.localization.DictMail;
   import codo.manager.DataManager;
   import codo.manager.EventManager;
   import codo.objects.ActivityData;
   import codo.objects.CodoPageObj;
   import codo.objects.MessageRewardData;
   import codo.objects.RecommendationObject;
   import codo.objects.RewardObjComplete;
   import codo.objects.SystemMsgObj;
   import codo.objects.WarGodRewardObj;
   import codo.objects.WarGodSeasonEndRewardObj;
   import codo.objects.WarGodSeasonObj;
   import codo.utils.Logger;
   
   public class BaseController extends StateMachineBase
   {
      
      public function BaseController()
      {
         super();
      }
      
      public function init() : void
      {
         this.onInit();
         this.onInitialized();
      }
      
      protected function onInit() : void
      {
      }
      
      protected function onInitialized() : void
      {
      }
      
      protected function gotoPage(cPageObj:CodoPageObj, cParams:Object = null, cCallBeforeGoto:Function = null, cCallAfterGoto:Function = null) : void
      {
         this.broadcast(BCEvent.GOTO_PAGE_BY_PAGEOBJ,{
            "pageObj":cPageObj,
            "params":cParams,
            "callBeforeGoto":cCallBeforeGoto,
            "callAfterGoto":cCallAfterGoto
         });
      }
      
      protected function prevPage() : void
      {
         this.broadcast(BCEvent.GOTO_PREV_PAGE);
      }
      
      protected function closeAllPopUp() : void
      {
         this.broadcast(BCEvent.CLOSE_ALL_POPUP);
      }
      
      protected function closePopupPage(sPageID:String) : void
      {
         this.broadcast(BCEvent.EVT_CLOSE_POPUP_PAGE,{"pageID":sPageID});
      }
      
      protected function showMsg(cMsg:String, cBtnCount:int = 0, cPriority:int = 0, cHandle0:Function = null, cLabel0:String = "", cHandle1:Function = null, cLabel1:String = "", cHandle2:Function = null, cLabel2:String = "", cDelay:Number = 0, alwaysShowSpinner:Boolean = false, title:String = null) : SystemMsgObj
      {
         Logger.print("BaseController:::showMsg this/msg: " + this + "/" + cMsg);
         var systemMsg:SystemMsgObj = SystemMsgObj.getObj(cMsg,cBtnCount,cPriority,cHandle0,cLabel0,cHandle1,cLabel1,cHandle2,cLabel2,0,cDelay,title);
         systemMsg.alwaysShowSpinner = alwaysShowSpinner;
         this.broadcast(BCEvent.EVT_SHOW_SYSTEM_MSG,systemMsg);
         return systemMsg;
      }
      
      protected function showRewardMsg(obj:Object) : void
      {
         var systemMsg:SystemMsgObj = SystemMsgObj.getObj(obj.msg,MsgBtnCount.ONE,0,null,"",null,"",null,"",0,0);
         if(obj.currencyAmount > 0 || obj.item != null)
         {
            systemMsg.rewardData = new MessageRewardData(obj.currencyType,obj.currencyAmount,obj.item);
         }
         this.broadcast(BCEvent.EVT_SHOW_SYSTEM_MSG,systemMsg);
      }
      
      protected function showActivityMsg(obj:Object) : void
      {
         if(obj.msg == "")
         {
            obj.msg = DictMail.REWARD_MESSAGE_DEFAULT;
         }
         var systemMsg:SystemMsgObj = SystemMsgObj.getObj(obj.msg,MsgBtnCount.ONE,0,null,"",null,"",null,"",0,0);
         systemMsg.activityData = new ActivityData(obj.type,obj.xp,obj.gp,obj.item);
         this.broadcast(BCEvent.EVT_SHOW_SYSTEM_MSG,systemMsg);
      }
      
      protected function showWarGodSeasonEndRewardMsg(obj:Object) : void
      {
         if(obj.msg == "")
         {
            obj.msg = DictMail.REWARD_MESSAGE_DEFAULT;
         }
         var wargodSeasonEndReward:WarGodSeasonEndRewardObj = new WarGodSeasonEndRewardObj();
         wargodSeasonEndReward.rewardType = obj.type;
         wargodSeasonEndReward.itemId = obj.item.id;
         wargodSeasonEndReward.itemType = obj.item.type;
         wargodSeasonEndReward.itemParameter = obj.item.parameter;
         wargodSeasonEndReward.seasonId = obj.item.seasonId;
         if(obj.item.type == WarGodRewardObj.TYPE_CURRENCY)
         {
            wargodSeasonEndReward.currencyID = obj.item.currencyID;
         }
         var seasonObj:WarGodSeasonObj = this.getDP(DataID.GET_SEASON_BY_ID,[obj.item.seasonId]);
         if(seasonObj != null)
         {
            wargodSeasonEndReward.seasonName = seasonObj.name;
            wargodSeasonEndReward.seasonTime = seasonObj.timeForShow;
         }
         var systemMsg:SystemMsgObj = SystemMsgObj.getObj(obj.msg,MsgBtnCount.ONE,0,null,"",null,"",null,"",0,0);
         systemMsg.wargodSeasonRewardObj = wargodSeasonEndReward;
         this.broadcast(BCEvent.EVT_SHOW_SYSTEM_MSG,systemMsg);
      }
      
      protected function showRewardPopupMsg(obj:Object) : void
      {
         var systemMsg:SystemMsgObj = SystemMsgObj.getObj("reward popup",MsgBtnCount.ONE,0,null,"",null,"",null,"",0,0);
         systemMsg.rewardPopupData = obj as RewardObjComplete;
         this.broadcast(BCEvent.EVT_SHOW_SYSTEM_MSG,systemMsg);
      }
      
      protected function showRecommendationPopupMsg(obj:Object) : void
      {
         var systemMsg:SystemMsgObj = SystemMsgObj.getObj("recommendation",MsgBtnCount.ONE,0,null,"",null,"",null,"",0,0);
         systemMsg.recommendationData = new RecommendationObject(obj);
         this.broadcast(BCEvent.EVT_SHOW_SYSTEM_MSG,systemMsg);
      }
      
      protected function hideMsg(cTime:Number = 0, cCallback:Function = null, cTriggerType:int = 0, cPriority:int = 0) : void
      {
         Logger.print("BaseController:::hideMsg this: " + this);
         this.broadcast(BCEvent.EVT_HIDE_SYSTEM_MSG,{
            "delayTime":cTime,
            "callback":cCallback,
            "triggerType":cTriggerType,
            "priority":cPriority
         });
      }
      
      protected function hideSpecificMsg(systemMsg:SystemMsgObj) : void
      {
         if(systemMsg != null)
         {
            Logger.print("BaseController:::hideSpecificMsg: " + systemMsg);
            this.broadcast(BCEvent.EVT_HIDE_SYSTEM_MSG,{"systemMsg":systemMsg});
         }
      }
      
      protected function broadcast(cType:String, cData:* = null) : void
      {
         EventManager.getInstance().broadcast(cType,cData);
      }
      
      protected function listen(cType:String, cHandle:Function, priority:int = 0) : void
      {
         EventManager.getInstance().listen(cType,cHandle,false,priority);
      }
      
      protected function unlisten(cType:String, cHandle:Function) : void
      {
         EventManager.getInstance().unlisten(cType,cHandle);
      }
      
      protected function request(cDataID:*, cParams:Object = null, cCallback:Function = null) : void
      {
         DataManager.getInstance().request(cDataID,cParams,cCallback);
      }
      
      protected function bind(cDataID:*, cCallback:Function, cParams:Object = null, cImmediateCall:Boolean = false) : void
      {
         DataManager.getInstance().bind(cDataID,cCallback,cParams,cImmediateCall,false,true);
      }
      
      protected function unbind(cDataID:*, cCallback:Function) : void
      {
         DataManager.getInstance().unbind(cDataID,cCallback);
      }
      
      protected function setBindData(cDataID:*, cValue:Object) : void
      {
         DataManager.getInstance().setBindData(cDataID,cValue);
      }
      
      protected function addDP(cDataID:*, cProvider:Function) : void
      {
         DataManager.getInstance().addDP(cDataID,cProvider);
      }
      
      protected function removeDP(cDataID:*, cProvider:Function) : void
      {
         DataManager.getInstance().removeDP(cDataID,cProvider);
      }
      
      protected function getDP(cDataID:*, cParams:Array = null) : *
      {
         return DataManager.getInstance().getDP(cDataID,cParams);
      }
      
      public function getDvarBool(dvar:String) : Boolean
      {
         return CFunctionCommonContainer.Dvar_GetBool(dvar) as Boolean;
      }
      
      public function getDvarInt(dvar:String) : int
      {
         return CFunctionCommonContainer.Dvar_GetInt(dvar);
      }
      
      public function getDvarFloat(dvar:String) : Number
      {
         return CFunctionCommonContainer.Dvar_GetFloat(dvar);
      }
      
      public function getDvarString(dvar:String) : String
      {
         return CFunctionCommonContainer.Dvar_GetString(dvar);
      }
      
      public function getDvarEnumLen(dvar:String) : Number
      {
         return CFunctionCommonContainer.Dvar_GetEnumLength(dvar);
      }
      
      public function getDvarEnumVal(dvar:String, index:Number) : String
      {
         return CFunctionCommonContainer.Dvar_GetEnumValue(dvar,index);
      }
   }
}

