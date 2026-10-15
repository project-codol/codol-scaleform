package codo.component.playerinfo_part
{
   import codo.base.BaseSubElement;
   import codo.component.Button;
   import codo.constants.BCEvent;
   import codo.constants.GameInfo;
   import codo.localization.DictClan;
   import codo.localization.DictSystem;
   import flash.text.TextField;
   
   public class ErrorPage extends BaseSubElement
   {
      
      private static const BACK_BTN_WIDTH:Number = 150;
      
      private static const BACK_BTN_HEIGHT:Number = 33;
      
      public var myText:TextField;
      
      public var myBackButton:Button;
      
      public function ErrorPage()
      {
         super();
         this.initStage();
      }
      
      private function initStage() : void
      {
         this.myText.text = DictClan.PLAYER_DETAIL_INFO_FETCH_FAIL;
         this.myText.x = (GameInfo.DEFAULT_WIDTH - this.myText.width) * 0.5;
         this.myBackButton.width = BACK_BTN_WIDTH;
         this.myBackButton.height = BACK_BTN_HEIGHT;
         this.myBackButton.x = (GameInfo.DEFAULT_WIDTH - this.myBackButton.width) * 0.5;
         this.myBackButton.label = DictSystem.CONFIRM;
         this.myBackButton.registerClickEvent(this.onBackButtonClicked);
      }
      
      private function onBackButtonClicked() : void
      {
         broadcast(BCEvent.EVT_CLOSE_DETAIL);
      }
   }
}

