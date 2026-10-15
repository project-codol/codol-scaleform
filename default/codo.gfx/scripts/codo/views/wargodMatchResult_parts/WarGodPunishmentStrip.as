package codo.views.wargodMatchResult_parts
{
   import codo.localization.DictWarGod;
   import codo.objects.WarGodMatchResultObj;
   import codo.objects.WarGodPlayerObj;
   import codo.utils.WarGodUtility;
   import flash.text.TextField;
   
   public class WarGodPunishmentStrip extends WarGodAnimateElement
   {
      
      private var isValid:Boolean;
      
      public var myLabel:TextField;
      
      public function WarGodPunishmentStrip()
      {
         super();
      }
      
      public function setData(data:WarGodMatchResultObj) : void
      {
         this.isValid = data.hasPunishment;
         if(data.beforePhase == WarGodPlayerObj.PHASE_PLACEMENT)
         {
            this.x = 0;
            this.y = 505;
            this.myLabel.text = DictWarGod.WARGOD_PUNISHMENT_WARN_PLACEMENT;
         }
         else if(data.beforePhase == WarGodPlayerObj.PHASE_STAR)
         {
            if(WarGodUtility.isJuniorWarGodByScore(data.beforeScore))
            {
               this.x = 201;
               this.y = 380;
               this.myLabel.text = DictWarGod.WARGOD_PUNISHMENT_WARN_STAR_JUNIOR;
            }
            else
            {
               this.x = 100;
               this.y = 660;
               this.myLabel.text = DictWarGod.WARGOD_PUNISHMENT_WARN_STAR;
            }
         }
         else if(data.beforePhase == WarGodPlayerObj.PHASE_PROMOTION)
         {
            this.x = 0;
            this.y = 505;
            this.myLabel.text = DictWarGod.WARGOD_PUNISHMENT_WARN_PROMOTION;
         }
      }
      
      override public function startAni() : void
      {
         if(this.isValid)
         {
            super.startAni();
         }
      }
   }
}

