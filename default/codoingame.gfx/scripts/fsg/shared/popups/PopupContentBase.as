package fsg.shared.popups
{
   import codo.constants.BCEvent;
   import codo.constants.TipType;
   import codo.localization.Dict;
   import codo.manager.EventManager;
   import codo.objects.SystemMsgObj;
   import codo.utils.LocalizeUtil;
   import codo.utils.StageUtil;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.getDefinitionByName;
   
   public class PopupContentBase extends Sprite
   {
      
      public static const CONTENT_PADDING:uint = 18;
      
      public static const CONTENT_TOP_PADDING:uint = 70;
      
      protected static const LOCALIZE:Function = LocalizeUtil.localize;
      
      public var myPopupBase:PopupStyleBase;
      
      protected var mProceedCallback:Function;
      
      public function PopupContentBase()
      {
         super();
      }
      
      public function init() : void
      {
         this.configPopUpBase();
         if(this.backgroundImageClassName != null)
         {
            this.myPopupBase.setBackgroundImage(getDefinitionByName(this.backgroundImageClassName) as Class);
         }
      }
      
      public function setData(... args) : void
      {
      }
      
      public function set proceedCallback(callback:Function) : void
      {
         this.mProceedCallback = callback;
      }
      
      public function get contentHeight() : uint
      {
         return this.myPopupBase.contentHeight;
      }
      
      public function get contentWidth() : uint
      {
         return this.myPopupBase.contentWidth;
      }
      
      public function get contentInnerHeight() : uint
      {
         return this.myPopupBase.contentInnerHeight;
      }
      
      public function get contentInnerWidth() : uint
      {
         return this.myPopupBase.contentInnerWidth;
      }
      
      protected function configPopUpBase() : void
      {
         this.myPopupBase.resetButtons();
         this.myPopupBase.setSize(this.viewWidth,this.viewHeight);
      }
      
      protected function get backgroundImageClassName() : String
      {
         return "fsg.popups.fsgContentImgBase";
      }
      
      protected function get viewWidth() : uint
      {
         return 852;
      }
      
      protected function get viewHeight() : uint
      {
         return 452;
      }
      
      public function initListeners() : void
      {
      }
      
      protected function broadcast(cType:String, cData:* = null) : void
      {
         EventManager.getInstance().broadcast(cType,cData);
      }
      
      protected function showMsg(cMsg:String, cBtnCount:int = 0, cPriority:int = 0, cCallback0:Function = null, cLabel0:String = "", cCallback1:Function = null, cLabel1:String = "", cCallback2:Function = null, cLabel2:String = "", cDelay:Number = 0, customTitle:String = "") : void
      {
         this.broadcast(BCEvent.EVT_SHOW_SYSTEM_MSG,SystemMsgObj.getObj(cMsg,cBtnCount,cPriority,cCallback0,cLabel0,cCallback1,cLabel1,cCallback2,cLabel2,0,cDelay));
      }
      
      protected function onMouseOverTooltip(e:MouseEvent = null) : void
      {
         var tempPos:Point = StageUtil.localPosToStagePos(this.myPopupBase.confirmButtonRef);
         tempPos.x += this.myPopupBase.confirmButtonRef.width / 2;
         tempPos.y += this.myPopupBase.confirmButtonRef.height;
         this.broadcast(BCEvent.TIP_SHOW,{
            "type":TipType.TEXT,
            "text":Dict.NAME_ERROR_LENGTH,
            "pos":tempPos,
            "size":new Point()
         });
      }
      
      protected function onMouseOutTooltip(e:MouseEvent = null) : void
      {
         this.broadcast(BCEvent.TIP_HIDE,null);
      }
      
      public function startTransitionIn() : void
      {
      }
      
      public function startTransitionOut() : void
      {
      }
   }
}

