package codo.component.lobby
{
   import codo.component.CloseButton;
   import codo.component.onboarding.CharacterSelectModuleStat;
   import codo.localization.DictOnBoard;
   import codo.objects.ZombieChampionObj;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class ZombieChampionDetailLobby extends ZombieChampionDetailPanel
   {
      
      public var myChampName:TextField;
      
      public var myChampDesc:TextField;
      
      public var myChampImage:MovieClip;
      
      public var myChampSpiritIcon:MovieClip;
      
      public var myChampVital0:CharacterSelectModuleStat;
      
      public var myChampVital1:CharacterSelectModuleStat;
      
      public var myChampVital2:CharacterSelectModuleStat;
      
      public var myBackButton:CloseButton;
      
      public function ZombieChampionDetailLobby()
      {
         super();
         this.myBackButton.registerClickEvent(this.onBackClicked);
      }
      
      override public function show(champion:ZombieChampionObj) : void
      {
         super.show(champion);
         this.myChampName.text = champion.name;
         this.myChampDesc.text = champion.description;
         this.myChampImage.gotoAndStop(champion.id);
         this.myChampSpiritIcon.gotoAndStop(champion.id);
         var vitals:Array = champion.vitals.split("|");
         this.myChampVital0.configStat(DictOnBoard.ONBOARDING_CHARACTER_SELECT_LABEL_VITAL_AGE,vitals[0]);
         this.myChampVital1.configStat(DictOnBoard.ONBOARDING_CHARACTER_SELECT_LABEL_VITAL_HEIGHT,vitals[1]);
         this.myChampVital2.configStat(DictOnBoard.ONBOARDING_CHARACTER_SELECT_LABEL_VITAL_WEIGHT,vitals[2]);
         this.myChampVital0.skipAnimation();
         this.myChampVital1.skipAnimation();
         this.myChampVital2.skipAnimation();
      }
      
      private function onBackClicked() : void
      {
         this.hide();
      }
   }
}

