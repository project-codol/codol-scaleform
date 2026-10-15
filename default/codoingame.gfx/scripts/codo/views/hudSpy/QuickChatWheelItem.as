package codo.views.hudSpy
{
   import codo.common.CFunctionCommonContainer;
   import codo.common.CFunctionInGameContainer;
   import codo.component.TextField;
   import codo.component.core.UIInteractiveComponent;
   import codo.constants.SpyModeRoleType;
   import codo.objects.SpyQuickChatObj;
   import codo.style.GlobalGuide;
   import codo.style.SpyHudGuide;
   import codo.utils.LocalizeUtil;
   import flash.events.MouseEvent;
   
   public class QuickChatWheelItem extends UIInteractiveComponent
   {
      
      public static const TEAMTYPE_NORMAL:int = 1;
      
      public static const TEAMTYPE_SPY:int = 2;
      
      public static const UNFOCUS_KEY_COLOR:uint = 16743724;
      
      public static const FOCUS_KEY_COLOR:uint = GlobalGuide.WHITE;
      
      public var myTextTF:TextField;
      
      private var mRole:int;
      
      private var mCmd:int;
      
      private var mChatMessage:String;
      
      private var mMessage:String;
      
      public function QuickChatWheelItem()
      {
         super();
         isInteractiveEnabled = true;
         this.addEventListener(MouseEvent.CLICK,this.onClicked);
      }
      
      override public function setData(data:*) : void
      {
         super.setData(data);
         var quickChatObj:SpyQuickChatObj = data as SpyQuickChatObj;
         this.mRole = quickChatObj.role;
         this.mCmd = quickChatObj.cmd;
         this.mChatMessage = "@" + quickChatObj.chatMessage;
         this.mMessage = "@" + quickChatObj.message;
         this.myTextTF.textStyle = SpyHudGuide.QuickChatSmall;
         LocalizeUtil.paramColorized(this.myTextTF.myTextClip,this.mMessage,[this.mCmd.toString()],[UNFOCUS_KEY_COLOR]);
         gotoAndStop(1);
      }
      
      override protected function onMouseOver() : void
      {
         super.onMouseOver();
         if(this.mRole == SpyModeRoleType.SPY_ROLE_INVESTIGATOR)
         {
            gotoAndStop(2);
         }
         else if(this.mRole == SpyModeRoleType.SPY_ROLE_SPY)
         {
            gotoAndStop(3);
         }
         else
         {
            gotoAndStop(4);
         }
         LocalizeUtil.paramColorized(this.myTextTF.myTextClip,this.mMessage,[this.mCmd.toString()],[FOCUS_KEY_COLOR]);
      }
      
      override protected function onMouseOut() : void
      {
         super.onMouseOut();
         gotoAndStop(1);
         LocalizeUtil.paramColorized(this.myTextTF.myTextClip,this.mMessage,[this.mCmd.toString()],[UNFOCUS_KEY_COLOR]);
      }
      
      protected function onClicked(evt:MouseEvent) : void
      {
         CFunctionInGameContainer.AS_SpyHideQuickChatWheel();
      }
      
      public function sendCmdToDS() : void
      {
         var isGlobal:Boolean = this.mRole == SpyModeRoleType.SPY_ROLE_NONE;
         if(!CFunctionInGameContainer.AS_SpyCheckQuickChatCoolDown(isGlobal))
         {
            return;
         }
         CFunctionCommonContainer.ScriptMenuResponse("spy_quick_chat",this.mRole.toString() + "_" + this.mCmd.toString());
         var teamType:int = TEAMTYPE_NORMAL;
         if(this.mRole == SpyModeRoleType.SPY_ROLE_SPY)
         {
            teamType = TEAMTYPE_SPY;
         }
         CFunctionInGameContainer.AS_Say2Team(LocalizeUtil.localize(this.mChatMessage),teamType);
      }
   }
}

