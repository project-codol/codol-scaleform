package codo.views
{
   import codo.constants.BCEvent;
   import codo.constants.BCInGameEvent;
   import codo.constants.DataID;
   import codo.objects.AARChallengeObj;
   import codo.utils.Logger;
   import components.BaseButton;
   import components.CodoGrowButtonNoTint;
   import components.ingameaar_part.AARPanelChallenges;
   import components.ingameaar_part.AARPanelGamePoints;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   
   public class AARBaseView extends ScoreboardBaseView
   {
      
      public var myPanelGamePoints:AARPanelGamePoints;
      
      public var myPanelChallenges:AARPanelChallenges;
      
      public var myEarlyExitButton:CodoGrowButtonNoTint;
      
      public function AARBaseView()
      {
         super();
      }
      
      public function get allowExit() : Boolean
      {
         return this.myEarlyExitButton.visible;
      }
      
      override protected function enableData() : void
      {
         super.enableData();
         Logger.print("HudAARView::enableData");
         var challenges:Vector.<AARChallengeObj> = this.getDP(DataID.AAR_CHALLENGES);
         this.myPanelChallenges.SetChallengeData(challenges);
         this.myEarlyExitButton.addEventListener(BaseButton.EVT_CLICK,this.onBackButtonClick);
         if(this.stage != null)
         {
            stage.addEventListener(KeyboardEvent.KEY_DOWN,this.onStageKeyDown);
         }
         this.broadcast(BCEvent.EVT_STOP_CONTROLLER_RUMBLE);
      }
      
      override protected function disableData() : void
      {
         super.disableData();
         if(this.stage != null)
         {
            stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.onStageKeyDown);
         }
         this.myEarlyExitButton.removeEventListener(BaseButton.EVT_CLICK,this.onBackButtonClick);
      }
      
      private function onBackButtonClick(event:Event) : void
      {
         this.HandleBack();
      }
      
      private function onStageKeyDown(event:KeyboardEvent) : void
      {
         if(event.keyCode == 27)
         {
            this.HandleBack();
         }
      }
      
      protected function HandleBack() : void
      {
         if(this.allowExit)
         {
            this.broadcast(BCInGameEvent.BACK_TO_LOBBY_MENU);
         }
      }
   }
}

