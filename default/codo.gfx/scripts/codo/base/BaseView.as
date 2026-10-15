package codo.base
{
   import codo.constants.BCEvent;
   import codo.constants.DataID;
   import codo.constants.ViewState;
   import codo.cpp.UiCppView;
   import codo.interfaces.IBasePageLayer;
   import codo.interfaces.IBaseView;
   import codo.interfaces.IDataManager;
   import codo.interfaces.IEventManager;
   import codo.objects.BindDataHelper;
   import codo.objects.ComponentListener;
   import codo.objects.SystemMsgObj;
   import codo.theme.BaseTheme;
   import codo.utils.Logger;
   import codo.utils.ScaleformUtil;
   import codo.utils.SoundUtil;
   import com.greensock.TweenMax;
   import flash.display.DisplayObject;
   import flash.events.KeyboardEvent;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.system.Capabilities;
   import flash.utils.Dictionary;
   import flash.utils.getDefinitionByName;
   import shaui.component.core.InteractiveComponent;
   
   public class BaseView extends InteractiveComponent implements IBaseView
   {
      
      public static var DataManager:IDataManager;
      
      public static var EventManager:IEventManager;
      
      private var _container:IBasePageLayer;
      
      protected var _pageID:String;
      
      protected var _uiCpp:UiCppView;
      
      private var _state:int = 0;
      
      private var _initState:int = -1;
      
      private var _delayInited:Boolean = false;
      
      private var _componentListeners:Dictionary;
      
      protected var mInOnboardTourMode:Boolean;
      
      protected var mThemeSetNew:Vector.<Object>;
      
      public function BaseView()
      {
         super();
         this.initTheme();
         if(ScaleformUtil.isScaleform)
         {
            this._uiCpp = this.makeUiCpp();
         }
      }
      
      public static function staticShowMsg(cMsg:String, cBtnCount:int = 0, cPriority:int = 0, cCallback0:Function = null, cLabel0:String = "", cCallback1:Function = null, cLabel1:String = "", cCallback2:Function = null, cLabel2:String = "", cDelay:Number = 0) : void
      {
         EventManager.broadcast(BCEvent.EVT_SHOW_SYSTEM_MSG,SystemMsgObj.getObj(cMsg,cBtnCount,cPriority,cCallback0,cLabel0,cCallback1,cLabel1,cCallback2,cLabel2,0,cDelay));
      }
      
      protected function setupThemeVector() : void
      {
         this.mThemeSetNew = new Vector.<Object>();
      }
      
      protected function initTheme() : void
      {
         var set:Object = null;
         this.setupThemeVector();
         var themeSuite:BaseTheme = this.getDP(DataID.GET_THEME_SUITE);
         for(var i:int = 0; i < this.mThemeSetNew.length; i++)
         {
            set = this.mThemeSetNew[i];
            themeSuite.tryApplyThemePiece(set.clip,set.piece);
         }
      }
      
      protected function initThemedClip(clip:DisplayObject, linkage:String) : void
      {
         var clipPosition:Point = null;
         var themedClass:Class = null;
         var depth:int = 0;
         var clipName:String = clip.name;
         clipPosition = new Point(clip.x,clip.y);
         themedClass = getDefinitionByName(linkage) as Class;
         depth = getChildIndex(clip);
         removeChild(clip);
         clip = new themedClass();
         this[clipName] = clip;
         addChild(clip);
         clip.x = clipPosition.x;
         clip.y = clipPosition.y;
         setChildIndex(clip,depth);
      }
      
      public function init() : void
      {
         var target:DisplayObject = null;
         for(var i:uint = 0; i < numChildren; i++)
         {
            target = getChildAt(i);
            if(target is BaseView)
            {
               (target as BaseView).init();
            }
         }
      }
      
      protected function playSound(vo_alias:String) : void
      {
         SoundUtil.getInstance().playSound(vo_alias);
      }
      
      protected function stopSound() : void
      {
         SoundUtil.getInstance().stopSound();
      }
      
      public function initState(cState:int) : void
      {
         this._initState = cState;
      }
      
      override protected function onInit() : void
      {
         super.onInit();
         if(Boolean(this._uiCpp))
         {
            this._uiCpp.OnInit();
         }
      }
      
      public function set routeData(data:*) : void
      {
      }
      
      protected function makeUiCpp() : UiCppView
      {
         return null;
      }
      
      public function setShowingTutorial(showing:Boolean) : void
      {
         this.mInOnboardTourMode = showing;
      }
      
      public function get isShowingTutorial() : Boolean
      {
         return this.mInOnboardTourMode;
      }
      
      override protected function delayInit() : void
      {
         this._delayInited = true;
         if(Capabilities.playerType == "External" && ScaleformUtil.isScaleform == false)
         {
            this.onBlock();
         }
         else if(this._initState != -1)
         {
            this.state = this._initState;
            this._initState = -1;
         }
      }
      
      public function set container(cContainer:IBasePageLayer) : void
      {
         this._container = cContainer;
      }
      
      public function get pageID() : String
      {
         return this._pageID;
      }
      
      public function set pageID(pageID:String) : void
      {
         if(null != pageID)
         {
            this._pageID = pageID;
         }
      }
      
      public function get state() : int
      {
         return this._state;
      }
      
      public function set state(s:int) : void
      {
         if(this._delayInited == false)
         {
            this.initState(s);
         }
         else
         {
            this._state = s;
            switch(s)
            {
               case ViewState.ACTIVATED:
                  mouseInteractivity = enable;
                  this.onActivated();
                  break;
               case ViewState.BACKGROUND:
                  mouseInteractivity = false;
                  this.onBackGround();
                  break;
               case ViewState.BLOCK:
                  mouseInteractivity = false;
                  this.onBlock();
                  break;
               case ViewState.DEACTIVATED:
                  mouseInteractivity = false;
                  this.onDeactivated();
            }
         }
      }
      
      private function onActivated() : void
      {
         this.enableData();
         this.showView();
      }
      
      private function onBackGround() : void
      {
         this.enableData();
         this.hideView();
      }
      
      private function onBlock() : void
      {
         this.disableData();
         this.showView();
      }
      
      private function onDeactivated() : void
      {
         this.disableData();
         this.hideView();
      }
      
      protected function enableData() : void
      {
      }
      
      protected function disableData() : void
      {
      }
      
      protected function showView() : void
      {
         visible = true;
         if(Boolean(this._uiCpp))
         {
            this._uiCpp.ShowView();
         }
      }
      
      protected function hideView() : void
      {
         visible = false;
         if(Boolean(this._uiCpp))
         {
            this._uiCpp.HideView();
         }
      }
      
      protected function get isDataAble() : Boolean
      {
         return this._state == ViewState.ACTIVATED || this._state == ViewState.BACKGROUND;
      }
      
      protected function get isVisible() : Boolean
      {
         return this._state == ViewState.NONE || this._state == ViewState.BLOCK || this._state == ViewState.DEACTIVATED;
      }
      
      protected function tweenShow(cSpd:Number, cParams:Object, cTarget:DisplayObject = null, cReset3DMatrix:Matrix = null, cFromVars:Object = null) : void
      {
         if(cTarget == null)
         {
            cTarget = this;
         }
         if(!cParams.hasOwnProperty("autoAlpha"))
         {
            cParams.autoAlpha = 1;
         }
         if(cParams.onComplete == null && cReset3DMatrix != null)
         {
            cParams.onComplete = this.onShowTweenComplete;
            cParams.onCompleteParams = [cTarget,cReset3DMatrix];
         }
         TweenMax.killTweensOf(cTarget);
         TweenMax.killDelayedCallsTo(cTarget);
         if(cFromVars != null)
         {
            TweenMax.fromTo(cTarget,cSpd,cFromVars,cParams);
         }
         else
         {
            TweenMax.to(cTarget,cSpd,cParams);
         }
      }
      
      protected function tweenHide(cSpd:Number, cParams:Object, cTarget:DisplayObject = null) : void
      {
         if(cTarget == null)
         {
            cTarget = this;
         }
         if(!cParams.hasOwnProperty("autoAlpha") && cParams.onComplete == null)
         {
            cParams.autoAlpha = 0;
            cParams.onComplete = this.onHideTweenComplete;
            cParams.onCompleteParams = [cTarget];
         }
         TweenMax.killTweensOf(cTarget);
         TweenMax.killDelayedCallsTo(cTarget);
         TweenMax.to(cTarget,cSpd,cParams);
      }
      
      public function addToBlur() : void
      {
      }
      
      public function removeFromBlur() : void
      {
      }
      
      private function onShowTweenComplete(cTarget:DisplayObject, cTargetMatrix:Matrix) : void
      {
         cTarget.transform.matrix3D = null;
         cTarget.transform.matrix = cTargetMatrix;
      }
      
      private function onHideTweenComplete(cTarget:DisplayObject) : void
      {
         cTarget.visible = false;
      }
      
      protected function showRightClickMenu(cRightClickMenuType:String, cParams:Array = null, cPos:Object = null) : void
      {
         this.broadcast(BCEvent.EVT_SHOW_RIGHT_CLICK_MENU,{
            "type":cRightClickMenuType,
            "params":cParams,
            "pos":cPos
         });
      }
      
      protected function showMsg(cMsg:String, cBtnCount:int = 0, cPriority:int = 0, cCallback0:Function = null, cLabel0:String = "", cCallback1:Function = null, cLabel1:String = "", cCallback2:Function = null, cLabel2:String = "", cDelay:Number = 0) : void
      {
         Logger.print("BaseView:::showMsg this/msg: " + this + "/" + cMsg);
         staticShowMsg(cMsg,cBtnCount,cPriority,cCallback0,cLabel0,cCallback1,cLabel1,cCallback2,cLabel2,cDelay);
      }
      
      protected function hideMsg(cTime:Number = 0, cCallback:Function = null) : void
      {
         Logger.print("BaseView:::hideMsg this: " + this);
         this.broadcast(BCEvent.EVT_HIDE_SYSTEM_MSG,{
            "delayTime":cTime,
            "callback":cCallback,
            "triggerType":0,
            "priority":0
         });
      }
      
      protected function broadcast(cType:String, cData:* = null) : void
      {
         if(EventManager != null)
         {
            EventManager.broadcast(cType,cData);
         }
      }
      
      protected function listen(cEvtType:String, cCallback:Function, priority:int = 0) : void
      {
         if(EventManager != null)
         {
            EventManager.listen(cEvtType,cCallback,false,priority);
         }
      }
      
      protected function unlisten(cEvtType:String, cCallback:Function) : void
      {
         if(EventManager != null)
         {
            EventManager.unlisten(cEvtType,cCallback);
         }
      }
      
      protected function createBindHelper(cDataID:*, cCallback:Function, cParams:* = null, cImmediateCall:Boolean = true, initialDataVersion:uint = 0) : BindDataHelper
      {
         return new BindDataHelper(cDataID,cCallback,cParams,cImmediateCall,true,false,initialDataVersion);
      }
      
      protected function bind(cDataID:*, cCallback:Function, cParams:* = null, cImmediateCall:Boolean = true) : void
      {
         if(DataManager != null)
         {
            DataManager.bind(cDataID,cCallback,cParams,cImmediateCall,true,false);
         }
      }
      
      protected function unbind(cDataID:*, cCallback:Function) : void
      {
         if(DataManager != null)
         {
            DataManager.unbind(cDataID,cCallback);
         }
      }
      
      protected function setBindData(cDataID:*, cValue:Object) : void
      {
         if(DataManager != null)
         {
            DataManager.setBindData(cDataID,cValue);
         }
      }
      
      protected function addDP(cDataID:*, cProvider:Function) : void
      {
         if(DataManager != null)
         {
            DataManager.addDP(cDataID,cProvider);
         }
      }
      
      protected function getDP(cDataID:*, cParams:Array = null) : *
      {
         if(DataManager != null)
         {
            return DataManager.getDP(cDataID,cParams);
         }
         return null;
      }
      
      protected function removeDP(cDataID:*, cProvider:Function) : void
      {
         if(DataManager != null)
         {
            DataManager.removeDP(cDataID,cProvider);
         }
      }
      
      public function addComponentListener(component:DisplayObject, listener:ComponentListener) : void
      {
         if(this._componentListeners == null)
         {
            this._componentListeners = new Dictionary(true);
         }
         this._componentListeners[component] = listener;
      }
      
      public function removeComponentListener(component:DisplayObject) : void
      {
         if(this._componentListeners == null)
         {
            return;
         }
         delete this._componentListeners[component];
      }
      
      public function dispatchComponentEvent(id:uint) : void
      {
         var listener:ComponentListener = null;
         if(this._componentListeners != null)
         {
            for each(listener in this._componentListeners)
            {
               listener.onComponentEvent(id);
            }
         }
      }
      
      public function getUiCpp() : UiCppView
      {
         return this._uiCpp;
      }
      
      final protected function get isDebugMode() : Boolean
      {
         return !ScaleformUtil.isScaleform;
      }
      
      public function onKeyboardEvent(cEvt:KeyboardEvent) : void
      {
      }
   }
}

