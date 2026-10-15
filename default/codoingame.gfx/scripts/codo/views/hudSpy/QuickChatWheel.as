package codo.views.hudSpy
{
   import codo.common.CFunctionInGameContainer;
   import codo.component.core.UIInteractiveComponent;
   import codo.constants.SpyModeRoleType;
   import codo.objects.SpyQuickChatObj;
   import flash.display.MovieClip;
   import flash.events.KeyboardEvent;
   
   public class QuickChatWheel extends UIInteractiveComponent
   {
      
      public var myCmd1:QuickChatWheelItem;
      
      public var myCmd2:QuickChatWheelItem;
      
      public var myCmd3:QuickChatWheelItem;
      
      public var myCmd4:QuickChatWheelItem;
      
      public var myCmd5:QuickChatWheelItem;
      
      public var myCmd6:QuickChatWheelItem;
      
      public var myCmd7:QuickChatWheelItem;
      
      public var myCmd8:QuickChatWheelItem;
      
      public var myRoleIcon:MovieClip;
      
      private var mCmds:Vector.<QuickChatWheelItem>;
      
      private var mSelectedCmd:int;
      
      public function QuickChatWheel()
      {
         super();
         this.mCmds = new <QuickChatWheelItem>[this.myCmd1,this.myCmd2,this.myCmd3,this.myCmd4,this.myCmd5,this.myCmd6,this.myCmd7,this.myCmd8];
         this.mSelectedCmd = 0;
      }
      
      public function cppShowQuickChatWheel(role:int) : void
      {
         var i:int = 0;
         var cmd:int = 0;
         var quickChatObj:SpyQuickChatObj = null;
         this.mSelectedCmd = 0;
         if(role == SpyModeRoleType.SPY_ROLE_INVESTIGATOR || role == SpyModeRoleType.SPY_ROLE_SPY)
         {
            this.myRoleIcon.gotoAndStop(role);
         }
         else
         {
            this.myRoleIcon.gotoAndStop(SpyModeRoleType.SPY_ROLE_CIVILIAN);
         }
         for(i = 0; i < this.mCmds.length; i++)
         {
            cmd = i + 1;
            quickChatObj = CFunctionInGameContainer.AS_SpyGetQuickChatInfo(role,cmd);
            if(quickChatObj == null)
            {
               this.mCmds[i].visible = false;
            }
            else
            {
               this.mCmds[i].visible = true;
               this.mCmds[i].setData(quickChatObj);
            }
         }
         parent.stage.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDownHandler);
         visible = true;
      }
      
      public function cppHideQuickChatWheel() : void
      {
         var i:int = 0;
         parent.stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDownHandler);
         if(this.mSelectedCmd != 0)
         {
            this.mCmds[this.mSelectedCmd - 1].sendCmdToDS();
            this.mSelectedCmd = 0;
         }
         else
         {
            for(i = 0; i < this.mCmds.length; i++)
            {
               if(this.mCmds[i].isFocused())
               {
                  this.mCmds[i].sendCmdToDS();
                  break;
               }
            }
         }
         visible = false;
      }
      
      private function onKeyDownHandler(cEvt:KeyboardEvent) : void
      {
         var cmd:int = 0;
         var beginCharCode:int = "1".charCodeAt();
         var endCharCode:int = "8".charCodeAt();
         if(cEvt.charCode >= beginCharCode && cEvt.charCode <= endCharCode)
         {
            cmd = cEvt.charCode - beginCharCode;
            this.mSelectedCmd = cmd + 1;
            CFunctionInGameContainer.AS_SpyHideQuickChatWheel();
         }
      }
   }
}

