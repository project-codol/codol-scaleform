package codo.controllers
{
   import codo.base.BaseController;
   import codo.common.CFunctionCommonContainer;
   import codo.constants.BCCommonEvent;
   import codo.constants.DataID;
   import codo.constants.PageID;
   import codo.event.ParaEvent;
   
   public class ScreenshotController extends BaseController
   {
      
      public static const FROM_IN_GAME:int = 0;
      
      public static const FROM_MAIN_MENU:int = 1;
      
      private var m_takingScreenshot:Boolean = false;
      
      private var m_screenshotStateChangedCB:Function;
      
      private var m_mode:int;
      
      private var m_maskShowing:Boolean = false;
      
      private var m_socialShowing:Boolean = false;
      
      public function ScreenshotController()
      {
         super();
         this.listen(BCCommonEvent.MASK_STATE_CHANGED,this.onMaskStateChangedHandler);
         this.listen(BCCommonEvent.SOCIAL_PANEL_STATE_CHANGED,this.onSocialPanelStateChanged);
      }
      
      public function setMode(value:int) : void
      {
         this.m_mode = value;
      }
      
      public function cppScreenshotStateChanged(isOpen:Boolean) : void
      {
         if(this.m_takingScreenshot != isOpen)
         {
            this.m_takingScreenshot = isOpen;
            if(this.m_mode == FROM_IN_GAME && this.needMarkInGame())
            {
               if(this.m_screenshotStateChangedCB != null)
               {
                  this.m_screenshotStateChangedCB(this.m_takingScreenshot);
               }
            }
            else if(this.m_mode == FROM_MAIN_MENU && this.needMark())
            {
               if(this.m_screenshotStateChangedCB != null)
               {
                  this.m_screenshotStateChangedCB(this.m_takingScreenshot);
               }
            }
         }
         if(this.m_takingScreenshot)
         {
            CFunctionCommonContainer.setdvar("ui_scaleformWaterMarkDone","1");
         }
      }
      
      public function get screenshotState() : Boolean
      {
         return this.m_takingScreenshot;
      }
      
      public function setScreenshotStateChangedCB(callback:Function) : void
      {
         this.m_screenshotStateChangedCB = callback;
      }
      
      private function onMaskStateChangedHandler(e:ParaEvent) : void
      {
         this.m_maskShowing = e.myPara as Boolean;
      }
      
      private function onSocialPanelStateChanged(e:ParaEvent) : void
      {
         this.m_socialShowing = e.myPara as Boolean;
      }
      
      private function needMarkInGame() : Boolean
      {
         return false;
      }
      
      private function needMark() : Boolean
      {
         var highestCurrentPageID:String = getDP(DataID.CURRENT_PAGE_ID_AT_HIGHEST_DEPTH);
         if(Boolean(getDP(DataID.HAS_POPUP)) || highestCurrentPageID == PageID.INROOM)
         {
            return true;
         }
         if(this.m_socialShowing)
         {
            return true;
         }
         if(this.m_maskShowing)
         {
            return true;
         }
         return false;
      }
   }
}

