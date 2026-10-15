package codo.controllers
{
   import codo.common.CFunctionCommonContainer;
   import codo.constants.BCEvent;
   import codo.constants.Common;
   import codo.constants.DataID;
   import codo.utils.Logger;
   
   public class FSGAutoTestControllerFEM extends FSGAutoTestController
   {
      
      public function FSGAutoTestControllerFEM()
      {
         super();
      }
      
      public function ConfirmKeyboard() : void
      {
         Logger.print("Sending keyboard select event.");
         this.broadcast(BCEvent.CHOOSE_KEYBOARD,{"keyboard":Common.KEYBOARD_CODO});
      }
      
      override public function UpdateState() : void
      {
         super.UpdateState();
         CFunctionCommonContainer.setdvar("fsg_autotest_page",this.getDP(DataID.CURRENT_MAIN_PAGE_ID));
      }
      
      public function SetMap(mapID:String) : void
      {
      }
   }
}

