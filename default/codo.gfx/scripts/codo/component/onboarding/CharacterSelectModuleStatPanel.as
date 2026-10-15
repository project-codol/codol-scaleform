package codo.component.onboarding
{
   import codo.localization.DictOnBoard;
   import codo.objects.OnboardCharacterOptionObj;
   import codo.utils.LocalizeUtil;
   import flash.display.Sprite;
   
   public class CharacterSelectModuleStatPanel extends Sprite
   {
      
      public var myStatWeight:CharacterSelectModuleStat;
      
      public var myStatHeight:CharacterSelectModuleStat;
      
      public var myStatAge:CharacterSelectModuleStat;
      
      public function CharacterSelectModuleStatPanel()
      {
         super();
      }
      
      public function setData(data:OnboardCharacterOptionObj = null) : void
      {
         this.resetPanel();
         var LOCALIZE:Function = LocalizeUtil.localize;
         var vitals:Array = data.characterVitals.split(",");
         this.myStatAge.configStat(LOCALIZE(DictOnBoard.ONBOARDING_CHARACTER_SELECT_LABEL_VITAL_AGE).toUpperCase(),vitals[0]);
         this.myStatHeight.configStat(LOCALIZE(DictOnBoard.ONBOARDING_CHARACTER_SELECT_LABEL_VITAL_HEIGHT).toUpperCase(),vitals[1]);
         this.myStatWeight.configStat(LOCALIZE(DictOnBoard.ONBOARDING_CHARACTER_SELECT_LABEL_VITAL_WEIGHT).toUpperCase(),vitals[2]);
         this.startStatCounters();
      }
      
      private function startStatCounters() : void
      {
         var STAT_COUNT_DELAY:Number = 0.2;
         this.myStatAge.startAnimateFromZero();
         this.myStatWeight.startAnimateFromZero(STAT_COUNT_DELAY);
         this.myStatHeight.startAnimateFromZero(STAT_COUNT_DELAY * 2);
      }
      
      private function resetPanel() : void
      {
         this.myStatAge.prepareForAnimateFromZero();
         this.myStatHeight.prepareForAnimateFromZero();
         this.myStatWeight.prepareForAnimateFromZero();
      }
   }
}

