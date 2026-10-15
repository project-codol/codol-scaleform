package components.fsgmatchresult_part
{
   import codo.constants.DataID;
   import codo.localization.DictWarGod;
   import codo.manager.DataManager;
   import codo.objects.WarGodGlobalSettingObj;
   import codo.utils.LocalizeUtil;
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class HPEHPRewardBox extends MovieClip
   {
      
      private static const CURRENCY_ID_HP:int = 8;
      
      private static const CURRENCY_ID_EHP:int = 9;
      
      public static const ARRAY_INDEX_JUNIOR_WARGOD_CURRENCY_TYPE:int = 5;
      
      public static const ARRAY_INDEX_JUNIOR_WARGOD_CURRENCY_GAINED:int = 6;
      
      public static const ARRAY_INDEX_JUNIOR_WARGOD_CURRENCY_REMAIN:int = 7;
      
      public static const ARRAY_INDEX_JUNIOR_WARGOD_CURRENCY_LIMIT:int = 8;
      
      public static const ARRAY_INDEX_JUNIOR_WARGOD_HAS_DAILY_BONUS:int = 9;
      
      public static const ARRAY_INDEX_SENIOR_WARGOD_CURRENCY_TYPE:int = 3;
      
      public static const ARRAY_INDEX_SENIOR_WARGOD_CURRENCY_GAINED:int = 4;
      
      public static const ARRAY_INDEX_SENIOR_WARGOD_CURRENCY_REMAIN:int = 5;
      
      public static const ARRAY_INDEX_SENIOR_WARGOD_CURRENCY_LIMIT:int = 6;
      
      public static const ARRAY_INDEX_SENIOR_WARGOD_HAS_DAILY_BONUS:int = 7;
      
      private static const REMAINING_SHOW_THRESHOLD:Number = 0.3;
      
      private static const ANIMATION_DURATION:int = 1;
      
      public var myHP:MovieClip;
      
      public var myEHP:MovieClip;
      
      public var myWinValue:TextField;
      
      public var myWinDaily:TextField;
      
      private var mTargetGained:int = 0;
      
      private var mTargetRemain:int = 0;
      
      private var mTweenLite:TweenLite;
      
      private var mHasDailyBonus:int = 0;
      
      public function HPEHPRewardBox()
      {
         super();
      }
      
      public function setData(data:Array) : void
      {
         var currencyType:String = null;
         var currencyGained:int = 0;
         var currencyRemain:int = 0;
         var currencyLimit:int = 0;
         var hasDailyBonus:int = 0;
         var league:String = data[0];
         if(league == "J")
         {
            currencyType = data[ARRAY_INDEX_JUNIOR_WARGOD_CURRENCY_TYPE];
            currencyGained = int(data[ARRAY_INDEX_JUNIOR_WARGOD_CURRENCY_GAINED]);
            currencyRemain = int(data[ARRAY_INDEX_JUNIOR_WARGOD_CURRENCY_REMAIN]);
            currencyLimit = int(data[ARRAY_INDEX_JUNIOR_WARGOD_CURRENCY_LIMIT]);
            hasDailyBonus = int(data[ARRAY_INDEX_JUNIOR_WARGOD_HAS_DAILY_BONUS]);
         }
         else
         {
            currencyType = data[ARRAY_INDEX_SENIOR_WARGOD_CURRENCY_TYPE];
            currencyGained = int(data[ARRAY_INDEX_SENIOR_WARGOD_CURRENCY_GAINED]);
            currencyRemain = int(data[ARRAY_INDEX_SENIOR_WARGOD_CURRENCY_REMAIN]);
            currencyLimit = int(data[ARRAY_INDEX_SENIOR_WARGOD_CURRENCY_LIMIT]);
            hasDailyBonus = int(data[ARRAY_INDEX_SENIOR_WARGOD_HAS_DAILY_BONUS]);
         }
         this.myHP.visible = currencyType == "B";
         this.myEHP.visible = currencyType == "A";
         visible = this.myHP.visible || this.myEHP.visible;
         this.mTargetGained = currencyGained;
         this.mTargetRemain = currencyRemain;
         this.mHasDailyBonus = hasDailyBonus;
         this.myWinDaily.visible = currencyRemain / currencyLimit < REMAINING_SHOW_THRESHOLD || Boolean(this.mHasDailyBonus);
         this.setLabel(0,0,this.getDailyBonusHint());
      }
      
      public function startAnimation() : void
      {
         this.mTweenLite = TweenLite.to(this,ANIMATION_DURATION,{
            "onUpdate":this.onUpdateHandler,
            "onComplete":this.onCompleteHandler
         });
      }
      
      private function onUpdateHandler() : void
      {
         var progress:Number = this.mTweenLite.currentTime / this.mTweenLite.totalDuration;
         this.setLabel(Math.floor(this.mTargetGained * progress),Math.floor(this.mTargetRemain * progress),this.getDailyBonusHint());
      }
      
      private function onCompleteHandler() : void
      {
         this.setLabel(this.mTargetGained,this.mTargetRemain,this.getDailyBonusHint());
      }
      
      private function getDailyBonusHint() : String
      {
         var wargodGlobalSetting:WarGodGlobalSettingObj = DataManager.getInstance().getDP(DataID.WARGOD_GLOBAL_SETTING);
         if(Boolean(this.mHasDailyBonus))
         {
            return wargodGlobalSetting.dailyBonusHint;
         }
         return "";
      }
      
      private function setLabel(gained:int, remain:int, dailyBonus:String) : void
      {
         this.myWinValue.text = String(gained);
         this.myWinDaily.text = LocalizeUtil.param(DictWarGod.WARGOD_CURRENCY_REMAIN,[String(remain)]);
         if(dailyBonus != "")
         {
            this.myWinDaily.text = dailyBonus;
         }
      }
   }
}

