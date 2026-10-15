package shaui.component.core
{
   import codo.interfaces.ISoundUtil;
   import codo.interfaces.ITipAbleElement;
   import codo.interfaces.ITipController;
   import codo.interfaces.ITipView;
   import codo.utils.FakeSoundUtil;
   import codo.utils.Logger;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.utils.getDefinitionByName;
   import flash.utils.getQualifiedClassName;
   import shaui.component.event.ComponentEvent;
   
   public class UIComponent extends MovieClip implements ITipAbleElement
   {
      
      public static var TIP_VIEW:ITipView;
      
      public static var TIP_CONTROLLER:ITipController;
      
      public static var STAGE:Stage;
      
      public static var SOUND_UTIL:ISoundUtil = new FakeSoundUtil();
      
      public var getChildNameTag:Function;
      
      protected var _useDefaultTip:Boolean = true;
      
      private var _isInit:Boolean = false;
      
      private var _userVisible:Boolean = true;
      
      private var _delayKeyFrame:uint = 0;
      
      public function UIComponent()
      {
         super();
         mouseEnabled = false;
         mouseChildren = false;
         super.visible = false;
         if(this is IShaUIComponent == true)
         {
            this.realStartInit();
         }
         else
         {
            this.tryCallLater();
         }
      }
      
      public static function getInstanceByClassName(className:String) : UIComponent
      {
         var instance:UIComponent = null;
         var instanceClass:Class = getDefinitionByName(className) as Class;
         if(instanceClass != null)
         {
            instance = new instanceClass() as UIComponent;
            if(instance != null)
            {
               instance.initRightNow();
            }
            return instance;
         }
         return null;
      }
      
      public static function logPrint(str:String) : void
      {
         Logger.print(str);
      }
      
      public static function printStack() : void
      {
         var e:Error = new Error();
         Logger.print(e.getStackTrace());
      }
      
      public function set componentInspectorSetting(value:Boolean) : void
      {
         if(this is IShaUIComponent == true)
         {
            throw new Error("[SHA UI]UIComponent::IShaUIComponent should not have component parameters");
         }
         if(value == false)
         {
            this.realStartInit();
         }
      }
      
      override public function set visible(value:Boolean) : void
      {
         this._userVisible = value;
         if(this._isInit == true)
         {
            super.visible = this._userVisible;
         }
      }
      
      private function initRightNow() : void
      {
         this.removeEventListener(Event.ENTER_FRAME,this.onFirstEnterFrameHandle);
         this.realStartInit();
      }
      
      public function get isInit() : Boolean
      {
         return this._isInit;
      }
      
      override public function get stage() : Stage
      {
         return super.stage || STAGE;
      }
      
      private function startInit() : void
      {
         if(!this._isInit)
         {
            this._isInit = true;
            this.onInit();
         }
      }
      
      private function initListener() : void
      {
         this.onInitListener();
      }
      
      protected function tryCallLater() : void
      {
         this.addEventListener(Event.ENTER_FRAME,this.onFirstEnterFrameHandle);
      }
      
      protected function onFirstEnterFrameHandle(e:Event) : void
      {
         ++this._delayKeyFrame;
         if(this._delayKeyFrame == 1)
         {
            this.realStartInit();
            this.delayInit();
         }
         else if(this._delayKeyFrame >= 3)
         {
            this.removeEventListener(Event.ENTER_FRAME,this.onFirstEnterFrameHandle);
         }
      }
      
      protected function realStartInit() : void
      {
         if(this._isInit == false)
         {
            if(this._userVisible == true)
            {
               super.visible = true;
            }
            this.startInit();
            this.initListener();
            dispatchEvent(new ComponentEvent(ComponentEvent.ON_LOAD));
         }
      }
      
      protected function delayInit() : void
      {
      }
      
      protected function onInit() : void
      {
      }
      
      protected function onInitListener() : void
      {
      }
      
      protected function get currentMatchType() : uint
      {
         return 0;
      }
      
      public function onStyleChangeForMatchType() : void
      {
      }
      
      protected function exportUIName() : void
      {
         Logger.exportUIName(this.getMyFullName());
      }
      
      protected function exportFullPath() : void
      {
         Logger.exportFullPath(this.getMyFullPath());
      }
      
      protected function showTip() : void
      {
         if(TIP_VIEW != null)
         {
            TIP_VIEW.displayTip(this);
         }
      }
      
      protected function hideTip() : void
      {
         if(TIP_VIEW != null)
         {
            TIP_VIEW.removeTip(this);
         }
      }
      
      protected function registerTip(cTipType:uint, cTarget:ITipAbleElement = null, cTipTargetID:String = "", cTipLocString:String = "") : void
      {
         if(TIP_CONTROLLER != null)
         {
            if(cTarget == null)
            {
               cTarget = this;
            }
            TIP_CONTROLLER.registerTip(cTarget,cTipType,cTipTargetID,cTipLocString);
         }
      }
      
      protected function unRegisterTip(cTarget:ITipAbleElement) : void
      {
         if(TIP_CONTROLLER != null)
         {
            if(cTarget == null)
            {
               cTarget = this;
            }
            TIP_CONTROLLER.unRegisterTip(cTarget);
         }
      }
      
      public function set tipEnable(cSwi:Boolean) : void
      {
         this._useDefaultTip = cSwi;
      }
      
      public function get tipEnable() : Boolean
      {
         return this._useDefaultTip;
      }
      
      protected function getMyFullName(needTag:Boolean = true) : String
      {
         var tempFullName:String = getQualifiedClassName(this);
         var tempParent:DisplayObject = this.parent;
         while(tempParent != this.stage && tempParent != null && tempParent.name != "myContainer")
         {
            if(tempParent.name.indexOf("instance") >= 0 || tempParent.name.indexOf("myItemRenderer") >= 0)
            {
               tempFullName = getQualifiedClassName(tempParent) + "." + tempFullName;
            }
            else
            {
               tempFullName = tempParent.name + "." + tempFullName;
            }
            tempParent = tempParent.parent;
         }
         if(tempFullName.indexOf("components::DepthSprite.") == 0)
         {
            tempFullName = tempFullName.substr(51,tempFullName.length - 51);
         }
         tempFullName += "@" + this.name;
         if(needTag == true)
         {
            tempFullName += this.tryGetChildNameTag();
         }
         return tempFullName;
      }
      
      protected function tryGetChildNameTag() : String
      {
         var tempTag:String = "";
         if(this.getChildNameTag != null)
         {
            tempTag = this.getChildNameTag();
            if(tempTag != "")
            {
               tempTag = "$" + tempTag;
            }
         }
         return tempTag;
      }
      
      protected function getMyFullPath() : String
      {
         var tempFullPath:String = this.name;
         var tempParent:DisplayObject = this.parent;
         while(tempParent != this.stage && tempParent != null)
         {
            tempFullPath = tempParent.name + "." + tempFullPath;
            tempParent = tempParent.parent;
         }
         return tempFullPath;
      }
      
      public function get tipTargetID() : String
      {
         return "";
      }
      
      public function get tipLocString() : String
      {
         return "";
      }
      
      public function get tipHitArea() : DisplayObject
      {
         return this;
      }
      
      public function get tipOffset() : Point
      {
         return null;
      }
      
      public function get tipAble() : Boolean
      {
         return false;
      }
   }
}

