package codo.controllers
{
   import codo.base.BaseController;
   import codo.common.CFunctionCommonContainer;
   import codo.common.CFunctionContainer;
   import codo.constants.BCEvent;
   import codo.constants.DataID;
   import codo.constants.MarketMenuData;
   import codo.event.ParaEvent;
   import codo.objects.*;
   import codo.utils.TLogUtil;
   
   public class RewardController extends BaseController
   {
      
      private const EXCHANGE_SUPPLY_STATE_NONE:int = 0;
      
      private const EXCHANGE_SUPPLY_STATE_BACKGROUND_EXCHANGE:int = 1;
      
      private const EXCHANGE_SUPPLY_STATE_EXCHANGE_AND_CONSUME:int = 2;
      
      private var mCurrentExchangeSupplyDropDustState:int;
      
      private var mCurrentExchangeSupplyDropDustStateParam1:int;
      
      private var mCurrentExchangeSupplyDropDustStateParam2:int;
      
      private var mGotoPrevPageIfFailed:Boolean;
      
      public function RewardController()
      {
         super();
         this.mCurrentExchangeSupplyDropDustState = this.EXCHANGE_SUPPLY_STATE_NONE;
      }
      
      override protected function onInitialized() : void
      {
         super.onInitialized();
         listen(BCEvent.EVT_REWARD_CONSUME_SUPPLY_DROP_REQUEST,this.onRewardConsumeSupplyDropRequest);
         listen(BCEvent.EVT_REWARD_REROLL_CHALLENGE_REQUEST,this.onRewardRerollChallenge);
         listen(BCEvent.EVT_OPEN_DUST_EXCHANGED_SUPPLY_DROP,this.onOpenDustExchangedSupplyDrop);
         listen(BCEvent.EVT_MARKET_PURCHASE_TASK_SUCCESS,this.onPurchaseSupplyDropSuccess);
         listen(BCEvent.EVT_MARKET_PURCHASE_TASK_FAIL,this.onPurchaseSupplyDropFail);
         listen(BCEvent.EVT_CHANGE_ASD_DUST,this.onChangeASDDust);
         listen(BCEvent.EVT_CHANGE_BSD_DUST,this.onChangeBSDDust);
         listen(BCEvent.EVT_CHANGE_LSD_DUST,this.onChangeLSDDust);
         listen(BCEvent.EVT_BSD_DUST_CHANGED,this.onBSDDustChanged);
         listen(BCEvent.EVT_ASD_DUST_CHANGED,this.onASDDustChanged);
         listen(BCEvent.EVT_LSD_DUST_CHANGED,this.onLSDDustChanged);
         addDP(DataID.GET_SUPPLY_DROP_DUST_NUM,this.onGetSupplyDropDustNum);
         addDP(DataID.GET_SUPPLY_DROP_EXCHANGE_DUST_NUM,this.onGetSupplyDropExchangeDustNum);
         addDP(DataID.GET_SUPPLY_DROP_EXCHANGE_SKU,this.onGetSupplyDropExchangeSKU);
      }
      
      public function onRewardConsumeSupplyDropRequest(cEvt:ParaEvent) : void
      {
         var supplyDropID:int = cEvt.myPara.dropID as int;
         var quantity:int = cEvt.myPara.quantity as int;
         this.mGotoPrevPageIfFailed = cEvt.myPara.gotoPrevPageIfFailed;
         request(DataID.REWARD_CONSUME_SUPPLY_DROP,{
            "id":supplyDropID,
            "quantity":quantity
         },this.onConsumeSupplyDropResponse);
      }
      
      private function onConsumeSupplyDropResponse(cRes:Object) : void
      {
         var responses:Array = null;
         var i:int = 0;
         var response:ConsumeSupplyDropResponseObj = null;
         if(cRes.result == ResultObj.RESULT_SUCCESS)
         {
            broadcast(BCEvent.EVT_GOTO_SUPPLY_DROP_REWARD_SELECTION,cRes.data);
            broadcast(BCEvent.EVT_MARKET_UPDATE_INVENTORY);
            responses = cRes.data as Array;
            for(i = 0; i < responses.length; i++)
            {
               response = responses[i];
               TLogUtil.TLog_Onboarding(TLogUtil.ONBOARD_OPEN_SUPPLY_DROP,response.supplyDropID);
            }
         }
         else if(this.mGotoPrevPageIfFailed)
         {
            broadcast(BCEvent.GOTO_PREV_MAIN_PAGE);
         }
         this.mGotoPrevPageIfFailed = false;
      }
      
      public function onRewardRerollChallenge(cEvt:ParaEvent) : void
      {
         var dailyChallenge:DailyChallengeObj = cEvt.myPara as DailyChallengeObj;
         request(DataID.REWARD_REROLL_CHALLENGE,dailyChallenge,this.onRerollChallengeResponse);
      }
      
      private function onRerollChallengeResponse(cRes:Object) : void
      {
         if(cRes.result == ResultObj.RESULT_SUCCESS)
         {
            broadcast(BCEvent.EVT_REFRESH_CHALLENGES);
         }
      }
      
      private function onChangeASDDust(ev:ParaEvent) : void
      {
         CFunctionContainer.AS_ChangeASDPoints(ev.myPara as int);
      }
      
      private function onChangeBSDDust(ev:ParaEvent) : void
      {
         CFunctionContainer.AS_ChangeBSDPoints(ev.myPara as int);
      }
      
      private function onChangeLSDDust(ev:ParaEvent) : void
      {
         CFunctionContainer.AS_ChangeLSDPoints(ev.myPara as int);
      }
      
      public function onGetSupplyDropDustNum(dropId:int) : uint
      {
         var supplyDropDustInfoObj:SupplyDropDustInfoObj = CFunctionContainer.AS_GetSupplyDropDustInfo();
         switch(dropId)
         {
            case MarketMenuData.SUPPLY_DROP_EVENT:
               return supplyDropDustInfoObj.lsdPoints;
            case MarketMenuData.SUPPLY_DROP_ADVANCED:
               return supplyDropDustInfoObj.asdPoints;
            case MarketMenuData.SUPPLY_DROP_BASIC:
               return supplyDropDustInfoObj.bsdPoints;
            default:
               return 0;
         }
      }
      
      public function onGetSupplyDropExchangeDustNum(dropId:int) : int
      {
         return CFunctionContainer.AS_GetSupplyDropDustExchangeRatio(dropId);
      }
      
      public function onGetSupplyDropExchangeSKU(dropId:int) : int
      {
         return CFunctionContainer.AS_GetSupplyDropDustSku(dropId);
      }
      
      public function cppASDPointChanged() : void
      {
         broadcast(BCEvent.EVT_ASD_DUST_CHANGED);
      }
      
      public function cppBSDPointChanged() : void
      {
         broadcast(BCEvent.EVT_BSD_DUST_CHANGED);
      }
      
      public function cppLSDPointChanged() : void
      {
         broadcast(BCEvent.EVT_LSD_DUST_CHANGED);
      }
      
      public function onBSDDustChanged(ev:ParaEvent) : void
      {
         this.exchangeRemainDustsToCrates(MarketMenuData.SUPPLY_DROP_BASIC);
      }
      
      public function onASDDustChanged(ev:ParaEvent) : void
      {
         this.exchangeRemainDustsToCrates(MarketMenuData.SUPPLY_DROP_ADVANCED);
      }
      
      public function onLSDDustChanged(ev:ParaEvent) : void
      {
         this.exchangeRemainDustsToCrates(MarketMenuData.SUPPLY_DROP_EVENT);
      }
      
      private function exchangeRemainDustsToCrates(dropId:int) : void
      {
         var exchangeSKU:int = getDP(DataID.GET_SUPPLY_DROP_EXCHANGE_SKU,[dropId]);
         if(exchangeSKU == 0)
         {
            return;
         }
         var exchangeDustsDemand:int = getDP(DataID.GET_SUPPLY_DROP_EXCHANGE_DUST_NUM,[dropId]);
         if(exchangeDustsDemand == 0)
         {
            return;
         }
         var currentDusts:int = getDP(DataID.GET_SUPPLY_DROP_DUST_NUM,[dropId]);
         if(currentDusts < exchangeDustsDemand)
         {
            return;
         }
         var skuNum:int = Math.floor(currentDusts / exchangeDustsDemand);
         var item:ProductObj = CFunctionCommonContainer.GetItemInfoBySku(exchangeSKU);
         for(var i:int = 0; i < item.SKUs.length; i++)
         {
            if(item.SKUs[i].id == exchangeSKU)
            {
               item.currentSKUIndex = i;
               break;
            }
         }
         broadcast(BCEvent.EVT_MARKET_PURCHASE_CONFIRM_BUY,{
            "item":item,
            "itemNum":skuNum,
            "disableFeedback":true
         });
         this.mCurrentExchangeSupplyDropDustState = this.EXCHANGE_SUPPLY_STATE_BACKGROUND_EXCHANGE;
         this.mCurrentExchangeSupplyDropDustStateParam1 = skuNum * exchangeDustsDemand;
         this.mCurrentExchangeSupplyDropDustStateParam2 = dropId;
      }
      
      private function onOpenDustExchangedSupplyDrop(ev:ParaEvent) : void
      {
         var dropId:int = ev.myPara.dropID as int;
         this.mGotoPrevPageIfFailed = ev.myPara.gotoPrevPageIfFailed;
         var exchangeSKU:int = getDP(DataID.GET_SUPPLY_DROP_EXCHANGE_SKU,[dropId]);
         if(exchangeSKU == 0)
         {
            return;
         }
         var exchangeDustsDemand:int = getDP(DataID.GET_SUPPLY_DROP_EXCHANGE_DUST_NUM,[dropId]);
         if(exchangeDustsDemand == 0)
         {
            return;
         }
         var currentDusts:int = getDP(DataID.GET_SUPPLY_DROP_DUST_NUM,[dropId]);
         if(currentDusts < exchangeDustsDemand)
         {
            return;
         }
         var skuNum:int = Math.floor(currentDusts / exchangeDustsDemand);
         this.mCurrentExchangeSupplyDropDustState = this.EXCHANGE_SUPPLY_STATE_EXCHANGE_AND_CONSUME;
         this.mCurrentExchangeSupplyDropDustStateParam1 = skuNum * exchangeDustsDemand;
         this.mCurrentExchangeSupplyDropDustStateParam2 = dropId;
         var item:ProductObj = CFunctionCommonContainer.GetItemInfoBySku(exchangeSKU);
         for(var i:int = 0; i < item.SKUs.length; i++)
         {
            if(item.SKUs[i].id == exchangeSKU)
            {
               item.currentSKUIndex = i;
               break;
            }
         }
         broadcast(BCEvent.EVT_MARKET_PURCHASE_CONFIRM_BUY,{
            "item":item,
            "itemNum":skuNum,
            "disableFeedback":true
         });
      }
      
      private function onPurchaseSupplyDropSuccess(cRes:Object) : void
      {
         this.mGotoPrevPageIfFailed = false;
         if(this.mCurrentExchangeSupplyDropDustState == this.EXCHANGE_SUPPLY_STATE_NONE)
         {
            return;
         }
         var dropId:int = this.mCurrentExchangeSupplyDropDustStateParam2;
         var currencyNum:int = -this.mCurrentExchangeSupplyDropDustStateParam1;
         switch(dropId)
         {
            case MarketMenuData.SUPPLY_DROP_EVENT:
               broadcast(BCEvent.EVT_CHANGE_LSD_DUST,currencyNum);
               break;
            case MarketMenuData.SUPPLY_DROP_ADVANCED:
               broadcast(BCEvent.EVT_CHANGE_ASD_DUST,currencyNum);
               break;
            case MarketMenuData.SUPPLY_DROP_BASIC:
               broadcast(BCEvent.EVT_CHANGE_BSD_DUST,currencyNum);
         }
         if(this.mCurrentExchangeSupplyDropDustState == this.EXCHANGE_SUPPLY_STATE_EXCHANGE_AND_CONSUME)
         {
            broadcast(BCEvent.EVT_REWARD_CONSUME_SUPPLY_DROP_REQUEST,{
               "dropID":dropId,
               "quantity":1,
               "gotoPrevPageIfFailed":this.mGotoPrevPageIfFailed
            });
         }
         this.mCurrentExchangeSupplyDropDustState = this.EXCHANGE_SUPPLY_STATE_NONE;
      }
      
      private function onPurchaseSupplyDropFail(cRes:Object) : void
      {
         this.mCurrentExchangeSupplyDropDustState = this.EXCHANGE_SUPPLY_STATE_NONE;
         if(this.mGotoPrevPageIfFailed)
         {
            broadcast(BCEvent.GOTO_PREV_MAIN_PAGE);
         }
         this.mGotoPrevPageIfFailed = false;
      }
   }
}

