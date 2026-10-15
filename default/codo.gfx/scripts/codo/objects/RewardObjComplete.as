package codo.objects
{
   import codo.common.CFunctionCommonContainer;
   import codo.common.CFunctionContainer;
   import codo.constants.MarketMenuData;
   import codo.localization.Dict;
   import codo.utils.ItemUtil;
   import codo.utils.LocalizeUtil;
   import codo.utils.TimeUtil;
   
   public dynamic class RewardObjComplete
   {
      
      public static const REWARD_TYPE_RENTAL:int = 0;
      
      public static const REWARD_TYPE_STACKABLE:int = 1;
      
      public static const REWARD_TYPE_CURRENCY:int = 2;
      
      private var mType:int = 0;
      
      private var mId:int = 1;
      
      private var mPara:int = 2;
      
      private var mExtraInfo1:Object;
      
      private var mExtraInfo2:Object;
      
      private var mCachedInfo:ProductObj;
      
      public function RewardObjComplete(type:int, id:int, para:int, extraInfo1:Object = null, extraInfo2:Object = null)
      {
         super();
         this.mType = type;
         this.mId = id;
         this.mPara = para;
         this.mExtraInfo1 = extraInfo1;
         this.mExtraInfo2 = extraInfo2;
      }
      
      public function getType() : int
      {
         return this.mType;
      }
      
      public function getId() : int
      {
         return this.mId;
      }
      
      public function getPara() : int
      {
         return this.mPara;
      }
      
      public function getName() : String
      {
         if(this.mType == REWARD_TYPE_CURRENCY)
         {
            return this.getCurrencyObj().name;
         }
         return this.getProductObj().name;
      }
      
      public function getDescription() : String
      {
         if(this.mType == REWARD_TYPE_CURRENCY)
         {
            return this.getCurrencyObj().description;
         }
         return this.getProductObj().description;
      }
      
      public function getImage() : String
      {
         if(this.mType == REWARD_TYPE_CURRENCY)
         {
            return this.getCurrencyObj().image;
         }
         return this.getProductObj().imageURL;
      }
      
      public function getParaString() : String
      {
         var paraString:String = "";
         if(this.mType == REWARD_TYPE_CURRENCY)
         {
            paraString = String(this.mPara);
         }
         else if(this.mType == REWARD_TYPE_RENTAL)
         {
            if(this.mPara <= 0)
            {
               paraString = Dict.FOREVER;
            }
            else
            {
               paraString = String(this.mPara) + LocalizeUtil.localize(Dict.DAY);
            }
         }
         else if(this.mType == REWARD_TYPE_STACKABLE)
         {
            paraString = String(this.mPara) + LocalizeUtil.localize(Dict.STACKABLE_UNIT);
         }
         return paraString;
      }
      
      public function getProductObj() : ProductObj
      {
         if(this.mCachedInfo != null && this.mCachedInfo.id == this.mId)
         {
            return this.mCachedInfo;
         }
         var isBundle:Boolean = CFunctionContainer.IsBundleProduct(this.mId) as Boolean;
         if(isBundle)
         {
            this.mCachedInfo = CFunctionCommonContainer.GetBundleInfo(this.mId) as ProductObj;
         }
         else
         {
            this.mCachedInfo = ItemUtil.getProductObjByProductId(this.mId);
         }
         if(this.mType == REWARD_TYPE_STACKABLE)
         {
            this.mCachedInfo.stackDelta = this.mPara;
         }
         if(this.mType == REWARD_TYPE_RENTAL)
         {
            this.mCachedInfo.remainSecond = this.mPara * TimeUtil.SECONDS_IN_A_DAY;
         }
         return this.mCachedInfo;
      }
      
      public function getCurrencyObj() : CurrencyObj
      {
         var currencyObj:CurrencyObj = new CurrencyObj();
         currencyObj.name = MarketMenuData.getCurrencyNameById(this.mId);
         currencyObj.description = MarketMenuData.getCurrencyDescriptionById(this.mId);
         currencyObj.image = MarketMenuData.getCurrencyImageById(this.mId);
         currencyObj.amount = this.mPara;
         return currencyObj;
      }
      
      public function getWrappedObj() : Object
      {
         if(this.mType == REWARD_TYPE_CURRENCY)
         {
            return this.getCurrencyObj();
         }
         return this.getProductObj();
      }
      
      public function getExtraInfo1() : Object
      {
         return this.mExtraInfo1;
      }
      
      public function getExtraInfo2() : Object
      {
         return this.mExtraInfo2;
      }
   }
}

