package codo.utils
{
   import codo.common.CFunctionCommonContainer;
   import codo.localization.DictCareer;
   
   public class MiscUtil
   {
      
      public function MiscUtil()
      {
         super();
      }
      
      public static function getFormattedRankPrestige(prestigeLevel:int) : String
      {
         var level:int = prestigeLevel % 100;
         var prestige:int = (prestigeLevel - level) / 100;
         var levelStr:String = CFunctionCommonContainer.GetDisplayLevel(level - 1);
         if(prestige == 0)
         {
            return LocalizeUtil.param(DictCareer.CAREER_X_LEVEL,[levelStr]);
         }
         return LocalizeUtil.param(DictCareer.CAREER_X_PRESTIGE,[String(prestige),levelStr]);
      }
      
      public static function getLocalizedPlaylistUnlockHintByFlag(flag:String) : String
      {
         return LocalizeUtil.localize("@SF_UI_" + flag);
      }
   }
}

